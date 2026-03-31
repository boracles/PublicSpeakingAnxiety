using UnityEngine;
using UnityEngine.Networking;
using Microsoft.CognitiveServices.Speech;
using System.Threading.Tasks;
using System.Collections;
using System.Collections.Generic;
using System.Text;

public class AzureSpeechSTT : MonoBehaviour
{
    private SpeechRecognizer recognizer;

    public string currentRecognizingText = "";
    public string lastRecognizedText = "";

    public List<string> recognizedHistory = new List<string>();

    [Header("History Settings")]
    public int maxHistoryCount = 10;

    private float recognitionStartTime;
    public string previousStage = "Unknown";
    public string currentSlideTitle = "Unknown Slide";

    public string currentInferredStage = "Unknown";
    public float currentStageConfidence = 0f;

    private bool pendingStageInference = false;
    private string pendingPayload = "";

    [System.Serializable]
    public class StageInferenceResult
    {
        public string stage;
        public float confidence;
        public string reason;
    }

    async void Start()
    {
        Debug.Log("AzureSpeechSTT VERSION_CHECK_0331_A");
        await InitRecognizer();
    }

    async Task InitRecognizer()
    {
        string key = AzureSpeechSecrets.SpeechKey;
        string region = AzureSpeechSecrets.SpeechRegion;

        if (string.IsNullOrWhiteSpace(key) || string.IsNullOrWhiteSpace(region))
        {
            Debug.LogError("Azure Speech key/region is missing.");
            return;
        }

        var speechConfig = SpeechConfig.FromSubscription(key, region);
        speechConfig.SpeechRecognitionLanguage = "ko-KR";

        recognizer = new SpeechRecognizer(speechConfig);

        recognizer.Recognizing += (s, e) =>
        {
            currentRecognizingText = e.Result.Text;
            Debug.Log("[Recognizing] " + currentRecognizingText);
        };

        recognizer.Recognized += (s, e) =>
        {
            if (e.Result.Reason == ResultReason.RecognizedSpeech)
            {
                string finalText = e.Result.Text?.Trim();

                if (!string.IsNullOrEmpty(finalText))
                {
                    lastRecognizedText = finalText;
                    recognizedHistory.Add(finalText);

                    if (recognizedHistory.Count > maxHistoryCount)
                    {
                        recognizedHistory.RemoveAt(0);
                    }

                    Debug.Log("[Recognized] " + finalText);
                    Debug.Log("[Recent Context] " + GetRecentContext(3));

                    try
                    {
                        pendingPayload = BuildStageInferencePayload();
                        pendingStageInference = true;
                        Debug.Log("[Queued Stage Payload]\n" + pendingPayload);
                    }
                    catch (System.Exception ex)
                    {
                        Debug.LogError("[Stage Block Exception] " + ex.ToString());
                    }
                }
            }
            else if (e.Result.Reason == ResultReason.NoMatch)
            {
                Debug.Log("[NoMatch] 음성이 인식되지 않았습니다.");
            }
        };

        recognizer.Canceled += (s, e) =>
        {
            Debug.LogError("[Canceled] " + e.Reason + " / " + e.ErrorDetails);
        };

        recognizer.SessionStarted += (s, e) =>
        {
            Debug.Log("[SessionStarted]");
        };

        recognizer.SessionStopped += (s, e) =>
        {
            Debug.Log("[SessionStopped]");
        };

        Debug.Log("Azure Speech recognizer initialized.");
        await Task.CompletedTask;
    }

    public async void StartRecognition()
    {
        if (recognizer == null)
        {
            Debug.LogError("Recognizer is not initialized.");
            return;
        }

        recognitionStartTime = Time.time;

        await recognizer.StartContinuousRecognitionAsync();
        Debug.Log("Recognition started.");
    }

    public async void StopRecognition()
    {
        if (recognizer == null)
        {
            Debug.LogError("Recognizer is not initialized.");
            return;
        }

        Debug.Log("StopRecognition() called");
        await recognizer.StopContinuousRecognitionAsync();
        Debug.Log("Recognition stopped.");

        Debug.Log("Final lastRecognizedText = " + lastRecognizedText);
        Debug.Log("Final recent context = " + GetRecentContext(3));
    }

    public string GetRecentContext(int recentCount = 3)
    {
        if (recognizedHistory.Count == 0)
            return "";

        int startIndex = Mathf.Max(0, recognizedHistory.Count - recentCount);
        StringBuilder sb = new StringBuilder();

        for (int i = startIndex; i < recognizedHistory.Count; i++)
        {
            sb.Append(recognizedHistory[i]);

            if (i < recognizedHistory.Count - 1)
                sb.Append(" ");
        }

        return sb.ToString();
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.S))
        {
            StartRecognition();
        }

        if (Input.GetKeyDown(KeyCode.E))
        {
            StopRecognition();
        }

        if (pendingStageInference)
        {
            pendingStageInference = false;
            Debug.Log("[Main Thread] sending stage inference");
            RequestStageInference();
        }
    }

    public string BuildStageInferencePayload()
    {
        string payload =
            "{\n" +
            $"  \"current_text\": \"{EscapeJson(lastRecognizedText)}\",\n" +
            $"  \"recent_context\": \"{EscapeJson(GetRecentContext(3))}\",\n" +
            $"  \"elapsed_time_sec\": 0,\n" +
            $"  \"previous_stage\": \"{EscapeJson(previousStage)}\",\n" +
            $"  \"slide_title\": \"{EscapeJson(currentSlideTitle)}\"\n" +
            "}";

        return payload;
    }

    public void RequestStageInference()
    {
        StartCoroutine(SendStageInferenceRequest());
    }

    private IEnumerator SendStageInferenceRequest()
    {
        Debug.Log("[SendStageInferenceRequest] started");

        string url = "http://localhost:3000/infer-stage";
        string jsonPayload = pendingPayload;

        byte[] bodyRaw = Encoding.UTF8.GetBytes(jsonPayload);

        using (UnityWebRequest request = new UnityWebRequest(url, "POST"))
        {
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");

            yield return request.SendWebRequest();

            if (request.result != UnityWebRequest.Result.Success)
            {
                Debug.LogError("[Stage Inference Error] " + request.error);
            }
            else
            {
                string responseText = request.downloadHandler.text;
                Debug.Log("[Stage Inference Response] " + responseText);

                StageInferenceResult result = JsonUtility.FromJson<StageInferenceResult>(responseText);

                if (result != null)
                {
                    currentInferredStage = result.stage;
                    currentStageConfidence = result.confidence;
                    previousStage = result.stage;

                    Debug.Log("[Stage] " + result.stage);
                    Debug.Log("[Confidence] " + result.confidence);
                    Debug.Log("[Reason] " + result.reason);
                }
            }
        }
    }

    private string EscapeJson(string input)
    {
        if (string.IsNullOrEmpty(input)) return "";
        return input.Replace("\\", "\\\\").Replace("\"", "\\\"");
    }

    private async void OnDestroy()
    {
        if (recognizer != null)
        {
            await recognizer.StopContinuousRecognitionAsync();
            recognizer.Dispose();
            recognizer = null;
        }
    }
}