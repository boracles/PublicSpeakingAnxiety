// ───────────────────────────────────────────────
//  DelayManager.cs
//  • STT / LLM / TTS 단계별 실제 지연 기록
//  • AdaptiveDelay(Tmin ±Δ) 계산 제공
// ───────────────────────────────────────────────
using UnityEngine;

public class DelayManager : MonoBehaviour
{
    public static DelayManager I; void Awake(){ I=this; }

    /* 최근 지연(ms) */
    public float sttMs, llmMs, ttsPrepMs;

    [Header("기본 지연 파라미터")]
    public float Tmin = 0.5f;      // 최소 0.5초
    public float engagedDelta = -0.2f;
    public float idleDelta    = +0.3f;

    /* 기록용 메서드 */
    public void RecordSTT(float sec)  => sttMs  = sec * 1000f;
    public void RecordLLM(float sec)  => llmMs  = sec * 1000f;
    public void RecordTTS(float sec)  => ttsPrepMs = sec * 1000f;

    /* 최종 지연 계산 (필요 시 호출) */
    public float CalcDelay(bool userEngaged)
    {
        float pipeSec = (sttMs + llmMs + ttsPrepMs) / 1000f;
        float delta   = userEngaged ? engagedDelta : idleDelta;
        return Mathf.Max(0, Tmin + delta - pipeSec);
    }
}