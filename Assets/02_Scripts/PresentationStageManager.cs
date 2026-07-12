using System;
using UnityEngine;
using UnityEngine.UI;
using TMPro;

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
        PresentationSessionData sessionData = JsonUtility.FromJson<PresentationSessionData>(mockJsonFromServer);
        if (sessionData != null && sessionData.page_1_basic_info != null)
        {
            timeRemaining = sessionData.page_1_basic_info.duration_minutes * 60f;
        }
        else
        {
            timeRemaining = 10 * 60f; 
        }
        timeRemaining = 5f;
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
        OnStartQA();
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