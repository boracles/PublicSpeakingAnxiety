using System.Collections;
using TMPro;
using UnityEngine;

public class AudienceBackchannelOutput : MonoBehaviour
{
    [Header("World Text")]
    public TextMeshPro backchannelText;

    [Header("References")]
    public AudienceBackchannelPlanner planner;
    public AudienceGazePlanner gazePlanner;

    [Header("Timing")]
    public float interval = 5f;

    private Coroutine displayCoroutine;

    private void Awake()
    {
        if (planner == null)
            planner = GetComponent<AudienceBackchannelPlanner>();

        if (gazePlanner == null)
            gazePlanner = GetComponent<AudienceGazePlanner>();
    }

    private void Start()
    {
        if (backchannelText != null)
        {
            backchannelText.text = "";
            backchannelText.gameObject.SetActive(false);
        }

        StartCoroutine(OutputLoop());
    }

    private IEnumerator OutputLoop()
    {
        while (true)
        {
            yield return new WaitForSeconds(interval);

            if (planner == null)
                continue;

            AudienceBackchannelCommand command = planner.PlanBackchannel();

            if (command == null)
                continue;

            ExecuteCommand(command);
        }
    }

    private void ExecuteCommand(AudienceBackchannelCommand command)
    {
        Transform gazeTarget = null;

        if (gazePlanner != null)
        {
            gazeTarget = gazePlanner.GetTargetTransform(command.gazeTarget);
        }

        string gazeName = gazeTarget != null ? gazeTarget.name : "NULL";

        Debug.Log(
            $"{gameObject.name} backchannel: {command.behaviorId} / " +
            $"utterance: {command.utterance} / gaze: {command.gazeTarget} -> {gazeName}"
        );

        if (!string.IsNullOrEmpty(command.utterance))
        {
            ShowText(command.utterance, command.duration);
        }

        // 여기서 나중에 Animator / IK 연결
        // PlayBodyAnimation(command.behaviorId);
        // PlayFaceAnimation(command.behaviorId);
        // SetGazeTarget(gazeTarget);
    }

    private void ShowText(string text, float duration)
    {
        if (backchannelText == null)
            return;

        if (displayCoroutine != null)
            StopCoroutine(displayCoroutine);

        displayCoroutine = StartCoroutine(ShowTextRoutine(text, duration));
    }

    private IEnumerator ShowTextRoutine(string text, float duration)
    {
        backchannelText.gameObject.SetActive(true);
        backchannelText.text = text;

        yield return new WaitForSeconds(duration);

        backchannelText.text = "";
        backchannelText.gameObject.SetActive(false);

        displayCoroutine = null;
    }
}