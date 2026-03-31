using UnityEngine;
using Microsoft.CognitiveServices.Speech;
using System.Threading.Tasks;
using System.Collections.Generic;

public class AzureSpeechSTT : MonoBehaviour
{
    private SpeechRecognizer recognizer;

    public string currentRecognizingText = "";
    public List<string> recognizedHistory = new List<string>();

    async void Start()
    {
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
                string finalText = e.Result.Text;
                recognizedHistory.Add(finalText);

                Debug.Log("[Recognized] " + finalText);
                Debug.Log("[History Count] " + recognizedHistory.Count);
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

        await recognizer.StopContinuousRecognitionAsync();
        Debug.Log("Recognition stopped.");
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
    }

    public string GetRecentContext(int maxCount = 3)
    {
        int start = Mathf.Max(0, recognizedHistory.Count - maxCount);
        return string.Join(" ", recognizedHistory.GetRange(start, recognizedHistory.Count - start));
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