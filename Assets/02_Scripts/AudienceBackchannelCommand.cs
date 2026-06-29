using UnityEngine;

[System.Serializable]
public class AudienceBackchannelCommand
{
    public string behaviorId;
    public string utterance;
    public AudienceGazeTargetType gazeTarget;
    public float duration;

    public AudienceBackchannelCommand(
        string behaviorId,
        string utterance,
        AudienceGazeTargetType gazeTarget,
        float duration = 2f
    )
    {
        this.behaviorId = behaviorId;
        this.utterance = utterance;
        this.gazeTarget = gazeTarget;
        this.duration = duration;
    }
}