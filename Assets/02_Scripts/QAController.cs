using UnityEngine;
using System.Collections;
using Random = UnityEngine.Random;

public class QAController : MonoBehaviour
{
    enum Stage { Idle, Asking1, WaitAns1, Asking2, WaitAns2, Closing, Done }

    [Header("Modules")]
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient            llm;
    [SerializeField] TTSPlayer            tts;
    [SerializeField] TranscriptBuffer     transcript;

    [TextArea] public string intro  = "발표 잘 들었습니다. 발표를 들으면서 궁금한 점이 있었는데요. ";
    [TextArea] public string intro2 = "답변 감사합니다. 추가 질문 하나 더 드리자면요. ";
    [TextArea] public string outro = "답변 감사합니다. 발표는 여기서 마치겠습니다.";

    const string QuestionSys =
        "You are a helpful assistant.\nReturn ONLY this schema: { \"questions\": [string, string] }";

    Stage stage = Stage.Idle;
    bool  busy;
    bool  answerDone;
    private bool waitForRelease;

    /* ───────── 호출될 공개 메서드 ───────── */
    /* ───────── 버튼 이벤트 ───────── */
    public void OnButtonPressed()
    {
        if (waitForRelease) return;
        waitForRelease = true;

        switch (stage)
        {
            case Stage.Idle:      if (!busy) StartCoroutine(QAFlow()); break;
            case Stage.WaitAns1:  answerDone = true; break;
            case Stage.WaitAns2:  answerDone = true; break;
        }
    }
    public void OnButtonReleased() => waitForRelease = false;

    IEnumerator QAFlow()
    {
        busy  = true;

        /* 1️⃣ 발표 요약 → 질문 2개 생성 */
        string summary = "";
        yield return summarizer.SummarizeNow((s, _) => summary = s);
        if (string.IsNullOrWhiteSpace(summary)) { Reset(); yield break; }

        string prompt =
            "다음 발표 요약을 듣고 청중이 할 만한 질문 두 개를 JSON 으로 반환.\n" +
            "Schema:{\"questions\":[string,string]} 여분 텍스트 금지.\n\n" + summary;

        LLMReply rep = default;
        yield return llm.Query(prompt, (r, _) => rep = r, QuestionSys);

        var qs = JsonUtility.FromJson<LLMQuestionSet>(rep.answer);
        if (qs == null || qs.questions == null || qs.questions.Length < 2) { Reset(); yield break; }

        string q1 = qs.questions[0];
        string q2 = qs.questions[1];

        /* 2️⃣ 첫 질문 TTS */
        stage = Stage.Asking1;
        yield return tts.Speak(intro + q1);

        /* 3️⃣ 1차 답변 대기 */
        stage = Stage.WaitAns1;
        yield return WaitForButtonOrTimeout(30f);
        string answer1 = transcript.Consume();

        /* 4️⃣ 두 번째 질문 TTS */
        stage = Stage.Asking2;
        yield return tts.Speak(intro2 + q2);

        /* 5️⃣ 2차 답변 대기 */
        stage = Stage.WaitAns2;
        yield return WaitForButtonOrTimeout(30f);
        string answer2 = transcript.Consume();

        /* (선택) answer1·answer2 를 저장·로그 등 활용 가능 */

        /* 6️⃣ 마무리 멘트 */
        stage = Stage.Closing;
        yield return tts.Speak(outro);

        /* 종료 */
        stage = Stage.Done;
        busy  = false;
    }

    /* 침묵 대신 ‘버튼 또는 타임아웃’으로만 종료 */
    IEnumerator WaitForButtonOrTimeout(float sec)
    {
        answerDone = false;
        transcript.Clear();
        float t = sec;
        while (!answerDone && t > 0f) { t -= Time.deltaTime; yield return null; }
    }

    void Reset()
    {
        stage = Stage.Idle;
        busy  = false;
        answerDone     = false;
        waitForRelease = false;
    }
    
}
