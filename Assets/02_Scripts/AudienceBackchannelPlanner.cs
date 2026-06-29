using UnityEngine;

public class AudienceBackchannelPlanner : MonoBehaviour
{
    public AudienceAgent agent;
    public AudienceState state;

    [Header("Temporary Context")]
    public AudienceUtterancePosition utterancePosition = AudienceUtterancePosition.DuringSpeech;

    public AudienceBackchannelCommand PlanBackchannel()
    {
        if (agent == null || state == null)
            return null;

        if (Random.value > agent.responsiveness)
            return null;

        float E = state.engagement;
        float V = state.evaluativeValence;
        float C = state.cognitiveClarity;

        // 0. E/V/C가 모두 중간이면 Baseline Listening 후보군에서 선택
        bool isBaseline =
            Mathf.Abs(E) <= 0.33f &&
            Mathf.Abs(V) <= 0.33f &&
            Mathf.Abs(C) <= 0.33f;

        if (isBaseline)
        {
            return PlanBaseline();
        }

        // 1. 강한 혼란 / 이해 부족
        if (C < -0.34f && E > -0.34f)
        {
            return new AudienceBackchannelCommand(
                "CT_05",
                "음...? 조금 헷갈리는데",
                AudienceGazeTargetType.Slide,
                2.5f
            );
        }

        // 2. 부정적 평가
        if (V < -0.34f)
        {
            string utterance = agent.criticalBias > 0.6f
                ? "근거가 조금 더 필요해 보여요"
                : "음... 조금 더 봐야겠어요";

            return new AudienceBackchannelCommand(
                "EM_05",
                utterance,
                AudienceGazeTargetType.Speaker,
                2.5f
            );
        }

        // 3. 긍정적 평가
        if (V > 0.34f && E > -0.34f)
        {
            return new AudienceBackchannelCommand(
                "EM_01",
                "아, 이해됐어요",
                AudienceGazeTargetType.Speaker,
                2f
            );
        }

        // 4. 이해도 높고 집중도 높음
        if (C > 0.34f && E > 0.34f)
        {
            return new AudienceBackchannelCommand(
                "CT_01",
                "음",
                AudienceGazeTargetType.Speaker,
                1.5f
            );
        }

        // 5. 주의 이탈
        if (E < -0.34f)
        {
            return new AudienceBackchannelCommand(
                "AL_05",
                "",
                AudienceGazeTargetType.Away,
                2f
            );
        }

        // 6. 노트북 있는 청중은 가끔 노트북 확인
        if (agent.hasLaptop && Random.value < 0.15f)
        {
            return new AudienceBackchannelCommand(
                "ACT_01",
                "",
                AudienceGazeTargetType.Laptop,
                2f
            );
        }

        // 7. 그 외 애매한 상태는 Baseline 후보군에서 선택
        return PlanBaseline();
    }

    private AudienceBackchannelCommand PlanBaseline()
    {
        switch (utterancePosition)
        {
            case AudienceUtterancePosition.SilenceOrPause:
                return PickWeightedBaseline(
                    ("BL_03", "", AudienceGazeTargetType.Away, 0.60f, 2f),
                    ("BL_01", "", AudienceGazeTargetType.Speaker, 0.25f, 2f),
                    ("BL_02", "", AudienceGazeTargetType.Slide, 0.15f, 2f)
                );

            case AudienceUtterancePosition.SlideReference:
                return PickWeightedBaseline(
                    ("BL_02", "", AudienceGazeTargetType.Slide, 0.60f, 2f),
                    ("BL_01", "", AudienceGazeTargetType.Speaker, 0.30f, 2f),
                    ("BL_03", "", AudienceGazeTargetType.Away, 0.10f, 2f)
                );

            case AudienceUtterancePosition.DuringSpeech:
            default:
                return PickWeightedBaseline(
                    ("BL_01", "", AudienceGazeTargetType.Speaker, 0.55f, 2f),
                    ("BL_02", "", AudienceGazeTargetType.Slide, 0.35f, 2f),
                    ("BL_03", "", AudienceGazeTargetType.Away, 0.10f, 2f)
                );
        }
    }

    private AudienceBackchannelCommand PickWeightedBaseline(
        (string id, string utterance, AudienceGazeTargetType gaze, float weight, float duration) a,
        (string id, string utterance, AudienceGazeTargetType gaze, float weight, float duration) b,
        (string id, string utterance, AudienceGazeTargetType gaze, float weight, float duration) c
    )
    {
        float total = a.weight + b.weight + c.weight;
        float r = Random.value * total;

        if (r < a.weight)
            return new AudienceBackchannelCommand(a.id, a.utterance, a.gaze, a.duration);

        r -= a.weight;

        if (r < b.weight)
            return new AudienceBackchannelCommand(b.id, b.utterance, b.gaze, b.duration);

        return new AudienceBackchannelCommand(c.id, c.utterance, c.gaze, c.duration);
    }
}