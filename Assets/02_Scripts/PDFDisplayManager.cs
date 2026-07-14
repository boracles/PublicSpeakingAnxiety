using UnityEngine;
using UnityEngine.UI;
using UnityEngine.Networking;
using System.Collections;
using System.Collections.Generic;

public class PDFDisplayManager : MonoBehaviour
{
    [Header("UI Display 연동")]
    public RawImage displayImage;
    public RawImage deskImage;

    private int currentPageIndex = 0;
    private List<string> imageUrls;

    void Start()
    {
        // SessionManager에서 URL 리스트 가져오기
        if (SessionManager.Instance != null && SessionManager.Instance.activeSession != null)
        {
            imageUrls = SessionManager.Instance.activeSession.page_2.slide_image.image_urls;
            UpdateDisplay();
        }
    }

    void Update()
    {
        // 💡 키보드 조작 로직 추가
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
        if (imageUrls != null && currentPageIndex < imageUrls.Count - 1)
        {
            currentPageIndex++;
            UpdateDisplay();
            Debug.Log($"[PDF] 다음 페이지: {currentPageIndex + 1}");
        }
    }

    public void PrevPage()
    {
        if (imageUrls != null && currentPageIndex > 0)
        {
            currentPageIndex--;
            UpdateDisplay();
            Debug.Log($"[PDF] 이전 페이지: {currentPageIndex + 1}");
        }
    }

    void UpdateDisplay()
    {
        if (imageUrls == null || imageUrls.Count == 0) return;
        StartCoroutine(LoadImageFromUrl(imageUrls[currentPageIndex]));
    }

    IEnumerator LoadImageFromUrl(string url)
    {
        using (UnityWebRequest uwr = UnityWebRequestTexture.GetTexture(url))
        {
            yield return uwr.SendWebRequest();

            if (uwr.result == UnityWebRequest.Result.Success)
            {
                Texture2D texture = DownloadHandlerTexture.GetContent(uwr);
                if (displayImage != null) displayImage.texture = texture;
                if (deskImage != null) deskImage.texture = texture;
            }
            else
            {
                Debug.LogError($"[PDF] 이미지 로드 실패: {uwr.error}");
            }
        }
    }
}