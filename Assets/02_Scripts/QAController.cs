using UnityEngine;
using System.Collections;
using System;
using System.Collections.Generic;

public enum FeedbackMode { Gesture, Spatial }

public class QAController : MonoBehaviour {
    enum Stage { Idle, Asking1, WaitAns1, Asking2, WaitAns2, Closing, Done }

    [Header("Deps")]
    [SerializeField] public IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] public TTSPlayer            tts;
    [SerializeField] public TranscriptBuffer     transcript;

    [Header("Avatar & FX")]
    [SerializeField] Animator  avatarGesture;
    [SerializeField] public BarLightPulse barLight;
    [SerializeField] AudioSource fxSource;
    [SerializeField] AudioClip   spatialSfx;    // ★ 추가

    [Header("Mentions / Delay")]
    [TextArea] public string intro  = "발표 잘 들었습니다. 발표를 들으면서 궁금한 점이 있었는데요. ";
    [TextArea] public string intro2 = "답변 감사합니다. 추가 질문 하나 더 드리자면요. ";
    [TextArea] public string outro  = "답변 감사합니다. 발표는 여기서 마치겠습니다.";

    public System.Action OnIntroButton;
    bool firstDelayDone = false; 
    
    const string QuestionSys =
        "You are a helpful assistant.\nReturn ONLY this schema: { \"questions\": [string, string] }";

    Stage stage = Stage.Idle;
    bool  busy, answerDone, waitForRelease;
    FeedbackMode currentMode;
    
    readonly HashSet<string> askedGlobal = new();

    /* ───────── 외부에서 세트마다 호출 ───────── */
    public IEnumerator RunTwoQuestions(FeedbackMode mode) {
        currentMode = mode;
        yield return QAFlow();
    }

    public void OnButtonPressed()
    {
        if (waitForRelease) return;     // 디바운스
        waitForRelease = true;

        if (stage == Stage.Idle)
            OnIntroButton?.Invoke();
        else if (stage == Stage.WaitAns1 || stage == Stage.WaitAns2)
            answerDone = true;
    }

    public void OnButtonReleased() => waitForRelease = false;
    
    IEnumerator GenerateQuestions(string summary, Action<string,string> onDone)
    {
        const int MAX_RETRY = 2;
        int        attempt  = 0;

        while (attempt <= MAX_RETRY)
        {
            /* 📌 1) 프롬프트에 blacklist 삽입 */
            string blacklist = string.Join(" / ", askedGlobal);
            string prompt =
                "다음 발표 요약을 듣고, **이전 발표에서 이미 나온 질문과 겹치지 않는** " +
                "청중 질문 두 개를 JSON 으로 반환.\n" +
                $"(절대 사용 금지 질문: {blacklist})\n\n" +
                summary +
                "\nSchema:{\"questions\":[string,string]} 여분 텍스트 금지.";

            LLMReply rep = default;
            yield return llm.Query(prompt, (r,_) => rep = r, QuestionSys);

            var set = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
            if (set?.questions == null || set.questions.Length < 2)
            {
                attempt++;          // 파싱 실패 → 재시도
                continue;
            }

            string q1 = set.questions[0].Trim().ToLower();
            string q2 = set.questions[1].Trim().ToLower();

            /* 📌 2) 중복 여부 검사 */
            if (!askedGlobal.Contains(q1) && !askedGlobal.Contains(q2))
            {
                askedGlobal.Add(q1);
                askedGlobal.Add(q2);
                onDone?.Invoke(set.questions[0], set.questions[1]);
                yield break;        // ✅ 성공
            }

            attempt++;              // 중복이면 재요청
        }

        /* -- 3회 모두 실패하면 fallback */
        Debug.LogWarning("⚠️ 중복 제거 실패 – 마지막 결과 사용");
        onDone?.Invoke("죄송합니다. 질문을 생성하지 못했습니다.",
            "발표 내용을 다시 정리해 주실 수 있나요?");
    }
    
    /* -------------------- QAController.cs -------------------- */
    IEnumerator QAFlow()
    {
        busy = true;

        /* 0️⃣ 지연-피드백(“음…”, 라이트바 등) */
        yield return PlayImmediateFeedback();

        /* 1️⃣ 발표 요약 획득 */
        string summary = "";
        yield return summarizer.SummarizeNow((s, _) => summary = s);
        if (string.IsNullOrEmpty(summary))
            summary = transcript.LatestRaw ?? "(발표 요약을 사용할 수 없음)";

        /* 2️⃣ 질문 2개 생성 -- 중복 필터링은 GenerateQuestions 내부에서 처리 */
        string q1 = null, q2 = null;
        yield return GenerateQuestions(summary, (a, b) => { q1 = a; q2 = b; });

        /* 2-1) 혹시라도 실패하면 기본 문장으로 대체 */
        if (string.IsNullOrEmpty(q1) || string.IsNullOrEmpty(q2))
        {
            q1 = "발표 내용을 좀 더 자세히 설명해 주실 수 있나요?";
            q2 = "앞으로의 추가 연구 계획이 있으신가요?";
        }

        /* ───────── Q1 ───────────────────────── */
        stage = Stage.Asking1;
        bool needLoop = currentMode == FeedbackMode.Spatial;  
        yield return PlayDelay(needLoop); 
        yield return tts.Speak(intro + q1);

        stage = Stage.WaitAns1;
        yield return WaitForAnswerButton();      // 참가자가 A버튼 누를 때까지
        yield return new WaitForSeconds(0.5f);   // STT 마지막 패킷 여유

        /* ───────── Q2 ───────────────────────── */
        stage = Stage.Asking2;
        yield return PlayDelay(true);            // filler O, 고정지연 O
        yield return tts.Speak(intro2 + q2);

        stage = Stage.WaitAns2;
        yield return WaitForAnswerButton();

        /* ───────── 클로징 ───────────────────── */
        stage = Stage.Closing;
        yield return tts.Speak(outro);

        stage  = Stage.Done;
        busy   = false;
    }

    IEnumerator PlayImmediateFeedback()
    {
        if (currentMode == FeedbackMode.Gesture)
        {
            tts.PlayCached("음…");
            avatarGesture.SetTrigger("Listening");
            yield return new WaitForSeconds(0.12f);
        }
        else if (currentMode == FeedbackMode.Spatial)
        {
            barLight.PulseLoop();         // ▶ 한번만 번쩍
            if (spatialSfx && fxSource && !fxSource.isPlaying)
            {
                fxSource.clip = spatialSfx;
                fxSource.loop = true;
                fxSource.Play();
            }
        }
    }

    IEnumerator PlayDelay(bool  withFillerRequest)
    {
        bool useFiller =
            withFillerRequest ||                        // 호출자가 요청했거나
            (!firstDelayDone && currentMode == FeedbackMode.Spatial); // Spatial 모드라면

        firstDelayDone = true;    
        
        bool loopRunning = barLight.IsLooping;

        if (useFiller && currentMode == FeedbackMode.Spatial)
        {
            if (!loopRunning)
            {
                barLight.PulseLoop();
                if (spatialSfx && fxSource)
                {
                    fxSource.clip = spatialSfx;
                    fxSource.loop = true;
                    fxSource.Play();
                }
                loopRunning = true;
            }
        }
        else if (useFiller && currentMode == FeedbackMode.Gesture)
        {
            tts.PlayCached("음…");
            avatarGesture.SetTrigger("Listening");
            yield return new WaitForSeconds(0.12f);
        }

        /* ---------- 고정 지연 ---------- */
        float sec = DelayManager.I ? DelayManager.I.CalcDelayFixed() : 1.5f;
        yield return new WaitForSeconds(sec);

        /* ---------- 루프 정지 ---------- */
        if (loopRunning)
        {
            barLight.StopLoop();
            fxSource.Stop();
            fxSource.loop = false;
        }
    }



    /* ───────── A 버튼이 눌릴 때까지 (타임아웃 없음) ───────── */
    IEnumerator WaitForAnswerButton()
    {
        answerDone     = false;      // 플래그 초기화
        waitForRelease = false;      // 디바운스 해제
        transcript.Clear();          // STT 버퍼 비우기

        while (!answerDone)          // 버튼을 누를 때까지 루프
            yield return null;
    }

    public void Reset() { stage = Stage.Idle; busy = answerDone = waitForRelease = false; }
    
    public void ResetSummarizer()
        { 
            if (summarizer) summarizer.ResetContext();
        }
}
