using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using Firebase.Database;

public class IntroController : MonoBehaviour
{
    [Header("입력 UI")]
    public TMP_InputField pinInputField;
    public Button pinSubmitButton;
    public TMP_Text pinWarningText;

    [Header("결과 표시 UI")]
    public GameObject sessionInfoPanel;
    public TMP_Text durationText;
    public TMP_Text qaCountText;
    public TMP_Text audienceScaleText;
    public TMP_Text environmentText;
    public TMP_Text expertiseText;
    public TMP_Text interestText;

    [Header("안내 문구")]
    public GameObject instructionText;

    void Start()
    {
        // 초기 설정: 결과 패널은 숨기고 입력 버튼에 기능 연결
        if (sessionInfoPanel != null) sessionInfoPanel.SetActive(false);
        if (pinSubmitButton != null) pinSubmitButton.onClick.AddListener(CheckPinCode);

        if (PresentationStageManager.IsReturningFromPresentation)
        {
            // 플래그 초기화
            PresentationStageManager.IsReturningFromPresentation = false;
            
            // 데이터가 있다면 바로 결과창 표시
            if (SessionManager.Instance != null && SessionManager.Instance.activeSession != null)
            {
                FillUiWithSessionData(SessionManager.Instance.activeSession);
                sessionInfoPanel.SetActive(true);
                pinInputField.gameObject.SetActive(false);
                pinSubmitButton.gameObject.SetActive(false);
                if (pinWarningText != null) pinWarningText.gameObject.SetActive(false);
            }
        }
    }

    public void CheckPinCode()
    {
        string pin = pinInputField.text;
        string path = "presentation_data/" + pin;

        FirebaseDatabase.DefaultInstance.GetReference(path).GetValueAsync().ContinueWith(task =>
        {
            if (task.IsCompleted && task.Result.Exists)
            {
                string json = task.Result.GetRawJsonValue();
                
                MainThreadDispatcher.Enqueue(() =>
                {
                    // 1. 세션 데이터 파싱
                    SessionData data = JsonUtility.FromJson<SessionData>(json);

                    // 2. SessionManager 생성 및 데이터 주입
                    if (SessionManager.Instance == null)
                    {
                        GameObject go = new GameObject("SessionManager");
                        go.AddComponent<SessionManager>();
                    }
                    SessionManager.Instance.activeSession = data;

                    // 3. UI 업데이트
                    FillUiWithSessionData(data);
                    
                    // 4. 화면 전환 (입력창 숨기고 결과창 표시)
                    sessionInfoPanel.SetActive(true);
                    pinInputField.gameObject.SetActive(false);
                    pinSubmitButton.gameObject.SetActive(false);
                    pinWarningText.gameObject.SetActive(false);

                    if (instructionText != null) instructionText.SetActive(false); // 텍스트도 끄기
    
                    sessionInfoPanel.SetActive(true);
                    
                });
            }
            else
            {
                MainThreadDispatcher.Enqueue(() => {
                    pinWarningText.text = "잘못된 PIN 번호입니다.";
                });
            }
        });
    }

    private void FillUiWithSessionData(SessionData data)
    {
        if (data == null) return;

        // 위쪽 데이터
        if (durationText != null) durationText.text = $"{data.page_1.duration_minutes}분";
        if (qaCountText != null) qaCountText.text = $"{data.page_1.qa_count}개";
        if (audienceScaleText != null) audienceScaleText.text = $"{data.page_3.audience_scale}명";
        if (environmentText != null) environmentText.text = data.page_1.environment_type;

        // 💡 누락된 아래쪽 데이터 채우기
       if (expertiseText != null) expertiseText.text = data.page_3.audience_expertise;
    if (interestText != null) interestText.text = data.page_3.audience_interest;
    
    Debug.Log($"[디버그] 전문성: {data.page_3.audience_expertise}, 관심도: {data.page_3.audience_interest}");
    }
    public void StartSession()
{
    // 씬 1에서 받아둔 데이터가 가방(SessionManager)에 잘 있는지 확인
    if (SessionManager.Instance.activeSession != null)
    {
        SceneManager.LoadScene("Scene_02_Presentation_LhjBackup");
    }
    else
    {
        Debug.LogError("세션 데이터가 없습니다. PIN을 먼저 확인하세요!");
    }
}

    public void ResetPinInput()
    {
        // 결과 패널 끄기
        sessionInfoPanel.SetActive(false);
        
        // 입력창 및 안내 문구 켜기
        pinInputField.gameObject.SetActive(true);
        pinSubmitButton.gameObject.SetActive(true);
        pinWarningText.gameObject.SetActive(true);
        
        // 안내 문구 복구
        if (pinWarningText != null) 
        {
            pinWarningText.gameObject.SetActive(true);
            pinWarningText.text = "웹에서 발급받은 PIN 번호 4자리를 입력해주세요.";
        }
        
        pinInputField.text = "";
    }
}