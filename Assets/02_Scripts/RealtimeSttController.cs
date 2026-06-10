using System;
using System.Collections;
using Microsoft.CognitiveServices.Speech;
using TMPro;
using UnityEngine;
using UnityEngine.Networking;

public class RealtimeSttController : MonoBehaviour
{
    [Header("Server")]
    [SerializeField] private string tokenUrl = "http://localhost:3000/azure-speech-token";

    [Header("Speech")]
    [SerializeField] private string recognitionLanguage = "ko-KR";
    [SerializeField] private float evaluateIntervalSeconds = 10f;

    [Header("UI")]
    [SerializeField] private TMP_Text partialTextView;
    [SerializeField] private TMP_Text finalTextView;

    [Header("Evaluation")]
    [SerializeField] private PresentationTextEvaluationController textEvaluationController;

    private SpeechRecognizer recognizer;

    private string accumulatedText = "";
    private string partialText = "";
    private string lastEvaluatedText = "";

    private bool isRunning = false;
    private float lastEvaluateTime = 0f;

    [Serializable]
    private class TokenResponse
    {
        public string token;
        public string region;
    }

    public void StartStt()
    {
        if (isRunning)
        {
            Debug.Log("STT already running.");
            return;
        }

        StartCoroutine(StartSttRoutine());
    }

    private IEnumerator StartSttRoutine()
    {
        using UnityWebRequest request = UnityWebRequest.Get(tokenUrl);
        yield return request.SendWebRequest();

        if (request.result != UnityWebRequest.Result.Success)
        {
            Debug.LogError("STT token request failed: " + request.error);
            Debug.LogError(request.downloadHandler.text);
            yield break;
        }

        TokenResponse tokenResponse = JsonUtility.FromJson<TokenResponse>(request.downloadHandler.text);

        if (tokenResponse == null || string.IsNullOrWhiteSpace(tokenResponse.token))
        {
            Debug.LogError("STT token parse failed: " + request.downloadHandler.text);
            yield break;
        }

        StartRecognizer(tokenResponse.token, tokenResponse.region);
    }

    private async void StartRecognizer(string token, string region)
    {
        try
        {
            isRunning = true;
            accumulatedText = "";
            partialText = "";
            lastEvaluatedText = "";
            lastEvaluateTime = Time.time;

            if (partialTextView != null) partialTextView.text = "";
            if (finalTextView != null) finalTextView.text = "";

            SpeechConfig speechConfig = SpeechConfig.FromAuthorizationToken(token, region);
            speechConfig.SpeechRecognitionLanguage = recognitionLanguage;

            recognizer = new SpeechRecognizer(speechConfig);

            recognizer.Recognizing += (s, e) =>
            {
                if (e.Result.Reason == ResultReason.RecognizingSpeech)
                {
                    partialText = e.Result.Text;
                    Debug.Log("[Recognizing] " + partialText);
                }
            };

            recognizer.Recognized += (s, e) =>
            {
                partialText = "";

                if (e.Result.Reason == ResultReason.RecognizedSpeech)
                {
                    string text = e.Result.Text;

                    if (!string.IsNullOrWhiteSpace(text))
                    {
                        accumulatedText = (accumulatedText + " " + text).Trim();

                        Debug.Log("[Recognized] " + text);
                        Debug.Log("[Accumulated] " + accumulatedText);
                    }
                }
                else if (e.Result.Reason == ResultReason.NoMatch)
                {
                    Debug.Log("[NoMatch]");
                }
            };

            recognizer.Canceled += (s, e) =>
            {
                Debug.LogError("[Canceled] " + e.Reason + " / " + e.ErrorDetails);
                isRunning = false;
            };

            recognizer.SessionStarted += (s, e) =>
            {
                Debug.Log("[STT Session Started]");
            };

            recognizer.SessionStopped += (s, e) =>
            {
                Debug.Log("[STT Session Stopped]");
                isRunning = false;
            };

            await recognizer.StartContinuousRecognitionAsync();

            Debug.Log("STT started.");
        }
        catch (Exception ex)
        {
            Debug.LogError("STT start failed: " + ex.Message);
            isRunning = false;
        }
    }

    public async void StopStt()
    {
        if (!isRunning || recognizer == null)
        {
            Debug.Log("STT is not running.");
            return;
        }

        try
        {
            await recognizer.StopContinuousRecognitionAsync();

            recognizer.Dispose();
            recognizer = null;
            isRunning = false;

            Debug.Log("STT stopped.");
        }
        catch (Exception ex)
        {
            Debug.LogError("STT stop failed: " + ex.Message);
        }
    }

    private void Update()
    {
        if (partialTextView != null)
        {
            partialTextView.text = partialText;
        }

        if (finalTextView != null)
        {
            finalTextView.text = accumulatedText;
        }

        if (!isRunning)
        {
            return;
        }

        if (string.IsNullOrWhiteSpace(accumulatedText))
        {
            return;
        }

        if (textEvaluationController == null)
        {
            Debug.LogWarning("PresentationTextEvaluationController is not assigned.");
            return;
        }

        if (textEvaluationController.IsEvaluating)
        {
            return;
        }

        if (Time.time - lastEvaluateTime >= evaluateIntervalSeconds)
        {
            lastEvaluateTime = Time.time;

            if (accumulatedText == lastEvaluatedText)
            {
                return;
            }

            lastEvaluatedText = accumulatedText;

            Debug.Log("[RealtimeSttController] Send accumulated STT text to evaluator.");
            textEvaluationController.EvaluateRuntimeText(accumulatedText);
        }
    }

    private async void OnDestroy()
    {
        if (recognizer != null)
        {
            try
            {
                await recognizer.StopContinuousRecognitionAsync();
                recognizer.Dispose();
            }
            catch { }
        }
    }
}