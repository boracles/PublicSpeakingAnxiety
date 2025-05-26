using UnityEngine;
using UnityEngine.UI;
using TMPro;
using System.Collections;
using System.Collections.Generic;

public class QuestionPageController : MonoBehaviour
{
    [Header("순서대로 넣은 패널")]
    [SerializeField] List<GameObject> items;          // 1_Item, 2_Item, …

    [Header("선택/미선택 색")]
    [SerializeField] Color normalColor   = Color.gray;
    [SerializeField] Color selectedColor = Color.white;

    int   currentIdx = -1;
    int[] answers;
    bool  finished;

    /*──────────────── 초기화는 RunSurvey() 에서 ────────────────*/
    void Start() { }     // ← 비워 두거나 삭제해도 무방

    /*──────────────── Survey 루틴 ─────────────────────────────*/
    public IEnumerator RunSurvey()
    {
        // 1) 상태 리셋
        finished   = false;
        currentIdx = -1;
        answers    = new int[items.Count];

        foreach (var p in items) p.SetActive(false);

        // 2) 페이지 켜고 첫 문항 표시
        gameObject.SetActive(true);
        ShowItem(0);

        // 3) 세 문항 끝날 때까지 대기
        yield return new WaitUntil(() => finished);

        // 4) 페이지 끄기
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
            int value = int.Parse(btn.GetComponentInChildren<TMP_Text>().text);

            btn.onClick.RemoveAllListeners();
            btn.onClick.AddListener(() => OnClickLikert(value, btn));
            SetColor(btn, normalColor);
        }
    }

    void OnClickLikert(int value, Button clicked)
    {
        answers[currentIdx] = value;

        foreach (var b in clicked.transform.parent.GetComponentsInChildren<Button>())
            SetColor(b, b == clicked ? selectedColor : normalColor);

        int next = currentIdx + 1;
        if (next < items.Count) ShowItem(next);
        else                    FinishSurvey();
    }

    void SetColor(Button btn, Color c)
    {
        var img = btn.image;
        if (img) img.color = c;
    }

    void FinishSurvey()
    {
        finished = true;
        Debug.Log($"설문 완료: {string.Join(", ", answers)}");
        // 필요하면 여기서 결과 저장/전달
    }
}
