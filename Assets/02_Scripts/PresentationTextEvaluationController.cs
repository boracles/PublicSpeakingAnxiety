using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

public class PresentationTextEvaluationController : MonoBehaviour
{
    [Header("Target")]
    [SerializeField] private AudiencePresetController audiencePresetController;

    [Header("Server")]
    [SerializeField] private string serverUrl = "http://localhost:3000/evaluate-text";

    [Header("Presentation Text Input")]
    [TextArea(6, 15)]
    [SerializeField] private string presentationText;

    [Header("Runtime Option")]
    [SerializeField] private bool evaluateOnStart = true;
    [SerializeField] private float evaluateDelayOnStart = 0.5f;

    [Header("Evaluation Result Preview")]
    [SerializeField] private PresentationEvaluationResult lastEvaluationResult = new PresentationEvaluationResult();

    [Header("Runtime Status")]
    [SerializeField] private bool isEvaluating = false;
    [SerializeField] private string lastRawJson;
    [SerializeField] private string lastError;

    private void Start()
    {
        if (evaluateOnStart)
        {
            StartCoroutine(EvaluateAfterDelay());
        }
    }

    private IEnumerator EvaluateAfterDelay()
    {
        yield return new WaitForSeconds(evaluateDelayOnStart);
        EvaluatePresentationText();
    }

