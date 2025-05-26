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
    [SerializeField] float  fadeSpeed    = 8.0f;   // Begin/End 페이드 속도

    [Header("음성 입력(선택)")]
    [SerializeField] AudioSource voiceSrc = null;   // 아바타 음성 오디오
    [SerializeField] float  silenceThresh = 0.02f;  // RMS 이하면 ‘무음’
    [SerializeField] float  gain          = 30f;    // RMS→[0,1] 스케일링

    Renderer              rend;
    MaterialPropertyBlock mpb;

    float target  = 0f;   // 0 = OFF, 1 = ON   (목표값)
    float current = 0f;   // 매 프레임 target 쪽으로 이동

    bool looping = false; 
    public bool IsLooping => looping;
    
    static readonly float[] buf = new float[256];

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
        /* 1. 오디오 RMS → target 밝기 계산 */
        float rms = (voiceSrc && voiceSrc.isPlaying)
            ? GetRMS(voiceSrc)
            : 0f;

        //  (RMS - 임계) × gain → 0~1 로 클램프
        float target = Mathf.Clamp01((rms - silenceThresh) * gain);   // ★

        /* 2. 부드럽게 따라가도록 스무딩 */
        current = Mathf.MoveTowards(current, target,
            Time.deltaTime * fadeSpeed);      // ★

        /* 3. 머티리얼에 적용 */
        float intensity = current * maxIntensity;                      // ★
        rend.GetPropertyBlock(mpb);
        mpb.SetColor("_EmissionColor", baseColor * intensity);
        rend.SetPropertyBlock(mpb);
    }
    
    float GetRMS(AudioSource src)
    {
        src.GetOutputData(buf, 0);
        float sum = 0f;
        for (int i = 0; i < buf.Length; ++i) sum += buf[i] * buf[i];
        return Mathf.Sqrt(sum / buf.Length);
    }
    
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

    public void SetSpeaking(bool isSpeaking)
    {
        if (isSpeaking) target = 1f;
        else if (!looping) target = 0f;
    }
    
    IEnumerator CoBlink(float sec)
    {
        target = 1f;
        yield return new WaitForSeconds(sec);
        if (!looping) target = 0f;
    }
}
