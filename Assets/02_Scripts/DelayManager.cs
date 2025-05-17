using UnityEngine;

public class DelayManager : MonoBehaviour
{
    public static DelayManager I; void Awake() { I = this; }

    /* 최근 지연(ms) */
    public float sttMs, llmMs, ttsPrepMs;

    [Header("지연 범위(초)")]
    public float fixedMin = 1.5f;
    public float fixedMax = 2.0f;

    /* 기록용 메서드 */
    public void RecordSTT(float sec)  => sttMs    = sec * 1000f;
    public void RecordLLM(float sec)  => llmMs    = sec * 1000f;
    public void RecordTTS(float sec)  => ttsPrepMs = sec * 1000f;

    /* 고정 지연 계산 */
    public float CalcDelayFixed()
    {
        float pipeSec = (sttMs + llmMs + ttsPrepMs) / 1000f;
        float target  = Random.Range(fixedMin, fixedMax);   // 1.5–2.0 s 중 랜덤
        return Mathf.Max(0, target - pipeSec);
    }
}