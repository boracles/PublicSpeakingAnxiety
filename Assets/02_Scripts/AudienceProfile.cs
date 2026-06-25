public class AudienceProfile : ScriptableObject
{
    public string agentId; // AUD_A, AUD_B...
    public AudienceBodyType bodyType;
    public bool hasLaptop;

    public float topicInterest;
    public float priorKnowledge;

    public float responsiveness;
    public float expressivity;
    public float criticalBias;
}