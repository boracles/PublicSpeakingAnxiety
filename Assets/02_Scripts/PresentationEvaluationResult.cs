using UnityEngine;

[System.Serializable]
public class PresentationEvaluationResult
{
    [Header("Content Evaluation M_t")]
    [Range(-1f, 1f)] public float organization;
    [Range(-1f, 1f)] public float supportingMaterial;
    [Range(-1f, 1f)] public float centralMessage;
    [Range(-1f, 1f)] public float cerValidity;

    [Header("Delivery Evaluation D_t")]
    [Range(-1f, 1f)] public float languageClarity;
    [Range(-1f, 1f)] public float vocalDelivery;
    [Range(-1f, 1f)] public float gazeDelivery;
    [Range(-1f, 1f)] public float slideSpeechAlignment;
}