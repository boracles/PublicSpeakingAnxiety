using UnityEngine;
using UnityEngine.UI;
using TMPro;

public class ScriptManager : MonoBehaviour
{
    [System.Serializable]
    public class ScriptData
    {
        public string presentation_script;
    }

    [Header("UI 연동")]
    public ScrollRect scriptScrollView; 
    public TextMeshProUGUI scriptText;   

    [Header("대본 JSON 파일 직접 연결")]
    public TextAsset jsonFile; // 📝 여기에 깃허브에서 받은 json/txt 파일을 직접 드래그할 거예요!

    [Header("스크롤 속도 조절")]
    public float scrollSpeed = 0.05f;

    void Start()
    {
        LoadScriptFromAsset();
    }

    void Update()
    {
        float wheelInput = Input.GetAxis("Mouse ScrollWheel");
        if (Mathf.Abs(wheelInput) > 0.01f)
        {
            ScrollScript(wheelInput);
        }
    }

    // 인스펙터에 꽂아둔 파일에서 대본을 읽어오는 안전한 함수
    void LoadScriptFromAsset()
    {
        if (jsonFile != null)
        {
            string jsonString = jsonFile.text;
            ScriptData data = JsonUtility.FromJson<ScriptData>(jsonString);

            if (scriptText != null && data != null)
            {
                scriptText.text = data.presentation_script;
                Debug.Log("[대본 매니저] JSON 스크립트 에셋 로드 완료!");
                
                Canvas.ForceUpdateCanvases();
                scriptScrollView.verticalNormalizedPosition = 1.0f;
            }
        }
        else
        {
            Debug.LogError("[대본 매니저] Inspector 창에서 Json File 칸에 대본 파일을 연결해주세요!");
        }
    }

    void ScrollScript(float input)
    {
        if (scriptScrollView == null) return;
        scriptScrollView.verticalNormalizedPosition += input * scrollSpeed;
        scriptScrollView.verticalNormalizedPosition = Mathf.Clamp01(scriptScrollView.verticalNormalizedPosition);
    }
}