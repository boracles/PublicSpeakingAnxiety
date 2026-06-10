using UnityEngine;

public static class AudienceStateDeltaCalculator
{
    public static Vector3 CalculateContentDelta(PresentationEvaluationResult result)
    {
        Vector4 stageWeights = PresentationStageWeightProvider.GetContentWeights(result.stage);

        float weightedOrg = result.organization * stageWeights.x;
        float weightedSup = result.supportingMaterial * stageWeights.y;
        float weightedMsg = result.centralMessage * stageWeights.z;
        float weightedCER = result.cerValidity * stageWeights.w;

        float deltaE =
            0.35f * weightedOrg +
            0.20f * weightedSup +
            0.30f * weightedMsg +
            0.15f * weightedCER;

        float deltaV =
            0.10f * weightedOrg +
            0.30f * weightedSup +
            0.25f * weightedMsg +
            0.35f * weightedCER;

        float deltaC =
            0.35f * weightedOrg +
            0.15f * weightedSup +
            0.25f * weightedMsg +
            0.25f * weightedCER;

        return ClampDelta(deltaE, deltaV, deltaC);
    }

    public static Vector3 CalculateDeliveryDelta(PresentationEvaluationResult result)
    {
        float deltaE =
            0.20f * result.languageClarity +
            0.35f * result.vocalDelivery +
            0.30f * result.gazeDelivery +
            0.15f * result.slideSpeechAlignment;

        float deltaV =
            0.15f * result.languageClarity +
            0.30f * result.vocalDelivery +
            0.35f * result.gazeDelivery +
            0.20f * result.slideSpeechAlignment;

        float deltaC =
            0.35f * result.languageClarity +
            0.20f * result.vocalDelivery +
            0.10f * result.gazeDelivery +
            0.35f * result.slideSpeechAlignment;

        return ClampDelta(deltaE, deltaV, deltaC);
    }

    public static Vector3 CalculateTotalDelta(
        PresentationEvaluationResult result,
        float contentWeight = 0.5f,
        float deliveryWeight = 0.5f
    )
    {
        Vector3 contentDelta = CalculateContentDelta(result);
        Vector3 deliveryDelta = CalculateDeliveryDelta(result);

        Vector3 totalDelta =
            contentDelta * contentWeight +
            deliveryDelta * deliveryWeight;

        return ClampDelta(totalDelta.x, totalDelta.y, totalDelta.z);
    }

    private static Vector3 ClampDelta(float deltaE, float deltaV, float deltaC)
    {
        return new Vector3(
            Mathf.Clamp(deltaE, -1f, 1f),
            Mathf.Clamp(deltaV, -1f, 1f),
            Mathf.Clamp(deltaC, -1f, 1f)
        );
    }
}