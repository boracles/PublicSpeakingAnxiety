using System.Collections;
using TMPro;
using UnityEngine;

public class AudienceBackchannelOutput : MonoBehaviour
{
    [Header("World Text")]
    public TextMeshPro backchannelText;

    [Header("References")]
    public AudienceBackchannelPlanner planner;

    [Header("Timing")]
    public float interval = 5f;
    public float displayDuration = 2f;

    private Coroutine displayCoroutine;

    private void Start()
    {
        if (backchannelText != null)
        {
            backchannelText.text = "";
            backchannelText.gameObject.SetActive(false);
        }

        StartCoroutine(BackchannelLoop());
    }

    private IEnumerator BackchannelLoop()
    {
        while (true)
        {
            yield return new WaitForSeconds(interval);

            if (planner == null)
                continue;

            string text = planner.PlanBackchannel();

            if (string.IsNullOrEmpty(text))
                continue;

            ShowBackchannel(text);
        }
    }

    private void ShowBackchannel(string text)
    {
        if (backchannelText == null)
            return;

        if (displayCoroutine != null)
            StopCoroutine(displayCoroutine);

        displayCoroutine = StartCoroutine(ShowTextRoutine(text));
    }

    private IEnumerator ShowTextRoutine(string text)
    {
        backchannelText.gameObject.SetActive(true);
        backchannelText.text = text;

        yield return new WaitForSeconds(displayDuration);

        backchannelText.text = "";
        backchannelText.gameObject.SetActive(false);

        displayCoroutine = null;
    }
}