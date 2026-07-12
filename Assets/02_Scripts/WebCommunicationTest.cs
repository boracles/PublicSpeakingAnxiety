using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using TMPro;

// 서버가 보내주는 데이터 구조를 유니티가 읽을 수 있게 정의합니다.
[System.Serializable]
public class PresentationData
{
    public string status;
    public string pin;
    public string userName;
    public string title;
    public int maxTime;
}

public class WebCommunicationTest : MonoBehaviour
{
    [Header("[ UI 입력 및 상태 ]")]
    [SerializeField] private TMP_InputField pinInputField; 
    [SerializeField] private TextMeshProUGUI statusText;     

    [Header("[ 데이터 시각화 UI ]")]
    [SerializeField] private TextMeshProUGUI userNameText;   // "발표자: Hazel님"
    [SerializeField] private TextMeshProUGUI projectTitleText; // "주제: 네트워크 보안의 미래"
    [SerializeField] private TextMeshProUGUI timerSetupText;  // "설정 시간: 5분 00초"
    [SerializeField] private GameObject resultPanel;         // 예쁘게 꾸민 결과창 패널 (평소엔 꺼둠)

    private void Start()
    {
        if (resultPanel != null) resultPanel.SetActive(false); // 시작할 땐 결과창 숨기기
    }

    public void OnClickSubmitPin()
    {
        string inputPin = pinInputField.text;

        if (string.IsNullOrEmpty(inputPin))
        {
            if (statusText != null) statusText.text = "<color=red>PIN 번호를 입력해주세요!</color>";
            return;
        }

        if (statusText != null) statusText.text = "🌐 <color=#00FFFF>클라우드 서버에서 발표 데이터를 동기화하는 중...</color>";
        StartCoroutine(RequestDataByPinRoutine(inputPin));
    }

    private IEnumerator RequestDataByPinRoutine(string pin)
    {
        string serverUrl = $"https://mocki.io/v1/60fe1ccd-b41e-41ba-aff2-5fb6c54871f4";

        using (UnityWebRequest webRequest = UnityWebRequest.Get(serverUrl))
        {
            yield return webRequest.SendWebRequest();

            if (webRequest.result == UnityWebRequest.Result.ConnectionError || 
                webRequest.result == UnityWebRequest.Result.ProtocolError)
            {
                if (statusText != null) statusText.text = "❌ 서버 연결 실패. 네트워크 상태를 확인하세요.";
            }
            else
            {
                // 1. 가상 데이터 가져오기
                string displayJson = webRequest.downloadHandler.text;
                
                // 2. [핵심] JSON 데이터를 유니티가 읽을 수 있는 예쁜 데이터로 변환(파싱)!
                PresentationData data = JsonUtility.FromJson<PresentationData>(displayJson);

                if (data.status == "success")
                {
                    if (statusText != null) statusText.text = "<color=green> 데이터 동기화 완료!</color>";
                    
                    // 3. 있어 보이게 UI 텍스트에 각각 쪼개서 매핑하기
                    if (userNameText != null) userNameText.text = $"<b>발표자:</b> {data.userName}님";
                    if (projectTitleText != null) projectTitleText.text = $"<b>주제:</b> {data.title}";
                    
                    int minutes = data.maxTime / 60;
                    if (timerSetupText != null) timerSetupText.text = $"<b>제한 시간:</b> {minutes}분 00초";

                    // 4. 숨겨두었던 예쁜 결과창 패널 촥 열기!
                    if (resultPanel != null) resultPanel.SetActive(true);
                }
                else
                {
                    if (statusText != null) statusText.text = "<color=red>❌ 인증 실패: 존재하지 않는 PIN 번호입니다.</color>";
                    if (resultPanel != null) resultPanel.SetActive(false);
                }
            }
        }
    }

    private string GetFakeServerData(string pin)
    {
        if (pin == "1234")
        {
            return "{\"status\": \"success\", \"pin\": \"1234\", \"userName\": \"짱구\", \"title\": \"네트워크 보안의 종류\", \"maxTime\": 300}";
        }
        else if (pin == "5678")
        {
            return "{\"status\": \"success\", \"pin\": \"5678\", \"userName\": \"혜정\", \"title\": \"웹 서버 인프라 구축 발표\", \"maxTime\": 600}";
        }
        else
        {
            return "{\"status\": \"error\", \"message\": \"fail\"}";
        }
    }
}