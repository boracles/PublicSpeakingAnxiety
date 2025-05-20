using UnityEngine;

/// <summary>
/// Begin()  -> 부드럽게 밝아짐 후 Pulse
/// End()    -> 부드럽게 꺼짐
/// Attach = BarLight MeshRenderer 상위 오브젝트
/// </summary>
[RequireComponent(typeof(Renderer))]
public class BarLightPulse : MonoBehaviour
{
    [SerializeField] Color baseColor = new(0.23f, 0.42f, 1f); // #3A6CFF
    [SerializeField] float maxIntensity = 5f;   // 머티리얼 HDR 값과 맞춤
    [SerializeField] float pulseSpeed   = 2f;   // Hz → 2 = 1초 주기
    [SerializeField] float fadeSpeed    = 4f;   // 켜고 끄는 페이드 속도

    Renderer rend;
    MaterialPropertyBlock mpb;
    float target = 0f, current = 0f;    // 0 = OFF, 1 = ON

    void Awake()
    {
        rend = GetComponent<Renderer>();
        mpb  = new MaterialPropertyBlock();
        
        var mat = rend.material;     
        if (!mat.IsKeywordEnabled("_EMISSION"))
            mat.EnableKeyword("_EMISSION");
    }

    public void Begin() => target = 1f;   // 지연 시작
    public void End()   => target = 0f;   // 지연 종료

    void Update()
    {
        // ① current 값을 타겟으로 부드럽게 이동
        current = Mathf.MoveTowards(current, target, Time.deltaTime * fadeSpeed);

        // ② 밝기 = current * [0.5 + 0.5*sin] → 숨쉬기
        float pulse = 0.5f + 0.5f * Mathf.Sin(Time.time * pulseSpeed * Mathf.PI * 2);
        float intensity = current * pulse * maxIntensity;

        // ③ 머티리얼에 적용 (PropertyBlock 사용)
        rend.GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", baseColor * intensity);
        rend.SetPropertyBlock(mpb);
    }
}