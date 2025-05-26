using UnityEngine;
using Paroxe.PdfRenderer;

public class PdfScreenController : MonoBehaviour
{
    [SerializeField] Renderer screenRenderer;
    [SerializeField] int      pdfMatIndex = 1;
    [SerializeField] int      texWidth = 1024;
    [SerializeField] int      texHeight = 1024;
    static readonly int BaseID    = Shader.PropertyToID("_BaseMap");
    static readonly int EmisID    = Shader.PropertyToID("_EmissionMap");
    static readonly int EmisColID = Shader.PropertyToID("_EmissionColor");

    Texture2D[] pageTex;
    Material targetMat;
    int currentPage = 0;
    float inputCooldown = 0.5f;
    float inputTimer = 0f;

    void Awake()
    {
        string pdfPath = System.IO.Path.Combine(Application.streamingAssetsPath, "Presentation.pdf");
        PDFDocument doc = new PDFDocument(pdfPath, null);
        int pageCount = Mathf.Min(doc.GetPageCount(), 10); // 최대 10페이지 제한 (필요시 조정)
        pageTex = new Texture2D[pageCount];

        using (var renderer = new PDFRenderer())
        {
            for (int i = 0; i < pageCount; i++)
            {
                var page = doc.GetPage(i);
                pageTex[i] = renderer.RenderPageToTexture(page, texWidth, texHeight);
                pageTex[i].Apply(false, true);
                page.Dispose();
            }
        }
        doc.Dispose();

        targetMat = screenRenderer.sharedMaterials[pdfMatIndex];
        ShowPage(currentPage);
    }

    void Update()
    {
        float axis = Input.GetAxis("Oculus_CrossPlatform_SecondaryThumbstickHorizontal");
       inputTimer += Time.deltaTime;

        if (inputTimer >= inputCooldown)
        {
            if (axis > 0.5f)
            {
                Debug.Log("[PDF] Next Page Triggered");
                NextPage();
                inputTimer = 0f;
            }
            else if (axis < -0.5f)
            {
                Debug.Log("[PDF] Previous Page Triggered");
                PreviousPage();
                inputTimer = 0f;
            }
        }
    }

    public void NextPage()
    {
        if (currentPage < pageTex.Length - 1)
        {
            currentPage++;
            ShowPage(currentPage);
        }
    }

    public void PreviousPage()
    {
        if (currentPage > 0)
        {
            currentPage--;
            ShowPage(currentPage);
        }
    }

    public void ShowPage(int idx)
    {
        if (pageTex == null || idx < 0 || idx >= pageTex.Length) return;

        Texture2D tex = pageTex[idx];
        targetMat.SetTexture(BaseID, tex);
        targetMat.EnableKeyword("_EMISSION");
        targetMat.SetTexture(EmisID, tex);
        targetMat.SetColor(EmisColID, Color.white);
    }
}
