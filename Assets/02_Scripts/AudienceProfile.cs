using UnityEngine;

[CreateAssetMenu(fileName = "AudienceProfile", menuName = "Audience/Audience Profile")]
public class AudienceProfile : ScriptableObject
{
    [Header("Fixed Identity")]
    public string agentId;
    public AudienceBodyType bodyType;
}