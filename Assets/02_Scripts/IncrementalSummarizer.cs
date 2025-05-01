using UnityEngine;
using System.Collections;
using System.Collections.Generic;
using System.Text;
using System.Linq;

public class IncrementalSummarizer : MonoBehaviour
{
    [SerializeField] SpeechRecognizer stt;
    [SerializeField] LLMClient        llm;      // 요약용
    
    readonly StringBuilder segBuf = new();      // 30 s 세그먼트
    readonly List<string>  summaries = new();   // 누적 요약

    float lastSegTime = 0f;
    
    void OnEnable()  => stt.OnText += OnSentence;
    void OnDisable() => stt.OnText -= OnSentence;

    void OnSentence(string txt, bool final)
    {
        if(!final) return;
        segBuf.AppendLine(txt);
        if(Time.time - lastSegTime > 30f)       // 30 s 경과
            StartCoroutine(SummarizeSeg());
    }

    IEnumerator SummarizeSeg()
    {
        lastSegTime = Time.time;
        string seg = segBuf.ToString(); segBuf.Clear();

        string prompt = $"다음 한국어 발표 내용을 한 문장으로 요약해:\n{seg}";
        bool done = false;

        yield return llm.Query(prompt, (LLMReply r, float t) => {
            summaries.Add(r.answer);
            done = true;
        });
        
        while (!done)
            yield return null;
    }

    public string Get5MinSummary()
    {
        // 최근 10개(5분) 요약만 선택
        return string.Join(" ", summaries.TakeLast(10));
    }
}
