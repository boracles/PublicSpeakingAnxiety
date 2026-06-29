using System.Collections.Generic;
using UnityEngine;

public class AudienceSessionRandomizer : MonoBehaviour
{
    [Header("Audience Prefabs")]
    public AudienceAgent[] audiencePrefabs;

    [Header("Runtime Spawned Agents")]
    public List<AudienceAgent> agents = new List<AudienceAgent>();

    [Header("Seat Slots")]
    public AudienceSeatSlot[] seatSlots;

    [Header("Common Gaze Targets")]
    public Transform speakerTarget;
    public Transform slideTarget;

    [Header("Session User Settings")]
    public AudienceSettingLevel topicInterest = AudienceSettingLevel.Medium;
    public AudienceSettingLevel priorKnowledge = AudienceSettingLevel.Medium;

    [Header("Laptop Settings")]
    public int laptopCount = 3;
    public GameObject[] laptopPrefabs;

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
        ClearSpawnedAudienceAndLaptops();
        SpawnAudienceAtRandomSeats();
        ApplySessionSettingsToAgents();
        RandomizeBehaviorTraits();
        RandomizeLaptopsBySeat();
    }

    private void SpawnAudienceAtRandomSeats()
    {
        if (audiencePrefabs == null || audiencePrefabs.Length == 0)
        {
            Debug.LogWarning("Audience prefabs are not assigned.");
            return;
        }

        if (seatSlots == null || seatSlots.Length == 0)
        {
            Debug.LogWarning("Seat slots are not assigned.");
            return;
        }

        List<AudienceSeatSlot> availableSeats = new List<AudienceSeatSlot>();

        foreach (AudienceSeatSlot seat in seatSlots)
        {
            if (seat == null)
                continue;

            seat.hasLaptop = false;
            availableSeats.Add(seat);
        }

        Shuffle(availableSeats);

        List<AudienceAgent> availablePrefabs = new List<AudienceAgent>();

        foreach (AudienceAgent prefab in audiencePrefabs)
        {
            if (prefab != null)
                availablePrefabs.Add(prefab);
        }

        Shuffle(availablePrefabs);

        int count = Mathf.Min(availablePrefabs.Count, availableSeats.Count);

        for (int i = 0; i < count; i++)
        {
            AudienceAgent prefab = availablePrefabs[i];
            AudienceSeatSlot seat = availableSeats[i];

            AudienceAgent spawnedAgent = Instantiate(
                prefab,
                seat.seatPoint.position,
                seat.seatPoint.rotation
            );

            spawnedAgent.name = prefab.name;

            spawnedAgent.AssignSeat(seat);
            spawnedAgent.speakerTarget = speakerTarget;
            spawnedAgent.slideTarget = slideTarget;
            spawnedAgent.hasLaptop = false;

            agents.Add(spawnedAgent);
        }
    }

    private void ApplySessionSettingsToAgents()
    {
        if (agents == null || agents.Count == 0)
            return;

        Vector2 topicRange = GetRangeByLevel(topicInterest);
        Vector2 knowledgeRange = GetRangeByLevel(priorKnowledge);

        float[] topicValues = GenerateEvenlyDistributedValues(topicRange, agents.Count);
        float[] knowledgeValues = GenerateEvenlyDistributedValues(knowledgeRange, agents.Count);

        Shuffle(topicValues);
        Shuffle(knowledgeValues);

        for (int i = 0; i < agents.Count; i++)
        {
            AudienceAgent agent = agents[i];

            if (agent == null)
                continue;

            float offsetE = Random.Range(stateOffsetRange.x, stateOffsetRange.y);
            float offsetC = Random.Range(stateOffsetRange.x, stateOffsetRange.y);

            agent.ApplySessionValues(
                topicValues[i],
                knowledgeValues[i],
                offsetE,
                offsetC
            );
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

    private void RandomizeLaptopsBySeat()
    {
        if (laptopPrefabs == null || laptopPrefabs.Length == 0)
        {
            Debug.LogWarning("Laptop prefabs are not assigned.");
            return;
        }

        List<AudienceAgent> seatedAgents = new List<AudienceAgent>();

        foreach (AudienceAgent agent in agents)
        {
            if (agent != null && agent.currentSeat != null)
                seatedAgents.Add(agent);
        }

        Shuffle(seatedAgents);

        List<GameObject> availableLaptopPrefabs = new List<GameObject>();

        foreach (GameObject prefab in laptopPrefabs)
        {
            if (prefab != null)
                availableLaptopPrefabs.Add(prefab);
        }

        Shuffle(availableLaptopPrefabs);

        int count = Mathf.Min(laptopCount, seatedAgents.Count, availableLaptopPrefabs.Count);

        for (int i = 0; i < count; i++)
        {
            AudienceAgent agent = seatedAgents[i];
            AudienceSeatSlot seat = agent.currentSeat;

            if (seat == null || seat.laptopAnchor == null)
                continue;

            seat.hasLaptop = true;
            agent.hasLaptop = true;

            GameObject laptop = Instantiate(
                availableLaptopPrefabs[i],
                seat.laptopAnchor.position,
                seat.laptopAnchor.rotation,
                seat.laptopAnchor
            );

            seat.spawnedLaptop = laptop;
            agent.spawnedLaptop = laptop;
        }
    }

    private void ClearSpawnedAudienceAndLaptops()
    {
        if (agents != null)
        {
            foreach (AudienceAgent agent in agents)
            {
                if (agent == null)
                    continue;

                if (agent.spawnedLaptop != null)
                    Destroy(agent.spawnedLaptop);

                Destroy(agent.gameObject);
            }

            agents.Clear();
        }

        if (seatSlots != null)
        {
            foreach (AudienceSeatSlot seat in seatSlots)
            {
                if (seat == null)
                    continue;

                seat.hasLaptop = false;

                if (seat.spawnedLaptop != null)
                {
                    Destroy(seat.spawnedLaptop);
                    seat.spawnedLaptop = null;
                }
            }
        }
    }

    private Vector2 GetRangeByLevel(AudienceSettingLevel level)
    {
        switch (level)
        {
            case AudienceSettingLevel.Low:
                return new Vector2(0.15f, 0.35f);

            case AudienceSettingLevel.High:
                return new Vector2(0.65f, 0.85f);

            default:
                return new Vector2(0.40f, 0.60f);
        }
    }

    private float[] GenerateEvenlyDistributedValues(Vector2 range, int count)
    {
        float[] values = new float[count];

        if (count <= 0)
            return values;

        if (count == 1)
        {
            values[0] = (range.x + range.y) * 0.5f;
            return values;
        }

        float min = Mathf.Min(range.x, range.y);
        float max = Mathf.Max(range.x, range.y);

        for (int i = 0; i < count; i++)
        {
            float t = i / (float)(count - 1);
            values[i] = Mathf.Lerp(min, max, t);
        }

        return values;
    }

    private void Shuffle<T>(List<T> list)
    {
        for (int i = 0; i < list.Count; i++)
        {
            int randomIndex = Random.Range(i, list.Count);
            T temp = list[i];
            list[i] = list[randomIndex];
            list[randomIndex] = temp;
        }
    }

    private void Shuffle(float[] array)
    {
        for (int i = 0; i < array.Length; i++)
        {
            int randomIndex = Random.Range(i, array.Length);
            float temp = array[i];
            array[i] = array[randomIndex];
            array[randomIndex] = temp;
        }
    }
}