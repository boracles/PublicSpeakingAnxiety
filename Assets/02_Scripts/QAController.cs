using UnityEngine;
using System.Collections;

public enum FeedbackMode { None, Gesture, Spatial }

public class QAController : MonoBehaviour {
    enum Stage { Idle, Asking1, WaitAns1, Asking2, WaitAns2, Closing, Done }

    [Header("Deps")]
    [SerializeField] public IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] public TTSPlayer            tts;
    [SerializeField] public TranscriptBuffer     transcript;

    [Header("Avatar & FX")]
    [SerializeField] Animator  avatarGesture;
    [SerializeField] BarLightPulse barLight;
    [SerializeField] AudioSource fxSource;
    [SerializeField] AudioClip   spatialSfx;    // ★ 추가

    [Header("Mentions / Delay")]
    [TextArea] public string intro  = "발표 잘 들었습니다. 발표를 들으면서 궁금한 점이 있었는데요. ";
    [TextArea] public string intro2 = "답변 감사합니다. 추가 질문 하나 더 드리자면요. ";
    [TextArea] public string outro  = "답변 감사합니다. 발표는 여기서 마치겠습니다.";

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
    
    IEnumerator QAFlow() 
    {
        busy = true;
        
        yield return PlayImmediateFeedback(); 
        
        string summary = "";
        yield return summarizer.SummarizeNow((s,_) => summary = s);
        
        if (string.IsNullOrEmpty(summary))
        {
            summary = transcript.LatestRaw ?? "(발표 요약을 사용할 수 없음)";
        }

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
        yield return PlayDelay(false);          // filler X, 지연만
        yield return tts.Speak(intro + q1);
        
        stage = Stage.WaitAns1;
        yield return WaitForButtonOrTimeout(30f);  // A 버튼 눌림
        yield return new WaitForSeconds(0.5f);    

        /* ── Q2 ───────────────────────────── */
        stage = Stage.Asking2;
        yield return PlayDelay(true);           // filler O, 지연 O
        yield return tts.Speak(intro2 + q2);

        stage = Stage.WaitAns2;
        yield return WaitForButtonOrTimeout(30f);

        /* ── 클로징 ──────────────────────── */
        stage = Stage.Closing;
        yield return tts.Speak(outro);

        stage = Stage.Done;
        busy  = false;
    }
    
    IEnumerator PlayImmediateFeedback()
    {
        if (currentMode == FeedbackMode.Gesture)
        {
            tts.PlayCached("음…");
            avatarGesture.SetTrigger("Listening");
            yield return new WaitForSeconds(0.12f);   // filler 길이만큼만 대기
        }
        else if (currentMode == FeedbackMode.Spatial)
        {
            barLight.Begin();
            if (spatialSfx && fxSource) fxSource.PlayOneShot(spatialSfx, 0.8f);
            yield return new WaitForSeconds(0.12f);   // 같은 길이로 통일
            barLight.End();                           // 바로 끄고 펄스 효과만!
        }
    }

    
    IEnumerator PlayDelay(bool withFiller)
    {
        bool lightWasOn = false;             // ★ 추가

        if (withFiller)
        {
            if (currentMode == FeedbackMode.Gesture)
            {
                tts.PlayCached("음…");
                avatarGesture.SetTrigger("Listening");
                yield return new WaitForSeconds(0.12f);
            }
            else if (currentMode == FeedbackMode.Spatial)
            {
                barLight.Begin();
                lightWasOn = true;            // ★
                if (spatialSfx && fxSource) fxSource.PlayOneShot(spatialSfx, 0.8f);
            }
        }

        /* 고정 지연 */
        float sec = DelayManager.I ? DelayManager.I.CalcDelayFixed() : 1.5f;
        yield return new WaitForSeconds(sec);

        /* Spatial 모드라면 항상 OFF (withFiller 여부 무관) */
        if (currentMode == FeedbackMode.Spatial && lightWasOn)
            barLight.End();
    }


    /* 버튼 or 타임아웃 */
    IEnumerator WaitForButtonOrTimeout(float sec) 
    {
        answerDone = false; 
        transcript.Clear();
        float t = sec;

        while (!answerDone && t > 0f)
        {
            t -= Time.deltaTime; 
            yield return null;
        }
        
        waitForRelease = false; 
    }

    public void Reset() { stage = Stage.Idle; busy = answerDone = waitForRelease = false; }
    
    public void ResetSummarizer()
        { 
            if (summarizer) summarizer.ResetContext();
        }
}
