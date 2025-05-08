using UnityEngine;
using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Text.RegularExpressions;
public class LLMClient : MonoBehaviour
{
    [Header("OpenAI API")]
    [SerializeField] private string apiKey = "";
    [SerializeField] private string model  = "gpt-4o-mini";
    [SerializeField] string endpoint = "https://api.openai.com/v1/chat/completions";
    [Tooltip("HTTP 타임아웃(초)")]
    [SerializeField] private int    timeoutSeconds = 15;

    [Header("System Prompt")]
    [SerializeField, TextArea(4,6)]
    string systemPrompt =
        "You are a helpful assistant.\n"
        + "Reply ONLY in JSON that matches this schema—no extra keys.\n\n"
        + "Schema:\n"
        + "{\n"
        + "  \"answer\": string,\n"
        + "  \"emotion\": \"neutral\" | \"happy\" | \"sad\" | \"angry\" | \"excited\",\n"
        + "  \"speechRate\": number\n"
        + "}";


    /* ─────[ 외부 호출용 코루틴 ]──────────────────────────────────── */
    /// <summary>
    /// 프롬프트 → OpenAI 호출 → LLMReply 파싱 → onDone(reply, latency)
    /// </summary>
    public IEnumerator Query(string prompt, Action<LLMReply,float> onDone, string altSystemPrompt = null, int maxRetry = 2)
    {
        float t0 = Time.realtimeSinceStartup;
        
        var body = new {
            model,
            temperature = 0.7f,
            messages = new[] {
                new { role = "system", content = altSystemPrompt ?? systemPrompt },
                new { role = "user",   content = prompt }
            },
            response_format = new { type = "json_object" }
        };
        byte[] bodyRaw = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(body));

        /* ─ R E T R Y   L O O P ─ */
        for (int attempt = 0; ; attempt++)
        {
            using (UnityWebRequest req = new UnityWebRequest(endpoint, "POST"))
            {
                req.uploadHandler   = new UploadHandlerRaw(bodyRaw);
                req.downloadHandler = new DownloadHandlerBuffer();
                req.SetRequestHeader("Content-Type",  "application/json");
                req.SetRequestHeader("Authorization", $"Bearer {apiKey}");
                req.timeout = timeoutSeconds;

                yield return req.SendWebRequest();

                /* 성공(HTTP 2xx) */
                if (req.result == UnityWebRequest.Result.Success)
                {
                    float lat = Time.realtimeSinceStartup - t0;
                    
                    Debug.Log($"RAW ▶ {req.downloadHandler.text}"); 
                    
                    onDone(ParseReply(req.downloadHandler.text), lat);
                    yield break;
                }

                /* 재시도 가능한 코드? */
                bool retryable = req.responseCode is 429 or 502 or 503;
                if (attempt < maxRetry && retryable)
                {
                    int backoff = 2 << attempt;          // 2,4,8…
                    Debug.LogWarning($"LLM retry {attempt+1}/{maxRetry} "
                                   + $"after {backoff}s  ({req.error})");
                    yield return new WaitForSeconds(backoff);
                    continue;
                }

                /* 최종 실패 */
                Debug.LogWarning($"LLM request failed : {req.error}");
                onDone(new LLMReply {
                        answer="죄송합니다. 잠시 후 다시 시도해 주세요.",
                        emotion="neutral", speechRate=1f },
                       Time.realtimeSinceStartup - t0);
                yield break;
            }
        }
    }
    
    static LLMReply ParseReply(string rawResponse)
    {
        JObject root = JObject.Parse(rawResponse);
        string content = root["choices"]?[0]?["message"]?["content"]?.ToString().Trim();

        if (string.IsNullOrEmpty(content))
            return new LLMReply { answer="(empty)", emotion="neutral", speechRate=1f };

        // (1) answer/emotion/speechRate 스키마인 경우
        if (content.Contains("\"answer\""))
        {
            try { return JsonConvert.DeserializeObject<LLMReply>(content); }
            catch { /* fall through */ }
        }

        // (2) 그밖의 JSON—혹은 그냥 문자열—은 answer 필드에 그대로 담아 반환
        return new LLMReply { answer = content, emotion = "neutral", speechRate = 1f };
    }
}
