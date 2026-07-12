using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using System; 

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
    public class SampleRate { } 
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

    // 가짜 서버 데이터
    private string mockJsonFromServer = @"
    {
      ""user_id"": ""hazel_cybersec"",
      ""pin_code"": ""1234"",
      ""created_at"": ""2026-07-11T21:30:00Z"",
      ""session_status"": ""READY"",
      ""page_1_basic_info"": {
        ""presentation_title"": ""VR발표환경에서의 반응적 중립성 기반 AI 청중 백채널 디자인"",
        ""presentation_purpose"": ""연구결과공유"",
        ""used_language"": ""한국어"",
        ""duration_minutes"": 10,
        ""environment_type"": ""세미나실"",
        ""qa_count"": 3
      },
      ""page_2_file_info"": {
        ""slide_pdf_name"": ""VR발표환경_발표자료.pdf"",
        ""paper_pdf_name"": ""AI_Research_Paper.pdf"",
        ""presentation_script_content"": ""스크립트 내용...""
      },
      ""page_3_audience_info"": {
        ""audience_type"": ""심사위원 중심"",
        ""audience_scale_count"": 6,
        ""expertise_level"": ""보통"",
        ""interest_level"": ""보통""
      }
    }";

   void Start()
    {
        if (sessionInfoPanel != null) sessionInfoPanel.SetActive(false);

        // 💡 [수정 완성] 새 이름인 PresentationStageManager의 정적 플래그를 참조합니다!
        if (PresentationStageManager.IsReturningFromPresentation)
        {
            // 1. 자동으로 JSON 데이터를 파싱해 UI를 채워줍니다.
            currentSessionData = JsonUtility.FromJson<SessionData>(mockJsonFromServer);
            FillUiWithSessionData();

            // 2. 세션 판넬을 즉시 활성화(ON) 시켜줍니다!
            if (sessionInfoPanel != null) sessionInfoPanel.SetActive(true);

            // 3. 확인이 끝났으니 새 클래스의 플래그를 false로 원상복구합니다.
            PresentationStageManager.IsReturningFromPresentation = false;
            
            Debug.Log("[복귀 인증] PIN 번호 입력 단계를 건너뛰고 세션 판넬을 즉시 오픈합니다.");
        }

        if (pinSubmitButton != null) pinSubmitButton.onClick.AddListener(CheckPinCode);
        if (startPresentationButton != null) startPresentationButton.onClick.AddListener(LoadNextScene);
    }

    public void CheckPinCode()
    {
        if (pinInputField == null) return;

        currentSessionData = JsonUtility.FromJson<SessionData>(mockJsonFromServer);

        if (pinInputField.text == currentSessionData.pin_code)
        {
            FillUiWithSessionData();
            if (sessionInfoPanel != null) sessionInfoPanel.SetActive(true);
        }
        else
        {
            pinInputField.text = "";
        }
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