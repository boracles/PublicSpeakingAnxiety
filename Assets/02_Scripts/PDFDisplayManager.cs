using UnityEngine;
using UnityEngine.UI;

public class PDFDisplayManager : MonoBehaviour
{
    [Header("UI Display 연동")]
    public RawImage displayImage;       // 메인 대형 스크린 UI
    public RawImage deskImage;          // 💻 새로 추가한 데스크 모니터 UI!

    private int currentPageIndex = 0;   // 0부터 시작
    private int maxPages = 5;           // 총 5페이지

    void Start()
    {
        if (displayImage == null)
        {
            Debug.LogError("[PDF 매니저] 인스펙터에서 Display Image(메인 스크린)를 연결해주세요!");
        }
        else
        {
            Debug.Log($"[PDF 매니저] 로드 성공! 총 {maxPages}페이지 이미지 연동 시작.");
            UpdateDisplay(); 
        }
    }

    void Update()
    {
        // 키보드 제어 테스트
        if (Input.GetKeyDown(KeyCode.RightArrow))
        {
            NextPage();
        }
        else if (Input.GetKeyDown(KeyCode.LeftArrow))
        {
            PrevPage();
        }
    }

    public void NextPage()
    {
        if (currentPageIndex < maxPages - 1)
        {
            currentPageIndex++;
            UpdateDisplay();
            Debug.Log($"[PDF] 다음 페이지 이동: {currentPageIndex + 1} / {maxPages}");
        }
    }

    public void PrevPage()
    {
        if (currentPageIndex > 0)
        {
            currentPageIndex--;
            UpdateDisplay();
            Debug.Log($"[PDF] 이전 페이지 이동: {currentPageIndex + 1} / {maxPages}");
        }
    }

    void UpdateDisplay()
    {
        string fileName = $"PresentationPDF_{currentPageIndex}.jpg";
        string imagePath = System.IO.Path.Combine(Application.dataPath, "01_Scenes", "PDF_Sample", fileName);

        if (System.IO.File.Exists(imagePath))
        {
            byte[] fileData = System.IO.File.ReadAllBytes(imagePath);
            Texture2D texture = new Texture2D(2, 2);
            
            if (texture.LoadImage(fileData))
            {
                // 1. 메인 대형 스크린에 이미지 꽂기
                if (displayImage != null)
                {
                    displayImage.texture = texture;
                }

                // 2. ✨[추가] 연사 데스크 모니터에도 똑같은 이미지 동시에 꽂기!
                if (deskImage != null)
                {
                    deskImage.texture = texture;
                }
            }
        }
        else
        {
            Debug.LogError($"[PDF 매니저] 이미지를 찾을 수 없습니다: {imagePath}");
        }
    }
}