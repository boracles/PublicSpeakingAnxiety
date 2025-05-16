using UnityEngine;
using System.Collections;

public class ExperimentManager : MonoBehaviour {
    [SerializeField] QAController qa;
    [SerializeField] float presentationSec = 300f;      // 5분

    FeedbackMode[] order = { FeedbackMode.None,
        FeedbackMode.Gesture,
        FeedbackMode.Spatial };

    void Start() {
        Shuffle(order);          // Fisher–Yates 무작위
        StartCoroutine(MainRoutine());
    }

    IEnumerator MainRoutine() {
        foreach (var mode in order) {
            Debug.Log($"[Experiment] Mode = {mode}");
            yield return PresentationBlock();               // 5분 발표 대기
            yield return qa.RunTwoQuestions(mode);          // 질문 2개
        }
        Debug.Log("<color=lime>[Experiment] All sets finished</color>");
    }

    IEnumerator PresentationBlock() {
        float t = presentationSec;
        while (t > 0f) { t -= Time.deltaTime; yield return null; }
    }

    /* Fisher-Yates */
    void Shuffle(FeedbackMode[] arr) {
        for (int i = arr.Length-1; i > 0; --i) {
            int j = Random.Range(0, i+1);
            (arr[i], arr[j]) = (arr[j], arr[i]);
        }
    }
}