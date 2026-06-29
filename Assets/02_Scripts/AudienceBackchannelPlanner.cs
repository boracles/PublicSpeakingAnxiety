using UnityEngine;

public class AudienceBackchannelPlanner : MonoBehaviour
{
    public AudienceAgent agent;
    public AudienceState state;

    public string PlanBackchannel()
    {
        if (agent == null || state == null)
            return "";

        if (Random.value > agent.responsiveness)
            return "";

        float E = state.engagement;
        float V = state.evaluativeValence;
        float C = state.cognitiveClarity;

        if (C < -0.34f && E > -0.34f)
            return "음...? 조금 헷갈리는데";

        if (V < -0.34f)
        {
            if (agent.criticalBias > 0.6f)
                return "근거가 조금 더 필요해 보여요";

            return "음... 조금 더 봐야겠어요";
        }

        if (V > 0.34f && E > -0.34f)
            return "아, 이해됐어요";

        if (C > 0.34f && E > 0.34f)
            return "음";

        if (E < -0.34f)
            return "";

        if (agent.expressivity > 0.5f)
            return "음";

        return "";
    }
}