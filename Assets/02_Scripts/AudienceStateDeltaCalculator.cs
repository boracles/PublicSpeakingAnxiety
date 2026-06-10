using UnityEngine;

public static class AudienceStateDeltaCalculator
{
    public static Vector3 CalculateContentDelta(PresentationEvaluationResult result)
    {
        float deltaE =
            0.50f * result.organization +
            0.50f * result.centralMessage;

        float deltaV =
            1.00f * result.supportingMaterial +
            1.00f * result.cerValidity;

        float deltaC =
            1.00f * result.organization +
            0.50f * result.supportingMaterial +
            1.00f * result.centralMessage +
            0.50f * result.cerValidity;

        return ClampDelta(deltaE, deltaV, deltaC);
    }

    public static Vector3 CalculateDeliveryDelta(PresentationEvaluationResult result)
    {
        float deltaE =
            0.50f * result.languageClarity +
            1.00f * result.vocalDelivery +
            1.00f * result.gazeDelivery;

        float deltaV =
            0.50f * result.vocalDelivery +
            0.50f * result.gazeDelivery +
            0.50f * result.slideSpeechAlignment;

        float deltaC =
            1.00f * result.languageClarity +
            1.00f * result.slideSpeechAlignment;

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