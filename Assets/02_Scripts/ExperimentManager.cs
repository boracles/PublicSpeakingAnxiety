using UnityEngine;
using System.Collections;
using TMPro;

#if UNITY_EDITOR
using UnityEditor;
#endif

public class ExperimentManager : MonoBehaviour 
{
    [SerializeField] QAController qa;
    [SerializeField] Animator     avatarGesture;     // Clap 트리거 줄 대상
    [SerializeField] float presentationSec = 300f;     
   
    [SerializeField] TextMeshProUGUI   timerText;   
    [SerializeField] TextMeshProUGUI modeText;  
    
    [SerializeField] string participantId = "P01"; 
    
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
        StartCoroutine(InitAndRun());
    }
    
    IEnumerator InitAndRun()
    {
        // filler 미리 캐시
        yield return qa.tts.Preload("음…");

        Shuffle(order);
        yield return MainRoutine();
    }

    IEnumerator MainRoutine() 
    {
        int doneCount = 0;    
        
        LogRecorder.I.LogEvent("SessionStart");
        
        for (int i = 0; i < order.Length; i++)
        {
            /* ✅ 모드 라벨 갱신 */
            if (modeText) modeText.text = ModeLabel(order[i]);
            
            /* 0️⃣ 발표 시작 멘트 */
            yield return qa.tts.Speak(startMent[i]);
            yield return WaitForStartButton();           // 발표자가 A 버튼 눌러 “발표 종료” 신호

            /* 🔸 STT 최종 패킷이 들어올 시간을 0.5 s 확보 */
            yield return new WaitForSeconds(0.5f);

            /* 1️⃣ Q&A 세트 */
            yield return qa.RunTwoQuestions(order[i]);

            /* 2️⃣ 발표 종료 처리 */
            doneCount++;
        }

        if (modeText) modeText.text = "";

/* TTS 종료 멘트 */
        yield return qa.tts.Speak("실험이 모두 종료되었습니다. 참여해 주셔서 감사합니다.");
        
        LogRecorder.I.LogEvent("SessionEnd");
        
        LogRecorder.I.participant = participantId; // LogRecorder 필드
        LogRecorder.I.SaveToFile();

        /* 5 초 대기 후 프로그램 종료 */
        yield return new WaitForSeconds(3.0f);

#if UNITY_EDITOR
        EditorApplication.isPlaying = false;
#else
Application.Quit();
#endif
    }

    /* 모드 enum → 읽기 쉬운 문자열 */
    string ModeLabel(FeedbackMode m)
    {
        return m switch
        {
            FeedbackMode.None    => "No-Feedback Mode",
            FeedbackMode.Spatial => "Spatial Mode",
            FeedbackMode.Gesture => "Gesture Mode",
            _                    => m.ToString()
        };
    }
    
    string Format(float s)
    {
        s = Mathf.Max(0f, s);
        int m = Mathf.FloorToInt(s / 60f);
        int sec = Mathf.FloorToInt(s % 60f);
        return $"{m}:{sec:00}";
    }

    IEnumerator WaitForStartButton()           // 발표자가 A 버튼 누를 때까지
    {
        qa.Reset();  
        qa.transcript.Clear(); 
        qa.ResetSummarizer();
        
        bool pressed = false;
        System.Action handler = () => pressed = true;
        qa.OnIntroButton += handler;      
        
        float remain = presentationSec;
        if (timerText) timerText.text = Format(remain);
        
        while (!pressed)                      // ⬅️ ‘버튼 누를 때까지’로 변경
        {
            if (remain > 0f)
            {
                remain -= Time.deltaTime;
                if (remain <= 0f)   // 0 이하로 내려가면 0 으로 고정
                {
                    remain = 0f;
                    if (timerText) timerText.text = "0:00";
                }
                else
                {
                    if (timerText) timerText.text = Format(remain);
                }
            }
            yield return null;
        }
        
        qa.OnIntroButton -= handler; 
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