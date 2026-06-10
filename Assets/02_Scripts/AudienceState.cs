using UnityEngine;

[System.Serializable]
public class AudienceState
{
    [Header("Agent Info")]
    public int agentId = 1;

    [Header("E/V/C State")]
    [Range(-1f, 1f)] public float engagement;
    [Range(-1f, 1f)] public float valence;
    [Range(-1f, 1f)] public float clarity;

    [Header("Sensitivity")]
    public float engagementSensitivity;
    public float claritySensitivity;

    public void SetInitialState(
        float initialEngagement,
        float initialValence,
        float initialClarity,
        float eSensitivity,
        float cSensitivity
    )
    {
        engagement = Mathf.Clamp(initialEngagement, -1f, 1f);
        valence = Mathf.Clamp(initialValence, -1f, 1f);
        clarity = Mathf.Clamp(initialClarity, -1f, 1f);

        engagementSensitivity = eSensitivity;
        claritySensitivity = cSensitivity;
    }

    public Vector3 GetStateVector()
    {
        return new Vector3(engagement, valence, clarity);
    }

    public void ApplyDelta(float deltaE, float deltaV, float deltaC)
    {
        if (deltaE < 0f)
        {
            deltaE *= engagementSensitivity;
        }

        if (deltaC < 0f)
        {
            deltaC *= claritySensitivity;
        }

        engagement = Mathf.Clamp(engagement + deltaE, -1f, 1f);
        valence = Mathf.Clamp(valence + deltaV, -1f, 1f);
        clarity = Mathf.Clamp(clarity + deltaC, -1f, 1f);
    }
}