using UnityEngine;
using System.Collections;
using System.Text;

public class IncrementalSummarizer : MonoBehaviour
{
    [Header("References")]
    [SerializeField] SpeechRecognizer stt;
    [SerializeField] LLMClient        llm;

    readonly StringBuilder fullBuf = new();
    public  string GetFullContext() => fullBuf.ToString();   // 호출용

    /* ───────── STT 누적 ───────── */
    void OnEnable()  => stt.OnText += OnSentence;
    void OnDisable() => stt.OnText -= OnSentence;

    void OnSentence(string txt, bool final)
    {
        if (!final) return;
        fullBuf.AppendLine(txt);
    }

    /* ───────── 지금까지 누적분을 요약해서 콜백 ───────── */
    public IEnumerator SummarizeNow(System.Action<string,float> onDone)
    {
        string ctx = fullBuf.ToString();
        if (string.IsNullOrWhiteSpace(ctx))
        {
            Debug.LogWarning("📂 누적된 텍스트가 없습니다.");
            yield break;
        }

        string prompt =
            "다음 발표 전체 내용을 핵심 정보가 빠지지 않도록 " +
            "정확하게 요약해 줘. 가능하면 불필요한 장황함은 줄여 줘:\n" + ctx;

        yield return llm.Query(prompt, (LLMReply rep, float t) =>
        {
            Debug.Log($"🧾 전체 요약({t:F1}s): {rep.answer}");
            onDone?.Invoke(rep.answer, t);
        });

        // 필요하면 요약 후 버퍼 초기화
        // fullBuf.Clear();
    }
    
    public void ResetContext()
    {
        fullBuf.Clear();      // 누적 텍스트 초기화
    }

}