using UnityEngine;
using System;
using System.Collections.Generic;
using System.Collections;

[RequireComponent(typeof(Renderer))]
public class BarLightPulse : MonoBehaviour
{
    [Header("색·속도")]
    [SerializeField] Color  baseColor    = new (0.23f, 0.42f, 1f); // #3A6CFF
    [SerializeField] float  maxIntensity = 5f;   // 머티리얼 HDR 값과 맞춤
    [SerializeField] float  pulseSpeed   = 2f;   // Hz ( 2 = 1 초 주기 )
    [SerializeField] float  fadeSpeed    = 4f;   // Begin/End 페이드 속도

    Renderer              rend;
    MaterialPropertyBlock mpb;

    float target  = 0f;   // 0 = OFF, 1 = ON   (목표값)
    float current = 0f;   // 매 프레임 target 쪽으로 이동

    bool looping = false; 
    public bool IsLooping => looping;
    /* ───────── Unity ───────── */
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
        /* ① current → target 으로 천천히 이동 */
        current = Mathf.MoveTowards(current, target,
                                    Time.deltaTime * fadeSpeed);

        /* ② 숨쉬기 펄스: 0.5~1.0 범위 */
        float pulse     = 0.5f + 0.5f *
                          Mathf.Sin(Time.time * pulseSpeed * Mathf.PI * 2);
        float intensity = current * pulse * maxIntensity;

        /* ③ 머티리얼에 emission 적용 (PropertyBlock) */
        rend.GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", baseColor * intensity);
        rend.SetPropertyBlock(mpb);
    }

    /* ───────── Public API ───────── */
    /** 발표 ‘지연’ 시작 – 지속 펄스 ON */
    public void PulseLoop()
    {
        looping = true;
        target  = 1f;                 // ON 상태 고정
    }         // (= Begin)

    public void StopLoop()
    {
        looping = false;
        target  = 0f;                 // OFF 로 부드럽게 감쇠
    }        // (= End)

    /** 씬 로딩 직후 등에서 ‘한 번만’ 번쩍 */
    public void BlinkOnce(float seconds = 0.3f)
        => StartCoroutine(CoBlink(seconds));

    /* ───────── 내부 코루틴 ───────── */
    IEnumerator CoBlink(float sec)
    {
        target = 1f;                 // 잠깐 켜고
        yield return new WaitForSeconds(sec);
        target = 0f;                 // 바로 끔
    }
}
