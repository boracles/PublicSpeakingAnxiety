using UnityEngine;
using System.Collections;

public class QAController : MonoBehaviour
{
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;

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

        /* 1️⃣ 요약 얻기 */
        string summary = "";
        yield return summarizer.SummarizeNow((sum, _) => summary = sum);

        if (string.IsNullOrWhiteSpace(summary))
        { busy = false; yield break; }

        /* 2️⃣ 질문 2개 생성용 프롬프트 */
        string questionPrompt =
            "다음 요약을 바탕으로 청중이 할 만한 질문 2개를 " +
            "아래 JSON 스키마로 반환해 줘. 여분 텍스트 금지.\n\n" +
            "Schema:\n{ \"questions\": [string, string] }\n\n" +
            summary;

        /* 3️⃣ LLM 호출 */
        LLMReply rep = default; float lat = 0;
        yield return llm.Query(questionPrompt, (r,t)=>{ rep=r; lat=t; }, QuestionSys);

        /* 4️⃣ 파싱 & 출력 (예외 방어 포함) */
        LLMQuestionSet qset;
        try
        {
            qset = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
            if (qset.questions == null || qset.questions.Length == 0)
                throw new System.Exception("questions array empty");
        }
        catch (System.Exception e)
        {
            Debug.LogWarning("질문 JSON 파싱 실패 ▶ " + e.Message +
                             "\n" + rep.answer);
            busy = false;
            yield break;
        }

        for (int i = 0; i < qset.questions.Length; i++)
            Debug.Log($"❓ Q{i+1}: {qset.questions[i]}");

        busy = false;
        triggeredOnce = true;   // 이후 입력 무시
    }

}