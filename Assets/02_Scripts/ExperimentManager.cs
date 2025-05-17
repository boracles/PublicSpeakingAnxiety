using UnityEngine;
using System.Collections;

public class ExperimentManager : MonoBehaviour 
{
    [SerializeField] QAController qa;
    [SerializeField] Animator     avatarGesture;     // Clap 트리거 줄 대상
    [SerializeField] float presentationSec = 300f;      // 5분

    [SerializeField][TextArea] string[] startMent = {
        "첫 번째 발표를 시작하겠습니다. 준비되면 시작해주세요.",
        "이제 두 번째 발표를 시작해 주세요.",
        "마지막 세 번째 발표를 시작해 주세요."
    };
    
    FeedbackMode[] order = 
    { 
        FeedbackMode.None,
        FeedbackMode.Gesture,
        FeedbackMode.Spatial 
    };

    void Start() 
    {
        Shuffle(order);          // Fisher–Yates 무작위
        StartCoroutine(MainRoutine());
    }

    IEnumerator MainRoutine() 
    {
        int doneCount = 0;    
        
        for (int i = 0; i < order.Length; i++)
        {
            /* 0️⃣ 발표 시작 멘트 */
            yield return qa.tts.Speak(startMent[i]);
            yield return WaitForStartButton();

            /* 1️⃣ Q&A 세트 */
            yield return qa.RunTwoQuestions(order[i]);

            /* 2️⃣ 발표 종료 처리 */
            doneCount++;

            if (doneCount == 3)            // ← 세 번째 발표 종료!
            {
                avatarGesture.SetTrigger("Clap");
                // Sit → Clap 전이 조건: Clap(Trigger) 이어야 함
            }
        }

        /* 3️⃣ 실험 끝 멘트 */
        yield return qa.tts.Speak("실험이 모두 종료되었습니다. 참여해 주셔서 감사합니다.");
    }


    IEnumerator WaitForStartButton()           // 발표자가 A 버튼 누를 때까지
    {
        qa.Reset();
        bool pressed = false;
        qa.OnIntroButton = () => pressed = true;
        while (!pressed) yield return null;
    }

    void Shuffle(FeedbackMode[] arr)
    {
        for (int i = arr.Length - 1; i > 0; --i)
        {
            int j = Random.Range(0, i + 1);
            (arr[i], arr[j]) = (arr[j], arr[i]);
        }
    }
}