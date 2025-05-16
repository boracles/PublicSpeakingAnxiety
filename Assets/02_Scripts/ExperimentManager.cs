using UnityEngine;
using System.Collections;

public class ExperimentManager : MonoBehaviour {
    [SerializeField] QAController qa;
    [SerializeField] float presentationSec = 300f;      // 5분

    [SerializeField][TextArea] string[] startMent = {
        "첫 번째 발표를 시작하겠습니다. 준비되면 시작해주세요.",
        "이제 두 번째 발표를 시작해 주세요.",
        "마지막 세 번째 발표를 시작해 주세요."
    };
    
    FeedbackMode[] order = { FeedbackMode.None,
        FeedbackMode.Gesture,
        FeedbackMode.Spatial };

    void Start() {
        Shuffle(order);          // Fisher–Yates 무작위
        StartCoroutine(MainRoutine());
    }

    IEnumerator MainRoutine() {
        int idx = 0;
        foreach (var mode in order) 
        { /* 0️⃣ 발표 시작 멘트 ----------------------------- */
            yield return qa.tts.Speak( startMent[idx++] );  // TTS 완전히 끝날 때까지 대기

            yield return WaitForStartButton(); 

            /* 2️⃣ 질문 2개 세트 ------------------------------ */
            yield return qa.RunTwoQuestions(mode);
        }

        /* 모든 세트 종료 후 */
        yield return qa.tts.Speak("실험이 모두 종료되었습니다. 참여해 주셔서 감사합니다.");
    }


    IEnumerator WaitForStartButton()           // 발표자가 A 버튼 누를 때까지
    {
        qa.Reset();                            // QAController 상태 초기화
        bool pressed = false;
        qa.OnIntroButton = () => pressed = true;   // 버튼 콜백 받아두기
        while (!pressed) yield return null;        // 눌릴 때까지 대기
    }

    /* Fisher-Yates */
    void Shuffle(FeedbackMode[] arr) {
        for (int i = arr.Length-1; i > 0; --i) {
            int j = Random.Range(0, i+1);
            (arr[i], arr[j]) = (arr[j], arr[i]);
        }
    }
}