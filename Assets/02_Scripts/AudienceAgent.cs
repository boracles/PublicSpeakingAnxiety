using UnityEngine;

public class AudienceAgent : MonoBehaviour
{
    [Header("Fixed Profile")]
    public AudienceProfile profile;

    [Header("Runtime User Settings")]
    public AudienceSettingLevel topicInterest = AudienceSettingLevel.Medium;
    public AudienceSettingLevel priorKnowledge = AudienceSettingLevel.Medium;

    [Header("Runtime Scene Condition")]
    public bool hasLaptop;

    [Header("Gaze Targets")]
    public Transform speakerTarget;
    public Transform slideTarget;
    public Transform laptopTarget;
    public Transform awayTarget;

    [Header("Runtime Behavior Traits")]
    [Range(0f, 1f)] public float responsiveness = 0.5f;
    [Range(0f, 1f)] public float expressivity = 0.5f;
    [Range(0f, 1f)] public float criticalBias = 0.5f;

    [Header("Runtime State")]
    public AudienceState state = new AudienceState();

    [Header("Runtime Sensitivity")]
    public float engagementSensitivity = 1f;
    public float claritySensitivity = 1f;

    [Header("Components")]
    public AudienceBackchannelPlanner planner;
    public AudienceBackchannelOutput output;

    [Header("Debug Info")]
    public string agentId;
    public AudienceBodyType bodyType;

    private void Awake()
    {
        SyncFromProfile();
        CacheComponents();
        LinkComponents();
    }

    private void OnValidate()
    {
        SyncFromProfile();
    }

    private void SyncFromProfile()
    {
        if (profile == null)
            return;

        agentId = profile.agentId;
        bodyType = profile.bodyType;
    }

    private void CacheComponents()
    {
        if (planner == null)
            planner = GetComponent<AudienceBackchannelPlanner>();

        if (output == null)
            output = GetComponent<AudienceBackchannelOutput>();
    }

    private void LinkComponents()
    {
        if (planner != null)
        {
            planner.agent = this;
            planner.state = state;
        }

        if (output != null)
        {
            output.planner = planner;
        }
    }

    public void ApplySessionSettings(
        AudienceSettingLevel topic,
        AudienceSettingLevel knowledge,
        float stateOffsetE,
        float stateOffsetC
    )
    {
        topicInterest = topic;
        priorKnowledge = knowledge;

        float topicValue = LevelToValue(topicInterest);
        float knowledgeValue = LevelToValue(priorKnowledge);

        state.engagement = ToInitialStateValue(topicValue) + stateOffsetE;
        state.evaluativeValence = 0f;
        state.cognitiveClarity = ToInitialStateValue(knowledgeValue) + stateOffsetC;

        engagementSensitivity = LevelToDecreaseSensitivity(topicInterest);
        claritySensitivity = LevelToDecreaseSensitivity(priorKnowledge);

        state.Clamp();
    }

    public void ApplyBehaviorTraits(float newResponsiveness, float newExpressivity, float newCriticalBias)
    {
        responsiveness = Mathf.Clamp01(newResponsiveness);
        expressivity = Mathf.Clamp01(newExpressivity);
        criticalBias = Mathf.Clamp01(newCriticalBias);
    }

    public void ApplyEvaluationDelta(float deltaE, float deltaV, float deltaC)
    {
        if (deltaE >= 0f)
            state.engagement += deltaE;
        else
            state.engagement += deltaE * engagementSensitivity;

        state.evaluativeValence += deltaV;

        if (deltaC >= 0f)
            state.cognitiveClarity += deltaC;
        else
            state.cognitiveClarity += deltaC * claritySensitivity;

        state.Clamp();
    }

    private float LevelToValue(AudienceSettingLevel level)
    {
        switch (level)
        {
            case AudienceSettingLevel.Low:
                return 0.25f;
            case AudienceSettingLevel.High:
                return 0.75f;
            default:
                return 0.50f;
        }
    }

    private float ToInitialStateValue(float value)
    {
        return (value - 0.50f) * 2f;
    }

    private float LevelToDecreaseSensitivity(AudienceSettingLevel level)
    {
        switch (level)
        {
            case AudienceSettingLevel.Low:
                return 1.20f;
            case AudienceSettingLevel.High:
                return 0.80f;
            default:
                return 1.00f;
        }
    }
}