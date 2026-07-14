using System;
using UnityEngine;
using UnityEngine.UI;
using TMPro;
using UnityEngine.SceneManagement;

// 🌟 씬 2 안에서 가짜 서버 JSON을 파싱하기 위해 꼭 필요한 데이터 구조입니다!
[Serializable]
public class PresentationSessionData
{
    public Page1BasicInfo page_1_basic_info;
}


public class PresentationStageManager : MonoBehaviour
{
    // 🌟 씬 1과의 연결 고리 플래그
    public static bool IsReturningFromPresentation = false; 

    [Header("--- UI Elements ---")]
    public TMP_Text timerText;          
    public Button toggleTimerButton;    
    public Button endPresentationButton; 

    private float timeRemaining;        
    private bool isTimerRunning = false; 
    private TMP_Text toggleButtonText;   
    private TMP_Text endButtonText;     

    private string mockJsonFromServer = @"
    {
      ""page_1_basic_info"": {
        ""duration_minutes"": 10,
        ""qa_count"": 3
      }
    }";

   void Start()
    {
        // 🌟 씬 1에서 전달받은 데이터 가방(SessionManager)에서 시간 가져오기
        if (SessionManager.Instance != null && SessionManager.Instance.activeSession != null)
        {
            // SessionManager에 저장된 데이터를 사용
            timeRemaining = SessionManager.Instance.activeSession.page_1.duration_minutes * 60f;
            Debug.Log($"[데이터 수신] 발표 시간 설정됨: {timeRemaining}초");
        }
        else
        {
            // 만약 데이터가 없으면 기본값(5분) 설정
            timeRemaining = 5 * 60f; 
            Debug.LogError("SessionManager에서 데이터를 찾을 수 없습니다! 기본값 5분 적용.");
        }
        
        // 💡 주의: timeRemaining = 5f; 이 줄은 테스트용이었으니 실제 발표라면 삭제하세요!
        isTimerRunning = true;

        if (toggleTimerButton != null)
        {
            toggleButtonText = toggleTimerButton.GetComponentInChildren<TMP_Text>();
            toggleTimerButton.onClick.AddListener(OnToggleTimer);
        }

        if (endPresentationButton != null)
        {
            endButtonText = endPresentationButton.GetComponentInChildren<TMP_Text>();
            endPresentationButton.onClick.AddListener(OnEndPresentation);
        }

        DisplayTime(timeRemaining);

        // 🌟 발표 시작하자마자 데이터 추적(음성/시선) 가동
        UserTracker tracker = FindObjectOfType<UserTracker>();
        if (tracker != null)
        {
            tracker.StartTracking(); 
        }
    }

    void Update()
    {
        if (isTimerRunning)
        {
            timeRemaining -= Time.deltaTime;
            DisplayTime(timeRemaining);

            if (timeRemaining <= 30f)
            {
                TriggerUrgentBlink();
            }
        }
    }

    void DisplayTime(float timeToDisplay)
    {
        bool isOverTime = timeToDisplay < 0;
        float absoluteTime = Mathf.Abs(timeToDisplay);

        float minutes = Mathf.FloorToInt(absoluteTime / 60);
        float seconds = Mathf.FloorToInt(absoluteTime % 60);

        string sign = isOverTime ? "+" : "";
        
        if (timerText != null)
        {
            timerText.text = string.Format("{0}{1:00}:{2:00}", sign, minutes, seconds);
        }

        if (isOverTime && endButtonText != null)
        {
            endButtonText.text = "질의응답하기";
        }
    }

    void TriggerUrgentBlink()
    {
        if (timerText != null)
        {
            float blink = Mathf.FloorToInt(Time.time * 2) % 2;
            timerText.color = (blink == 1) ? Color.red : Color.white;
        }
    }

    void OnToggleTimer()
    {
        isTimerRunning = !isTimerRunning;
        if (toggleButtonText != null)
        {
            toggleButtonText.text = isTimerRunning ? "일시정지" : "시작";
        }
    }

    void OnEndPresentation()
    {
        // 타이머가 0 이상일 때 (질의응답 버튼이 아닐 때)
        if (timeRemaining >= 0)
        {
            // 씬 1로 돌아간다는 신호를 켭니다.
            IsReturningFromPresentation = true; 
            SceneManager.LoadScene("Scene_01_Intro_LhjBackup"); // 씬 1의 실제 파일명으로 바꾸세요!
        }
        else
        {
            // 타이머가 0 미만이면(질의응답 중) 기존 질의응답 로직 실행
            OnStartQA();
        }
    }

    void OnStartQA()
    {
        isTimerRunning = false; 

        if (toggleTimerButton != null) toggleTimerButton.gameObject.SetActive(false);
        if (endPresentationButton != null) endPresentationButton.gameObject.SetActive(false);

        QuestionAnswerManager qaManager = FindObjectOfType<QuestionAnswerManager>();
        if (qaManager != null)
        {
            qaManager.StartQAPhase(); 
        }
    }
}