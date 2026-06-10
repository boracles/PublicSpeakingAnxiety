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
    [SerializeField] private PresetLevel priorKnowledge = PresetLevel.Low;

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

    [Header("Test Delta Input")]
    [SerializeField] private float testDeltaE = 0f;
    [SerializeField] private float testDeltaV = 0f;
    [SerializeField] private float testDeltaC = 0f;

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
            ApplyTestDelta();
        }
    }

    private void ApplyTestDelta()
    {
        audienceState.ApplyDelta(testDeltaE, testDeltaV, testDeltaC);
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

        // 초기 상태값: 사전 설정으로 계산된 고정값
        if (stateVectorValueText != null)
        {
            stateVectorValueText.text =
                $"({FormatSigned(initialEngagement)}, {FormatSigned(initialValence)}, {FormatSigned(initialClarity)})";
        }

        // 현재 상태값: Space 입력 등으로 갱신되는 런타임 값
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