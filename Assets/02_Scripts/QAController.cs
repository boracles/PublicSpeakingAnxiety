using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;

public class QAController : MonoBehaviour
{
    /* ――― 모듈 참조 ――― */
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] TTSPlayer            tts;
    [SerializeField] TranscriptBuffer     transcript;   // 위에서 만든 버퍼

    /* ――― 대사 서문 ――― */
    [TextArea] public string intro  = "발표 잘 들었습니다. 발표를 들으면서 궁금한 점이 있었는데요. ";
    [TextArea] public string intro2 = "답변 감사합니다. 추가 질문 하나 더 드리자면요. ";

    const string QuestionSys =
        "You are a helpful assistant.\n" +
        "Return ONLY this schema: { \"questions\": [string, string] }";

    bool busy, triggeredOnce;

    void Update()
    {
        if (triggeredOnce || busy) return;

        bool pressed =
            Input.GetKeyDown(KeyCode.Q) ||
            Input.GetButtonDown("Submit") ||
            OVRInput.GetDown(OVRInput.Button.One);

        if (pressed) StartCoroutine(RunQAFlow());
    }

    IEnumerator RunQAFlow()
    {
        busy = true;

        /* ➀ 발표 요약 → 질문 2개 생성 -------------------------------*/
        string summary = "";
        yield return summarizer.SummarizeNow((s,_) => summary = s);
        if (string.IsNullOrEmpty(summary)){ busy=false; yield break; }

        string qPrompt =
            "다음 발표 요약을 듣고 청중이 할 만한 질문 두 개를 JSON 으로 반환.\n" +
            "Schema: {\"questions\":[string,string]}  여분 텍스트 금지.\n\n" + summary;

        LLMReply rep = default;
        yield return llm.Query(qPrompt, (r,_) => rep = r, QuestionSys);

        var qset = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
        if (qset.questions == null || qset.questions.Length == 0)
        {
            busy=false; 
            yield break;
        }

        /* ➁ 첫 질문 발화 ------------------------------------------*/
        string q1 = qset.questions[ Random.Range(0, qset.questions.Length) ];
        yield return tts.Speak(intro + q1);

        /* ➂ 청중 답변 수집 ----------------------------------------*/
        transcript.Clear();          // 버퍼 비우기
        float timeLimit = 15f;
        while (timeLimit > 0 && !transcript.IsAnswerFinished()) {
            timeLimit -= Time.deltaTime;
            yield return null;
        }
        string answer = transcript.Consume(); 

        /* ➃ 두 번째 질문 생성 -------------------------------------*/
        string followPrompt =
            $"발표 요약: {summary}\n" +
            $"내 질문: {q1}\n" +
            $"청중 답변: {(string.IsNullOrEmpty(answer) ? "답변 없음" : answer)}\n\n" +
            "대화를 이어갈 추가 질문을 한 문장으로 작성. 질문만 출력.";

        string q2 = "";
        yield return llm.Query(followPrompt,(r,_)=> q2 = r.answer.Trim());

        /* ➄ 두 번째 질문 발화 -------------------------------------*/
        if (!string.IsNullOrEmpty(q2))
            yield return tts.Speak(intro2 + q2);

        /* 종료 플래그 ---------------------------------------------*/
        triggeredOnce = true;   // 한 번만 동작하게 할 경우
        busy = false;
    }
}
