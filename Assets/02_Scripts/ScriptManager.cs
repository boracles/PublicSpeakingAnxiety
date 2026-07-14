using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ScriptManager : MonoBehaviour
{
    [Header("UI 연동")]
    public ScrollRect scriptScrollView; 
    public TextMeshProUGUI scriptText;   

    [Header("스크롤 속도 조절")]
    public float scrollSpeed = 0.05f;

    void Start()
    {
        // 씬 1에서 가져온 데이터를 SessionManager에서 직접 참조
        if (SessionManager.Instance != null && SessionManager.Instance.activeSession != null)
        {
            string content = SessionManager.Instance.activeSession.page_2.presentation_script_content;
            
            if (scriptText != null)
            {
                scriptText.text = content;
                
                // 텍스트가 바뀐 뒤에 스크롤 위치를 맨 위로 고정
                Canvas.ForceUpdateCanvases();
                if (scriptScrollView != null)
                {
                    scriptScrollView.verticalNormalizedPosition = 1.0f;
                }
            }
        }
        else
        {
            Debug.LogError("[대본 매니저] SessionManager 또는 activeSession 데이터를 찾을 수 없습니다!");
        }
    }

    void Update()
    {
        // 마우스 휠로 스크롤 조작
        float wheelInput = Input.GetAxis("Mouse ScrollWheel");
        if (Mathf.Abs(wheelInput) > 0.01f)
        {
            ScrollScript(wheelInput);
        }
    }

    void ScrollScript(float input)
    {
        if (scriptScrollView == null) return;
        
        scriptScrollView.verticalNormalizedPosition += input * scrollSpeed;
        scriptScrollView.verticalNormalizedPosition = Mathf.Clamp01(scriptScrollView.verticalNormalizedPosition);
    }
}