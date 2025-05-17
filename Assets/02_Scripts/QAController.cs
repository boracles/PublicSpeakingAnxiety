using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;

public enum FeedbackMode { None, Gesture, Spatial }

public class QAController : MonoBehaviour {
    enum Stage { Idle, Asking1, WaitAns1, Asking2, WaitAns2, Closing, Done }

    [Header("Deps")]
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] public TTSPlayer            tts;
    [SerializeField] TranscriptBuffer     transcript;

    [Header("Avatar & FX")]
    [SerializeField] Animator  avatarGesture;
    [SerializeField] BarLightPulse barLight;
    [SerializeField] AudioSource fxSource;
    [SerializeField] AudioClip   spatialSfx;    // ★ 추가

    [Header("Mentions / Delay")]
    [TextArea] public string intro  = "발표 잘 들었습니다. 발표를 들으면서 궁금한 점이 있었는데요. ";
    [TextArea] public string intro2 = "답변 감사합니다. 추가 질문 하나 더 드리자면요. ";
    [TextArea] public string outro  = "답변 감사합니다. 발표는 여기서 마치겠습니다.";
    [Range(0,3)] public float delaySec = 1.5f;     // 모든 질문 동일 지연

    public System.Action OnIntroButton;
    
    const string QuestionSys =
        "You are a helpful assistant.\nReturn ONLY this schema: { \"questions\": [string, string] }";

    Stage stage = Stage.Idle;
    bool  busy, answerDone, waitForRelease;
    FeedbackMode currentMode;                      // ExperimentManager 에서 주입

    /* ───────── 외부에서 세트마다 호출 ───────── */
    public IEnumerator RunTwoQuestions(FeedbackMode mode) {
        currentMode = mode;
        yield return QAFlow();
    }

    public void OnButtonPressed() {
        if (waitForRelease) return;
        waitForRelease = true;

        switch (stage) {
            case Stage.Idle:              // 발표 시작 신호
                OnIntroButton?.Invoke();  // ExperimentManager 쪽 플래그 켜기
                break;

            case Stage.WaitAns1:
            case Stage.WaitAns2:
                answerDone = true;        // 답변 완료
                break;
        }
    }

    public void OnButtonReleased() => waitForRelease = false;
    
    IEnumerator QAFlow() {
        busy = true;

        /* 1️⃣ 요약 → 질문 2개 생성 */
        string summary = "";
        yield return summarizer.SummarizeNow((s,_)=> summary=s);
        if (string.IsNullOrEmpty(summary)) { Reset(); yield break; }

        string prompt =
          "다음 발표 요약을 듣고 청중이 할 만한 질문 두 개를 JSON 으로 반환.\n" +
          "Schema:{\"questions\":[string,string]} 여분 텍스트 금지.\n\n" + summary;

        LLMReply rep = default;
        yield return llm.Query(prompt,(r,_)=> rep=r, QuestionSys);

        var qs = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
        if (qs == null || qs.questions == null || qs.questions.Length < 2) { Reset(); yield break; }

        string q1 = qs.questions[0];
        string q2 = qs.questions[1];

        /* ── Q1 ───────────────────────────── */
        stage = Stage.Asking1;
        yield return WaitFixedDelay();              // ← 여기
        yield return tts.Speak(intro + q1);

        stage = Stage.WaitAns1;
        yield return WaitForButtonOrTimeout(30f);

        /* ── Q2 ───────────────────────────── */
        stage = Stage.Asking2;
        yield return WaitFixedDelay();              // ← 그리고 여기
        yield return tts.Speak(intro2 + q2);

        stage = Stage.WaitAns2;
        yield return WaitForButtonOrTimeout(30f);

        /* ── 클로징 ──────────────────────── */
        stage = Stage.Closing;
        yield return tts.Speak(outro);

        stage = Stage.Done;
        busy  = false;
    }

    /* 버튼 or 타임아웃 */
    IEnumerator WaitForButtonOrTimeout(float sec) {
        answerDone = false; transcript.Clear();
        float t = sec;
        while (!answerDone && t > 0f) { t -= Time.deltaTime; yield return null; }
    }

/*------------ WaitFixedDelay() -------------*/
    IEnumerator WaitFixedDelay()
    {
        if (currentMode == FeedbackMode.Spatial)
        {
            /* ✦ 라이트바 ON ✦ */
            barLight.Begin();

            /* ✦ 효과음 ✦ */
            if (spatialSfx && fxSource)
                fxSource.PlayOneShot(spatialSfx, 0.8f);   // 볼륨 0.8
        }

        if (currentMode == FeedbackMode.Gesture)
        {
            avatarGesture.SetTrigger("Listening");
            yield return new WaitForSeconds(0.6f);
            tts.PlayCached("음…");
            yield return new WaitForSeconds(0.1f);
        }

        float sec = DelayManager.I ? DelayManager.I.CalcDelayFixed() : 1.5f;
        yield return new WaitForSeconds(sec);

        /* ─ 지연 종료 ─ */
        if (currentMode == FeedbackMode.Spatial)
        {
            barLight.End();
        }
    }

    public void Reset() { stage = Stage.Idle; busy = answerDone = waitForRelease = false; }
}
