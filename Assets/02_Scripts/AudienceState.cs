using UnityEngine;

[System.Serializable]
public class AudienceState
{
    [Range(-1f, 1f)] public float engagement;
    [Range(-1f, 1f)] public float evaluativeValence;
    [Range(-1f, 1f)] public float cognitiveClarity;

    public void Clamp()
    {
        engagement = Mathf.Clamp(engagement, -1f, 1f);
        evaluativeValence = Mathf.Clamp(evaluativeValence, -1f, 1f);
        cognitiveClarity = Mathf.Clamp(cognitiveClarity, -1f, 1f);
    }
}