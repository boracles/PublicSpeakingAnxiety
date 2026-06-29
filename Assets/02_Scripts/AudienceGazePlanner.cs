using UnityEngine;

public class AudienceGazePlanner : MonoBehaviour
{
    public AudienceAgent agent;

    [Header("Probability")]
    [Range(0f, 1f)] public float speakerWeight = 0.55f;
    [Range(0f, 1f)] public float slideWeight = 0.25f;
    [Range(0f, 1f)] public float laptopWeight = 0.10f;
    [Range(0f, 1f)] public float awayWeight = 0.10f;

    private void Awake()
    {
        if (agent == null)
            agent = GetComponent<AudienceAgent>();
    }

    public AudienceGazeTargetType PickGazeTarget()
    {
        if (agent == null)
            return AudienceGazeTargetType.Speaker;

        float total = speakerWeight + slideWeight + awayWeight;

        if (agent.hasLaptop && agent.laptopTarget != null)
        {
            total += laptopWeight;
        }

        float r = Random.value * total;

        if (r < speakerWeight)
            return AudienceGazeTargetType.Speaker;

        r -= speakerWeight;

        if (r < slideWeight)
            return AudienceGazeTargetType.Slide;

        r -= slideWeight;

        if (agent.hasLaptop && agent.laptopTarget != null)
        {
            if (r < laptopWeight)
                return AudienceGazeTargetType.Laptop;

            r -= laptopWeight;
        }

        return AudienceGazeTargetType.Away;
    }

    public Transform GetTargetTransform(AudienceGazeTargetType targetType)
    {
        if (agent == null)
            return null;

        switch (targetType)
        {
            case AudienceGazeTargetType.Speaker:
                return agent.speakerTarget;

            case AudienceGazeTargetType.Slide:
                return agent.slideTarget;

            case AudienceGazeTargetType.Laptop:
                return agent.hasLaptop ? agent.laptopTarget : agent.speakerTarget;

            case AudienceGazeTargetType.Away:
                return agent.awayTarget;

            default:
                return agent.speakerTarget;
        }
    }
}