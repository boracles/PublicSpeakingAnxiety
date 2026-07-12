using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using System;

[Serializable]
public class QASessionData
{
    public Page1BasicInfo page_1_basic_info;
}

public class QuestionAnswerManager : MonoBehaviour
{
    [Header("--- 질의응답 UI 패널 ---")]
    public GameObject qaPanel;             
    public TMP_Text questionText;          
    public Button nextQuestionButton;      

    [Header("--- 음성 재생 (TTS) ---")]
    public AudioSource audioSource;        
    public AudioClip[] questionAudios;     

    private int currentQuestionIndex = 0;
    private int totalQACount = 3;          

    private string[] mockQuestions = {
        "Q1. 첫 번째 질문입니다. AI 청중의 반응적 중립성이란 정확히 무엇을 의미하나요?",
        "Q2. 두 번째 질문입니다. 본 연구에서 사용하신 샘플 레이트의 기준은 무엇인가요?",
        "Q3. 마지막 질문입니다. 향후 이 시스템을 실제 교육 환경에 적용할 때 어떤 기대효과가 있습니까?"
    };

    private string mockJsonFromServer = @"
    {
      ""page_1_basic_info"": {
        ""qa_count"": 3
      }
    }";

    void Start()
    {
        if (qaPanel != null) qaPanel.SetActive(false);

        if (nextQuestionButton != null)
        {
            nextQuestionButton.onClick.AddListener(OnNextQuestionPressed);
        }
    }

    public void StartQAPhase()
    {
        if (qaPanel != null) qaPanel.SetActive(true);

        QASessionData data = JsonUtility.FromJson<QASessionData>(mockJsonFromServer);
        if (data != null && data.page_1_basic_info != null)
        {
            totalQACount = data.page_1_basic_info.qa_count;
        }

        // 데이터 수집(UserTracker)은 발표 때 켜졌으므로 끊지 않고 그대로 이어받음
        currentQuestionIndex = 0;
        PlayQuestion(currentQuestionIndex);
    }

    void PlayQuestion(int index)
    {
        if (index < mockQuestions.Length)
        {
            if (questionText != null)
            {
                questionText.text = mockQuestions[index];
            }

            if (audioSource != null && questionAudios != null && index < questionAudios.Length)
            {
                audioSource.clip = questionAudios[index];
                audioSource.Play();
            }

            if (index == totalQACount - 1)
            {
                TMP_Text btnText = nextQuestionButton.GetComponentInChildren<TMP_Text>();
                if (btnText != null) btnText.text = "발표 종료";
            }
        }
    }

    void OnNextQuestionPressed()
    {
        currentQuestionIndex++;

        if (currentQuestionIndex < totalQACount)
        {
            PlayQuestion(currentQuestionIndex);
        }
        else
        {
            EndQAAndGoToScene3();
        }
    }

    void EndQAAndGoToScene3()
    {
        // 🌟 모든 발표와 QA가 끝났으므로 데이터 추적 종료
        UserTracker tracker = FindObjectOfType<UserTracker>();
        if (tracker != null)
        {
            tracker.StopTracking(); 
        }

        Debug.Log("모든 질의응답 종료. 결과창(씬 3)으로 이동합니다.");
        SceneManager.LoadScene("Scene_03_Feedback"); 
    }
}