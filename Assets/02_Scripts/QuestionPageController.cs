using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Collections.Generic;

public class QuestionPageController : MonoBehaviour
{
    [Header("순서대로 넣은 패널")]
    [SerializeField] List<GameObject> items;

    [Header("선택/미선택 색")]
    [SerializeField] Color normalColor   = Color.gray;
    [SerializeField] Color selectedColor = Color.white;

    [Header("조건별 3번 문항 텍스트")]
    [TextArea] [SerializeField] string gestureQ3 =
        "아바타의 고개 끄덕임과 ‘음…’이 내가 말한 내용을 신중히 고민 중이라는 느낌을 주었다.";
    [TextArea] [SerializeField] string spatialQ3 =
        "빛 패드의 점등과 ‘딩’ 소리는 시스템이 정보를 처리 중임을 명확히 알려주었다.";

    FeedbackMode mode;            // ⬅️ ExperimentManager 등에서 넘겨줌
    int           currentIdx = -1;
    string[]      answers;        // 문자열로 저장
    bool          finished;

    public void Init(FeedbackMode m) => mode = m;  
    public IEnumerator RunSurvey(FeedbackMode m)
{
    mode = m;                        // ← 이제 정상
    finished   = false;
    currentIdx = -1;
    answers    = new string[items.Count];

    foreach (var p in items) p.SetActive(false);

    TMP_Text q3 = items[2].transform.Find("Text").GetComponent<TMP_Text>();
    q3.text = mode switch
    {
        FeedbackMode.Gesture => gestureQ3,
        FeedbackMode.Spatial => spatialQ3,
        _                    => gestureQ3
    };

    gameObject.SetActive(true);
    ShowItem(0);

    yield return new WaitUntil(() => finished);
    gameObject.SetActive(false);
}

    /*──────────────── 내부 메서드 ─────────────────────────────*/
    void ShowItem(int idx)
    {
        currentIdx = idx;

        for (int i = 0; i < items.Count; i++)
            items[i].SetActive(i == idx);

        foreach (var btn in items[idx].GetComponentsInChildren<Button>(true))
        {
            /* 버튼 글자 그대로 저장 */
            string value = btn.GetComponentInChildren<TMP_Text>().text;

            btn.onClick.RemoveAllListeners();                 // ★ 중복 방지
            btn.onClick.AddListener(() => OnClickLikert(value, btn));
            SetColor(btn, normalColor);
        }
    }

    void OnClickLikert(string value, Button clicked)
    {
        /* 1. 선택 색상 반영 */
        foreach (var b in clicked.transform.parent.GetComponentsInChildren<Button>())
            SetColor(b, b == clicked ? selectedColor : normalColor);

        /* 2. 저장 & 로그 */
        answers[currentIdx] = value;

        // 현재 문항의 질문 문구
        var qText = items[currentIdx]
            .transform.Find("Text")     // <— 패널에서 질문 Text 객체
            .GetComponent<TMP_Text>()
            .text;

        LogRecorder.I?.LogSurveyAnswer(currentIdx + 1, qText, value);

        /* 3. 다음 문항 or 종료 */
        int next = currentIdx + 1;
        if (next < items.Count) ShowItem(next);
        else                    FinishSurvey();
    }

    void SetColor(Button btn, Color c)
    {
        if (btn && btn.image) btn.image.color = c;
    }

    void FinishSurvey()
    {
        finished = true;
        Debug.Log($"설문 완료: {string.Join(", ", answers)}");
    }
}