    private void Update()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            EvaluatePresentationText();
        }
    }

    [ContextMenu("Evaluate Presentation Text")]
    public void EvaluatePresentationText()
    {
        if (!Application.isPlaying)
        {
            Debug.LogWarning("Evaluation works only in Play Mode.");
            return;
        }

        if (string.IsNullOrWhiteSpace(presentationText))
        {
            lastError = "Presentation text is empty.";
            Debug.LogWarning(lastError);
            return;
        }

        if (isEvaluating)
        {
            lastError = "Evaluation is already running.";
            Debug.LogWarning(lastError);
            return;
        }

        Debug.Log("[PresentationTextEvaluationController] Start LLM evaluation.");
        Debug.Log("[PresentationTextEvaluationController] Server URL: " + serverUrl);
        Debug.Log("[PresentationTextEvaluationController] Text: " + presentationText);

        StartCoroutine(SendTextToServer(presentationText));
    }

    private IEnumerator SendTextToServer(string text)
    {
        isEvaluating = true;
        lastError = "";
        lastRawJson = "";

        EvaluationRequest requestBody = new EvaluationRequest
        {
            presentationText = text
        };

        string json = JsonUtility.ToJson(requestBody);
        byte[] bodyRaw = Encoding.UTF8.GetBytes(json);

        Debug.Log("[PresentationTextEvaluationController] Request JSON: " + json);

        using (UnityWebRequest request = new UnityWebRequest(serverUrl, "POST"))
        {
            request.uploadHandler = new UploadHandlerRaw(bodyRaw);
            request.downloadHandler = new DownloadHandlerBuffer();
            request.SetRequestHeader("Content-Type", "application/json");

            yield return request.SendWebRequest();

            isEvaluating = false;

            string responseText = request.downloadHandler != null
                ? request.downloadHandler.text
                : "";

            if (request.result != UnityWebRequest.Result.Success)
            {
                lastError = $"Server request failed: {request.error}\n{responseText}";
                Debug.LogError("[PresentationTextEvaluationController] " + lastError);
                yield break;
            }

            lastRawJson = responseText;

            Debug.Log("[PresentationTextEvaluationController] LLM raw response:");
            Debug.Log(lastRawJson);

            EvaluationResponse response;

            try
            {
                response = JsonUtility.FromJson<EvaluationResponse>(lastRawJson);
            }
            catch (Exception e)
            {
                lastError = "Failed to parse evaluation response: " + e.Message;
                Debug.LogError("[PresentationTextEvaluationController] " + lastError);
                yield break;
            }

            if (response == null)
            {
                lastError = "Parsed response is null.";
                Debug.LogError("[PresentationTextEvaluationController] " + lastError);
                yield break;
            }

            lastEvaluationResult = ConvertResponseToEvaluationResult(response);

            Debug.Log("[PresentationTextEvaluationController] Parsed stage: " + lastEvaluationResult.stage);
            Debug.Log(
                "[PresentationTextEvaluationController] Scores: " +
                $"organization={lastEvaluationResult.organization}, " +
                $"supportingMaterial={lastEvaluationResult.supportingMaterial}, " +
                $"centralMessage={lastEvaluationResult.centralMessage}, " +
                $"cerValidity={lastEvaluationResult.cerValidity}, " +
                $"languageClarity={lastEvaluationResult.languageClarity}"
            );

            if (audiencePresetController != null)
            {
                audiencePresetController.ApplyEvaluationResult(lastEvaluationResult);
                Debug.Log("[PresentationTextEvaluationController] Applied LLM result to AudiencePresetController.");
            }
            else
            {
                lastError = "AudiencePresetController is not assigned.";
                Debug.LogWarning("[PresentationTextEvaluationController] " + lastError);
            }
        }
    }

    private PresentationEvaluationResult ConvertResponseToEvaluationResult(EvaluationResponse response)
    {
        PresentationEvaluationResult result = new PresentationEvaluationResult();

        PresentationStage parsedStage = ParseStage(response.stage);
        result.stage = parsedStage;

        // 1. LLM이 준 원점수
        float rawOrg = Mathf.Clamp(response.organization, -1f, 1f);
        float rawSup = Mathf.Clamp(response.supportingMaterial, -1f, 1f);
        float rawMsg = Mathf.Clamp(response.centralMessage, -1f, 1f);
        float rawCer = Mathf.Clamp(response.cerValidity, -1f, 1f);

        // 2. 현재 stage에 해당하는 내용 평가 가중치
        Vector4 weight = GetContentStageWeight(parsedStage);

        // 3. stage-weighted content score
        result.organization = rawOrg * weight.x;
        result.supportingMaterial = rawSup * weight.y;
        result.centralMessage = rawMsg * weight.z;
        result.cerValidity = rawCer * weight.w;

        // 지금은 내용 평가 중심.
        // 전달 평가는 아직 별도 로직이므로 기존처럼 받되, 필요 없으면 0으로 둔다.
        result.languageClarity = Mathf.Clamp(response.languageClarity, -1f, 1f);
        result.vocalDelivery = Mathf.Clamp(response.vocalDelivery, -1f, 1f);
        result.gazeDelivery = Mathf.Clamp(response.gazeDelivery, -1f, 1f);
        result.slideSpeechAlignment = Mathf.Clamp(response.slideSpeechAlignment, -1f, 1f);

        Debug.Log(
            "[PresentationTextEvaluationController] Stage-weighted content scores: " +
            $"stage={parsedStage}, " +
            $"Org={result.organization}, " +
            $"Sup={result.supportingMaterial}, " +
            $"Msg={result.centralMessage}, " +
            $"CER={result.cerValidity}"
        );

        return result;
    }

    private PresentationStage ParseStage(string stageText)
    {
        if (string.IsNullOrWhiteSpace(stageText))
        {
            Debug.LogWarning("Stage from server is empty. Fallback to Orientation.");
            return PresentationStage.Orientation;
        }

        if (Enum.TryParse(stageText, true, out PresentationStage stage))
        {
            return stage;
        }

        Debug.LogWarning("Unknown stage from server: " + stageText + ". Fallback to Orientation.");
        return PresentationStage.Orientation;
    }

    private Vector4 GetContentStageWeight(PresentationStage stage)
    {
        switch (stage)
        {
            case PresentationStage.Orientation:
                return new Vector4(0.35f, 0.05f, 0.50f, 0.10f);
            case PresentationStage.Rationale:
                return new Vector4(0.15f, 0.20f, 0.25f, 0.40f);
            case PresentationStage.Framework:
                return new Vector4(0.20f, 0.15f, 0.20f, 0.45f);
            case PresentationStage.Purpose:
                return new Vector4(0.20f, 0.05f, 0.55f, 0.20f);
            case PresentationStage.Methods:
                return new Vector4(0.25f, 0.30f, 0.10f, 0.35f);
            case PresentationStage.Results:
                return new Vector4(0.15f, 0.35f, 0.25f, 0.25f);
            case PresentationStage.Implication:
                return new Vector4(0.15f, 0.20f, 0.35f, 0.30f);
            case PresentationStage.Termination:
                return new Vector4(0.30f, 0.05f, 0.55f, 0.10f);
            default:
                return new Vector4(0.25f, 0.25f, 0.25f, 0.25f);
        }
    }

    [Serializable]
    private class EvaluationRequest
    {
        public string presentationText;
    }

    [Serializable]
    private class EvaluationResponse
    {
        public string stage;
        public float organization;
        public float supportingMaterial;
        public float centralMessage;
        public float cerValidity;
        public float languageClarity;
        public float vocalDelivery;
        public float gazeDelivery;
        public float slideSpeechAlignment;
    }
}