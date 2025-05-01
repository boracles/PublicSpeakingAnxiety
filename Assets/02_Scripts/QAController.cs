using UnityEngine;
using System.Collections;

public class QAController : MonoBehaviour
{
    [SerializeField] IncrementalSummarizer summarizer;
    [SerializeField] LLMClient             llm;
    [SerializeField] TTSPlayer             tts;
    [SerializeField] AvatarFSM             avatar;
    [SerializeField] DelayManager          delay;

    bool busy;

    // 발표 종료 트리거 – 여기선 키 'Q' 누르면 질문 생성
    void Update()
    { if (Input.GetKeyDown(KeyCode.Q) && !busy)
        StartCoroutine(CreateQuestions()); }

    IEnumerator CreateQuestions()
    {
        busy = true; string ctx = summarizer.Get5MinSummary();
        string prompt = "다음 발표 요약을 읽고 청중이 할만한 질문 1~3개를 JSON으로:\n"+ctx;

        LLMReply rep = default; float lat = 0;
        yield return llm.Query(prompt, (r,t)=>{rep=r; lat=t;});

        delay.RecordLLM(lat);
        foreach(var q in JsonUtility.FromJson<LLMQuestionSet>(rep.answer).questions)
        {
            avatar.RaiseHand();
            yield return tts.Speak(q,1.0f);
            yield return new WaitForSeconds(0.5f);
        }
        avatar.ToIdle();
        busy = false;
    }
}

