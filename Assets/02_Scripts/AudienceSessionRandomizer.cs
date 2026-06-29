using System.Collections.Generic;
using UnityEngine;

public class AudienceSessionRandomizer : MonoBehaviour
{
    [Header("Audience Agents")]
    public AudienceAgent[] agents;

    [Header("Session User Settings")]
    public AudienceSettingLevel topicInterest = AudienceSettingLevel.Medium;
    public AudienceSettingLevel priorKnowledge = AudienceSettingLevel.Medium;

    [Header("Laptop Settings")]
    public int laptopCount = 3;

    [Header("Initial State Offset")]
    public Vector2 stateOffsetRange = new Vector2(-0.05f, 0.05f);

    [Header("Behavior Trait Ranges")]
    public Vector2 responsivenessRange = new Vector2(0.40f, 0.75f);
    public Vector2 expressivityRange = new Vector2(0.30f, 0.70f);
    public Vector2 criticalBiasRange = new Vector2(0.25f, 0.75f);

    [Header("Run")]
    public bool randomizeOnStart = true;

    private void Start()
    {
        if (randomizeOnStart)
        {
            RandomizeSession();
        }
    }

    [ContextMenu("Randomize Audience Session")]
    public void RandomizeSession()
    {
        ApplySessionSettingsToAgents();
        RandomizeBehaviorTraits();
        RandomizeLaptops();
    }

    private void ApplySessionSettingsToAgents()
    {
        foreach (AudienceAgent agent in agents)
        {
            if (agent == null)
                continue;

            float offsetE = Random.Range(stateOffsetRange.x, stateOffsetRange.y);
            float offsetC = Random.Range(stateOffsetRange.x, stateOffsetRange.y);

            agent.ApplySessionSettings(topicInterest, priorKnowledge, offsetE, offsetC);
        }
    }

    private void RandomizeBehaviorTraits()
    {
        foreach (AudienceAgent agent in agents)
        {
            if (agent == null)
                continue;

            float responsiveness = Random.Range(responsivenessRange.x, responsivenessRange.y);
            float expressivity = Random.Range(expressivityRange.x, expressivityRange.y);
            float criticalBias = Random.Range(criticalBiasRange.x, criticalBiasRange.y);

            agent.ApplyBehaviorTraits(responsiveness, expressivity, criticalBias);
        }
    }

    private void RandomizeLaptops()
    {
        foreach (AudienceAgent agent in agents)
        {
            if (agent != null)
                agent.hasLaptop = false;
        }

        List<int> indices = new List<int>();

        for (int i = 0; i < agents.Length; i++)
        {
            if (agents[i] != null)
                indices.Add(i);
        }

        for (int i = 0; i < indices.Count; i++)
        {
            int randomIndex = Random.Range(i, indices.Count);
            int temp = indices[i];
            indices[i] = indices[randomIndex];
            indices[randomIndex] = temp;
        }

        int count = Mathf.Min(laptopCount, indices.Count);

        for (int i = 0; i < count; i++)
        {
            agents[indices[i]].hasLaptop = true;
        }
    }
}