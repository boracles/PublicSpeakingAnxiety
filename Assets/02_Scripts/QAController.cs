using UnityEngine;
using System.Collections;

public class QAController : MonoBehaviour
{
    [Header("모듈 참조")]
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] TTSPlayer            tts; 

    const string QuestionSys =
        "You are a helpful assistant.\n" +
        "Return ONLY this schema: { \"questions\": [string, string] }";

    bool busy;
    bool triggeredOnce;   // 처음 한 번만 허용
    
    void Update()
    {
        if (triggeredOnce) return;

        bool pressed =
            Input.GetKeyDown(KeyCode.Q) ||
            Input.GetButtonDown("Submit") ||
            OVRInput.GetDown(OVRInput.Button.One);

        if (pressed && !busy)
            StartCoroutine(RequestQuestions());
    }

    IEnumerator RequestQuestions()
    {
        busy = true;

        /* 1️⃣ 발표 요약 */
        string summary = "";
        yield return summarizer.SummarizeNow((sum, _) => summary = sum);
        if (string.IsNullOrWhiteSpace(summary)) { busy = false; yield break; }

        /* 2️⃣ 질문 2개 생성 */
        string questionPrompt =
            "다음 요약을 바탕으로 청중이 할 만한 질문 2개를 " +
            "아래 JSON 스키마로 반환해 줘. 여분 텍스트 금지.\n\n" +
            "Schema:\n{ \"questions\": [string, string] }\n\n" +
            summary;
        
        LLMReply rep = default; 
        float lat = 0;
        
        yield return llm.Query(questionPrompt, (r,t)=>{ rep=r; lat=t; }, QuestionSys);
        
        LLMQuestionSet qset;
        try
        {
            qset = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
            if (qset.questions == null || qset.questions.Length == 0)
                throw new System.Exception("questions array empty");
        }
        catch
        {
            busy = false;
            yield break;
        }

        /* ③ 질문별 TTS ‧ Lip-Sync 실행 */
        foreach (string q in qset.questions)
        {
            Debug.Log($"❓ {q}");

            /* (선택) 1.5 s 장지연 + 보상 피드백
                DelayManager / FeedbackType 은 직접 구현한 뒤 사용
             */
            // yield return DelayManager.Inject(1.5f, FeedbackType.SystemClarity);

            bool ok = false;
            yield return StartCoroutine(tts.Speak(q, 1.0f, done => ok = done));
            Debug.Log($"[TTS-DEBUG] clip={tts.source.clip}  " +
                      $"len={tts.source.clip?.length:F2}s  " +
                      $"samples={tts.source.clip?.samples}");
            Debug.Log($"TTS Speak result = {ok}");
        }

        busy = false;
        triggeredOnce = true;   // 이후 입력 무시
    }

}