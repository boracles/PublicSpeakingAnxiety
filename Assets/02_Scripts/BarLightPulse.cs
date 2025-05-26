using UnityEngine;
using System.Collections;

[RequireComponent(typeof(Renderer))]
public class BarLightPulse : MonoBehaviour
{
    /* ───── 기본 설정 ───── */
    [Header("색·속도")]
    [SerializeField] Color baseColor      = new (0.23f, 0.42f, 1f); // #3A6CFF
    [SerializeField] float maxIntensity   = 5f;     // 머티리얼 HDR 값
    [SerializeField] float fadeSpeed      = 8f;     // OFF 로 감쇠 속도

    /* ───── Spatial 클립 연동 ───── */
    [Header("Spatial Clip (선택)")]
    [SerializeField] AudioSource spatialSrc = null; // QAController 의 fxSource
    [SerializeField] bool        rampWithClip = true; // 진행도에 따라 밝기 ↑

    /* ───── 내부 ───── */
    Renderer rend;
    MaterialPropertyBlock mpb;

    float target  = 0f;   // 0~1
    float current = 0f;

    bool looping = false;
    public bool IsLooping => looping;

    void Awake()
    {
        rend = GetComponent<Renderer>();
        mpb  = new MaterialPropertyBlock();

        var mat = rend.material;
        if (!mat.IsKeywordEnabled("_EMISSION"))
            mat.EnableKeyword("_EMISSION");
    }

    void Update()
    {
        /* 1. 루프 중 + AudioSource 재생 중이면 진행도 → target */
        if (looping && spatialSrc && spatialSrc.isPlaying && rampWithClip)
        {
            target = Mathf.Clamp01(spatialSrc.time / spatialSrc.clip.length);
        }

        /* 2. 부드러운 보간 */
        current = Mathf.MoveTowards(current, target, Time.deltaTime * fadeSpeed);

        /* 3. 머티리얼 적용 */
        float t         = Mathf.Pow(current, 0.5f);  
        float intensity = Mathf.Lerp(1f, maxIntensity, t); 
        
        rend.GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", baseColor * intensity);
        rend.SetPropertyBlock(mpb);

        /* 4. 루프가 끝났는데 소리도 끝났으면 자동 OFF */
        if (looping && spatialSrc && !spatialSrc.isPlaying)
            StopLoop();
    }

    /* ───── Public API ───── */

    /** 3.8 초 클립 한 번 재생 + 진행도 램핑 */
    public void PulseLoop(AudioSource src = null)
    {
        spatialSrc = src ? src : spatialSrc;
        if (spatialSrc && !spatialSrc.isPlaying)
        {
            spatialSrc.loop = false;
            spatialSrc.Play();
        }
        looping = true;
        target  = 0f;              // 0 → 1 로 서서히 상승
    }

    public void StopLoop()
    {
        looping = false;
        target  = 0f;              // 부드럽게 감쇠
    }

    /** 짧게 한번 번쩍 */
    public void BlinkOnce(float seconds = 0.3f)
        => StartCoroutine(CoBlink(seconds));

    IEnumerator CoBlink(float sec)
    {
        target = 1f;
        yield return new WaitForSeconds(sec);
        if (!looping) target = 0f;
    }
}
