using TMPro;
using UnityEngine;

[ExecuteAlways]
public class AudiencePresetController : MonoBehaviour
{
    public enum PresetLevel
    {
        Low,
        Medium,
        High
    }

    [Header("Audience Preset")]
    [SerializeField] private PresetLevel topicInterest = PresetLevel.High;
    [SerializeField] private PresetLevel priorKnowledge = PresetLevel.High;

    [Header("Runtime Audience State")]
    [SerializeField] private AudienceState audienceState = new AudienceState();

    [Header("Prototype Setting")]
    [SerializeField] private int audienceCount = 1;

    [Header("HUD Value Texts")]
    [SerializeField] private TMP_Text topicInterestValueText;
    [SerializeField] private TMP_Text priorKnowledgeValueText;
    [SerializeField] private TMP_Text audienceCountValueText;
    [SerializeField] private TMP_Text stateVectorValueText;
    [SerializeField] private TMP_Text currentStateValueText;
    [SerializeField] private TMP_Text sensitivityVectorValueText;

    [Header("Test Presentation Evaluation Result")]
    [SerializeField] private PresentationEvaluationResult testEvaluationResult = new PresentationEvaluationResult();

    [Header("Evaluation Weight")]
    [Range(0f, 1f)]
    [SerializeField] private float contentWeight = 0.5f;

    [Range(0f, 1f)]
    [SerializeField] private float deliveryWeight = 0.5f;

    [Header("Debug Delta Result")]
    [SerializeField] private Vector3 lastCalculatedDelta;

    private float initialEngagement;
    private float initialValence;
    private float initialClarity;

    private void Awake()
    {
        ApplyPreset();
    }

    private void Start()
    {
        ApplyPreset();
    }

    private void OnValidate()
    {
        if (!Application.isPlaying)
        {
            ApplyPreset();
        }
    }

    public void ApplyPreset()
    {
        float topicInterestValue = ConvertLevelToValue(topicInterest);
        float priorKnowledgeValue = ConvertLevelToValue(priorKnowledge);

        initialEngagement = Mathf.Clamp((topicInterestValue - 0.50f) * 2.0f, -1.0f, 1.0f);
        initialValence = 0.00f;
        initialClarity = Mathf.Clamp((priorKnowledgeValue - 0.50f) * 2.0f, -1.0f, 1.0f);

        float engagementSensitivity = ConvertLevelToSensitivity(topicInterest);
        float claritySensitivity = ConvertLevelToSensitivity(priorKnowledge);

        if (audienceState == null)
        {
            audienceState = new AudienceState();
        }

        audienceState.SetInitialState(
            initialEngagement,
            initialValence,
            initialClarity,
            engagementSensitivity,
            claritySensitivity
        );

        UpdateHUD();
    }

    private void Update()
    {
        if (!Application.isPlaying)
        {
            return;
        }

        if (Input.GetKeyDown(KeyCode.Space))
        {
            ApplyTestEvaluation();
        }
    }

    private void ApplyTestEvaluation()
    {
        lastCalculatedDelta = AudienceStateDeltaCalculator.CalculateTotalDelta(
            testEvaluationResult,
            contentWeight,
            deliveryWeight
        );

        audienceState.ApplyDelta(
            lastCalculatedDelta.x,
            lastCalculatedDelta.y,
            lastCalculatedDelta.z
        );

        UpdateHUD();
    }

    private float ConvertLevelToValue(PresetLevel level)
    {
        switch (level)
        {
            case PresetLevel.Low:
                return 0.25f;
            case PresetLevel.Medium:
                return 0.50f;
            case PresetLevel.High:
                return 0.75f;
            default:
                return 0.50f;
        }
    }

    private float ConvertLevelToSensitivity(PresetLevel level)
    {
        switch (level)
        {
            case PresetLevel.Low:
                return 1.20f;
            case PresetLevel.Medium:
                return 1.00f;
            case PresetLevel.High:
                return 0.80f;
            default:
                return 1.00f;
        }
    }

    private string ConvertLevelToKorean(PresetLevel level)
    {
        switch (level)
        {
            case PresetLevel.Low:
                return "낮음";
            case PresetLevel.Medium:
                return "중간";
            case PresetLevel.High:
                return "높음";
            default:
                return "중간";
        }
    }

    private void UpdateHUD()
    {
        if (topicInterestValueText != null)
        {
            topicInterestValueText.text = ConvertLevelToKorean(topicInterest);
        }

        if (priorKnowledgeValueText != null)
        {
            priorKnowledgeValueText.text = ConvertLevelToKorean(priorKnowledge);
        }

        if (audienceCountValueText != null)
        {
            audienceCountValueText.text = $"{audienceCount}명";
        }

        if (stateVectorValueText != null)
        {
            stateVectorValueText.text =
                $"({FormatSigned(initialEngagement)}, {FormatSigned(initialValence)}, {FormatSigned(initialClarity)})";
        }

        if (currentStateValueText != null)
        {
            currentStateValueText.text =
                $"({FormatSigned(audienceState.engagement)}, {FormatSigned(audienceState.valence)}, {FormatSigned(audienceState.clarity)})";
        }

        if (sensitivityVectorValueText != null)
        {
            sensitivityVectorValueText.text =
                $"({audienceState.engagementSensitivity:0.00}, —, {audienceState.claritySensitivity:0.00})";
        }
    }

    private string FormatSigned(float value)
    {
        if (value > 0f)
        {
            return $"+{value:0.00}";
        }

        if (value < 0f)
        {
            return $"{value:0.00}";
        }

        return "0.00";
    }
}