using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using System;
using Firebase.Database; // Firebase 추가

// ==========================================
// 1. JSON 데이터 구조 정의
// ==========================================
[Serializable]
public class SessionData
{
    public string user_id;
    public string pin_code;
    public string created_at;
    public string session_status;
    public Page1BasicInfo page_1_basic_info;
    public Page2FileInfo page_2_file_info;
    public Page3AudienceInfo page_3_audience_info;
}

[Serializable]
public class Page1BasicInfo
{
    public string presentation_title;
    public string presentation_purpose;
    public string used_language;
    public int duration_minutes;
    public string environment_type;
    public int qa_count;
}

[Serializable]
public class Page2FileInfo
{
    public string slide_pdf_name;
    public string paper_pdf_name;
    public string presentation_script_content;
}

[Serializable]
public class Page3AudienceInfo
{
    public string audience_type;
    public int audience_scale_count;
    public string expertise_level;
    public string interest_level;
}

// ==========================================
// 2. 메인 컨트롤러 클래스
// ==========================================
public class IntroController : MonoBehaviour
{
    [Header("--- 1단계: PIN 입력 UI ---")]
    public TMP_InputField pinInputField;
    public Button pinSubmitButton;
    public TMP_Text pinWarningText;

    [Header("--- 2단계: 세션 준비 완료 판넬 ---")]
    public GameObject sessionInfoPanel;

    [Header("--- 판넬 내부 텍스트 컴포넌트들 ---")]
    public TMP_Text sessionTypeText;
    public TMP_Text durationText;
    public TMP_Text qaCountText;
    public TMP_Text audienceScaleText;
    public TMP_Text environmentText;
    public TMP_Text expertiseText;
    public TMP_Text interestText;

    [Header("--- 판넬 내부 하단 버튼 ---")]
    public Button startPresentationButton;

    private SessionData currentSessionData;

    void Start()
    {
        if (sessionInfoPanel != null) sessionInfoPanel.SetActive(false);
        if (pinSubmitButton != null) pinSubmitButton.onClick.AddListener(CheckPinCode);
        if (startPresentationButton != null) startPresentationButton.onClick.AddListener(LoadNextScene);
    }

    public void CheckPinCode()
    {
        if (pinInputField == null) return;
        string pin = pinInputField.text;
        string path = "sessions/" + pin;

        Debug.Log("Firebase에서 데이터 검색 중: " + path);

        FirebaseDatabase.DefaultInstance.GetReference(path).GetValueAsync().ContinueWith(task =>
        {
            if (task.IsCompleted && task.Result.Exists)
            {
                string json = task.Result.GetRawJsonValue();
                
                // 데이터 가져오기 성공 시 UI 업데이트 (Main Thread 호출)
                MainThreadDispatcher.Enqueue(() =>
                {
                    currentSessionData = JsonUtility.FromJson<SessionData>(json);
                    FillUiWithSessionData();
                    if (sessionInfoPanel != null) sessionInfoPanel.SetActive(true);
                });
            }
            else
            {
                MainThreadDispatcher.Enqueue(() => {
                    if (pinWarningText != null) pinWarningText.text = "잘못된 PIN 번호입니다.";
                });
            }
        });
    }

    private void FillUiWithSessionData()
    {
        if (currentSessionData == null) return;
        var p1 = currentSessionData.page_1_basic_info;
        var p3 = currentSessionData.page_3_audience_info;

        if (sessionTypeText != null) sessionTypeText.text = "발표 모드";
        if (durationText != null) durationText.text = $"{p1.duration_minutes}분";
        if (qaCountText != null) qaCountText.text = $"{p1.qa_count}개";
        if (audienceScaleText != null) audienceScaleText.text = $"{p3.audience_scale_count}명";
        if (environmentText != null) environmentText.text = p1.environment_type;
        if (expertiseText != null) expertiseText.text = p3.expertise_level;
        if (interestText != null) interestText.text = p3.interest_level;
    }

    public void LoadNextScene()
    {
        SceneManager.LoadScene("Scene_02_Presentation_LhjBackup");
    }
}

// ==========================================
// 3. 메인 스레드 호출 보조 클래스 (간단 버전)
// ==========================================
public static class MainThreadDispatcher
{
    private static readonly System.Collections.Concurrent.ConcurrentQueue<Action> _executionQueue = new System.Collections.Concurrent.ConcurrentQueue<Action>();

    public static void Enqueue(Action action) => _executionQueue.Enqueue(action);

    [RuntimeInitializeOnLoadMethod]
    private static void Initialize() => new GameObject("MainThreadDispatcher").AddComponent<DispatcherHelper>();

    private class DispatcherHelper : MonoBehaviour
    {
        void Update()
        {
            while (_executionQueue.TryDequeue(out var action)) action.Invoke();
        }
    }
}