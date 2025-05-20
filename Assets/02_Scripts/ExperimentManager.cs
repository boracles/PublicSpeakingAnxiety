using UnityEngine;
using System.Collections;
using TMPro;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class ExperimentManager : MonoBehaviour
{
    [SerializeField] QAController        qa;
    [SerializeField] PdfScreenController pdfScreen;
    [SerializeField] TextMeshProUGUI     timerText;
    [SerializeField] TextMeshProUGUI     modeText;
    [SerializeField] float               presentationSec = 300f;
    [SerializeField] string              participantId   = "P01";

    [TextArea]
    [SerializeField] string[] startMent = {
        "첫 번째 발표를 시작하겠습니다. 준비되면 시작해주세요.",
        "이제 두 번째 발표를 시작해 주세요.",
        "마지막 세 번째 발표를 시작해 주세요."
    };

    FeedbackMode[] order =
    {
        FeedbackMode.None,     // 0
        FeedbackMode.Gesture,  // 1
        FeedbackMode.Spatial   // 2
    };

    /* ─────────────────────────── */

    void Start() => StartCoroutine(InitAndRun());

    IEnumerator InitAndRun()
    {
        yield return qa.tts.Preload("음…");
        
        if (qa.barLight) qa.barLight.BlinkOnce(0.3f);
        
        Shuffle(order);                      // 세션 순서 무작위
        yield return MainRoutine();
    }

    string ModeSpeech(FeedbackMode m) => m switch
    {
         FeedbackMode.None    => "이번 발표는 피드백이 없는 모드입니다.",
         FeedbackMode.Gesture => "이번 발표는 제스처 피드백 모드입니다.",
         FeedbackMode.Spatial => "이번 발표는 스페이셜 피드백 모드입니다.",
         _                    => "이번 발표 모드를 설정할 수 없습니다."
    };
    
    IEnumerator MainRoutine()
    {
        /* 0. 로그 시작 */
        LogRecorder.I.BeginLogging(participantId);

        for (int sessionIdx = 0; sessionIdx < order.Length; sessionIdx++)
        {
            var mode = order[sessionIdx];
            
            LogRecorder.I.conditionId = (int)mode;                 // 0/1/2
            LogRecorder.I.LogEvent("COND_START", mode.ToString());
            pdfScreen.ShowPage(sessionIdx);                        // 0→1→2
            
            if (modeText)
            {
                modeText.color = modeColors[(int)mode];   // ← 색 지정
                modeText.text  = ModeLabel(mode);         // ← 라벨 지정
            }

            qa.Reset();
            qa.transcript.Clear();
            qa.ResetSummarizer();


            yield return qa.tts.Speak(ModeSpeech(mode));
            /* 3. 발표 안내 & 발표 대기 */
            yield return qa.tts.Speak(startMent[sessionIdx]);
            yield return WaitForStartButton();

            /* 4. Q&A (질문 2개 예시) */
            yield return qa.RunTwoQuestions(mode);

            LogRecorder.I.LogEvent("COND_END", mode.ToString());
        }

        if (modeText) modeText.text = "";

        /* 5. 종료 멘트 */
        yield return qa.tts.Speak("실험이 모두 종료되었습니다. 참여해 주셔서 감사합니다.");

        /* 6. 로그 닫기 */
        LogRecorder.I.CloseAll();

        /* 7. 종료 대기 & 앱 종료 */
        yield return new WaitForSeconds(2.0f);
#if UNITY_EDITOR
        EditorApplication.isPlaying = false;
#else
        Application.Quit();
#endif
    }

    static readonly Color32[] modeColors =
    {
        new(0xAA,0xAA,0xAA,255),   // None   → 회색
        new(0xF6,0xB3,0x00,255),   // Gesture→ 주황
        new(0x4E,0xB3,0xFF,255)    // Spatial→ 파랑
    };

    string ModeLabel(FeedbackMode m) => m switch
    {
        FeedbackMode.None    => "No-Feedback Mode",
        FeedbackMode.Gesture => "Gesture Mode",
        FeedbackMode.Spatial => "Spatial Mode",
        _                    => m.ToString()
    };

    IEnumerator WaitForStartButton()
    {
        bool pressed = false;
 
        System.Action handler = () => pressed = true;
        qa.OnIntroButton += handler;

        float remain = presentationSec;
        if (timerText) timerText.text = Format(remain);

        while (!pressed)
        {
            if (remain > 0f)
            {
                remain -= Time.deltaTime;
                timerText.text = Format(Mathf.Max(remain, 0f));
            }
            yield return null;
        }
        qa.OnIntroButton -= handler;
    }

    string Format(float s)
    {
        int m   = Mathf.FloorToInt(s / 60f);
        int sec = Mathf.FloorToInt(s % 60f);
        return $"{m}:{sec:00}";
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
