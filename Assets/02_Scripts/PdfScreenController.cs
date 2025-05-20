using UnityEngine;
using Paroxe.PdfRenderer;

public class PdfScreenController : MonoBehaviour
{
    [SerializeField] Renderer screenRenderer;
    [SerializeField] int      pdfMatIndex = 1;          // 바꿀 머티리얼 슬롯
    [SerializeField] int      texWidth    = 1024;
    [SerializeField] int      texHeight   = 1024;
    static readonly int BaseID = Shader.PropertyToID("_BaseMap");
    static readonly int EmisID = Shader.PropertyToID("_EmissionMap"); // 발광
    static readonly int EmisColID = Shader.PropertyToID("_EmissionColor");
    Texture2D[] pageTex;         // [0]=p1 …
    Material    targetMat;       // 머티리얼 자산 1개만 저장

    void Awake()
    {
        /* ① PDF → Texture2D[3] 준비 (생략: 현재 쓰시는 코드와 동일) */
        string pdfPath = System.IO.Path.Combine(
            Application.streamingAssetsPath, "Presentation.pdf");

        PDFDocument doc = new PDFDocument(pdfPath, null);
        pageTex = new Texture2D[3];
        using (var renderer = new PDFRenderer())
        {
            for (int i = 0; i < 3; i++)
            {
                var page = doc.GetPage(i);
                pageTex[i] = renderer.RenderPageToTexture(page, texWidth, texHeight);
                pageTex[i].Apply(false, true);
                page.Dispose();
            }
        }
        doc.Dispose();

        /* ② ‘공유’ 머티리얼 자산 레퍼런스를 보관 */
        targetMat = screenRenderer.sharedMaterials[pdfMatIndex];

        ShowPage(0);             // 초기 텍스처
    }

    public void ShowPage(int idx)
    {
        if (pageTex == null || idx < 0 || idx >= pageTex.Length) return;

        Texture2D tex = pageTex[idx];

        /* ① 알베도 교체 */
        targetMat.SetTexture(BaseID, tex);

        /* ② Emission 교체 */
        targetMat.EnableKeyword("_EMISSION");          // 발광 활성화
        targetMat.SetTexture(EmisID, tex);
        targetMat.SetColor  (EmisColID, Color.white);  // 밝기 1× (필요하면 조정)
    }
}