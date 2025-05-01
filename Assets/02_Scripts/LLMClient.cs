using UnityEngine;
using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class LLMClient : MonoBehaviour
{
    /* ── Inspector 설정값 ─────────────────────────────────── */
    [Header("OpenAI API")]
    [SerializeField] private string apiKey = "";                // Bearer 키
    [SerializeField] private string model  = "gpt-4o-mini";     // 모델명
    [Tooltip("HTTP 타임아웃(초)")]
    [SerializeField] private int    timeoutSeconds = 15;

    [Header("System Prompt")]
    [TextArea(3,4)]
    [SerializeField] private string systemPrompt =
        "You are a helpful assistant. "
      + "Return answers ONLY as JSON in the given schema.";

    /* ─────────────────────────────────────────────────────── */
    const string OPENAI_URL = "https://api.openai.com/v1/chat/completions";

    /*  외부에서 호출:  코루틴 Query  ------------------------ */
    /// <summary>
    /// prompt 를 GPT에 전송 → JSON(LLMReply) 파싱 → 콜백
    /// </summary>
    /// <param name="prompt">질문(또는 발표 요약)</param>
    /// <param name="onDone">콜백 (LLMReply, 소요시간s)</param>
    /// <param name="maxRetry">네트워크 재시도 횟수</param>
    public IEnumerator Query(string prompt,
                             Action<LLMReply, float> onDone,
                             int maxRetry = 2)
    {
        // ── 호출 시간 측정용
        float t0 = Time.realtimeSinceStartup;

        // ── HTTP body – OpenAI Chat 형식
        var bodyObj = new
        {
            model = model,
            temperature = 0.7f,
            messages = new[] {
                new { role = "system", content = systemPrompt },
                new { role = "user",   content = prompt }
            },
            response_format = new { type = "json_object" }   // JSON만 반환
        };
        string bodyJson = JsonUtility.ToJson(bodyObj);

        /*  ── 재시도 루프  ─────────────────────────────── */
        int attempt = 0;
        while (true)
        {
            using var req = new UnityWebRequest(OPENAI_URL, "POST");
            req.uploadHandler   = new UploadHandlerRaw(
                                      Encoding.UTF8.GetBytes(bodyJson));
            req.downloadHandler = new DownloadHandlerBuffer();
            req.SetRequestHeader("Content-Type", "application/json");
            req.SetRequestHeader("Authorization", $"Bearer {apiKey}");
            req.timeout = timeoutSeconds;

            yield return req.SendWebRequest();

            // ── 성공 (HTTP 2xx) ──────────────────────────
            if (req.result == UnityWebRequest.Result.Success)
            {
                float latency = Time.realtimeSinceStartup - t0;
                LLMReply reply;

                try
                {
                    string raw = req.downloadHandler.text;
                    // Chat 응답에서 content 안 JSON 부분만 추출
                    string json = ExtractJson(raw);
                    reply = JsonUtility.FromJson<LLMReply>(json);
                }
                catch (Exception e)
                {
                    Debug.LogWarning($"LLM JSON parse error : {e.Message}");
                    reply = new LLMReply {
                        answer="죄송합니다. 오류가 발생했습니다.",
                        emotion="neutral", speechRate=1.0f
                    };
                }

                onDone?.Invoke(reply, latency);
                yield break;   // ★ 정상 종료
            }

            // ── 실패 : 429·502·503 는 재시도 ─────────────────
            bool shouldRetry =      req.responseCode == 429   // Rate limit
                                 || req.responseCode == 502
                                 || req.responseCode == 503;

            if (attempt < maxRetry && shouldRetry)
            {
                attempt++;
                int backoff = 2 << (attempt - 1);             // 2,4,8 초
                Debug.LogWarning($"LLM retry {attempt}/{maxRetry} "
                               + $"after {backoff}s ({req.error})");
                yield return new WaitForSeconds(backoff);
                continue;
            }

            // ── 최종 실패 : Fallback 답변 반환 ──────────────
            Debug.LogWarning($"LLM request failed : {req.error}");
            onDone?.Invoke(new LLMReply {
                answer="죄송합니다. 잠시 후 다시 말씀드릴게요.",
                emotion="neutral",
                speechRate=1.0f
            }, Time.realtimeSinceStartup - t0);
            yield break;
        }
    }

    /* ===== Helper : 응답 문자열에서 { … } JSON만 추출 ========== */
    static string ExtractJson(string raw)
    {
        // OpenAI 응답 구조: choices[0].message.content 에 JSON 텍스트
        int firstBrace = raw.IndexOf('{');
        int lastBrace  = raw.LastIndexOf('}');
        if (firstBrace < 0 || lastBrace < firstBrace)
            throw new FormatException("JSON braces not found");
        return raw.Substring(firstBrace, lastBrace - firstBrace + 1);
    }
}
