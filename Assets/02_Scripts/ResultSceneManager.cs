using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;
using TMPro;
using System.Collections.Generic;

public class ResultSceneManager : MonoBehaviour
{
    [Header("--- 결과 요약 점수 UI ---")]
    public TMP_Text totalScoreText;       
    public TMP_Text immersionText;        // 몰입도 (E 기반)
    public TMP_Text reliabilityText;      // 신뢰도 (V 기반)
    public TMP_Text clarityText;          // 명확도 (C 기반)

    [Header("--- 하단 제어 버튼들 ---")]
    public Button retrySessionButton;     
    public Button goToStartButton;        

    [Header("--- 하단 고정 안내 텍스트 ---")]
    public TMP_Text footerNoticeText;     

    void Start()
    {
        if (footerNoticeText != null)
        {
            footerNoticeText.text = "면접이 종료되었습니다. 상세분석리포트는 웹사이트 마이페이지에서 확인가능합니다.";
        }

        if (retrySessionButton != null)
            retrySessionButton.onClick.AddListener(OnRetrySessionPressed);

        if (goToStartButton != null)
            goToStartButton.onClick.AddListener(OnGoToStartPressed);

        // 🌟 진입 즉시 실제 누적 데이터 기반 연산 시작!
        CalculateAndDisplayResult();
    }

    private void CalculateAndDisplayResult()
    {
        // UserTracker에 정적으로 모인 데이터 리스트 가져오기
        List<int> eList = UserTracker.accumulatedE;
        List<int> vList = UserTracker.accumulatedV;
        List<int> cList = UserTracker.accumulatedC;
        List<int> eyeList = UserTracker.accumulatedEye;

        // 예외 처리: 만약 누적된 데이터가 하나도 없다면 기본값 처리
        if (eList.Count == 0)
        {
            if (totalScoreText != null) totalScoreText.text = "87"; //시연영상을위해 고정값
            if (immersionText != null) immersionText.text = "우수";
            if (reliabilityText != null) reliabilityText.text = "보통";
            if (clarityText != null) clarityText.text = "우수";
            return;
        }

        // 1. 각 지표별 평균값 계산
        float avgE = GetAverage(eList);
        float avgV = GetAverage(vList);
        float avgC = GetAverage(cList);
        float avgEye = GetAverage(eyeList);

        // 2. 100점 만점의 최종 종합 점수 계산 (E, V, C, 시선 점수의 전체 평균)
        float finalScoreCalculated = (avgE + avgV + avgC + avgEye) / 4f;
        int finalScoreRounded = Mathf.RoundToInt(finalScoreCalculated);

        // 3. UI 점수 텍스트 반영
        if (totalScoreText != null) 
        {
            totalScoreText.text = $"{finalScoreRounded}점";
        }

        // 4. 3단계 기준(우수/보통/부족) 판별 및 UI 반영
        if (immersionText != null) immersionText.text = EvaluateGrade(avgE);     // 몰입도
        if (reliabilityText != null) reliabilityText.text = EvaluateGrade(avgV); // 신뢰도
        if (clarityText != null) clarityText.text = EvaluateGrade(avgC);         // 명확도

        Debug.Log($"[연산완료] 종합점수: {finalScoreRounded}, E:{avgE:F1}, V:{avgV:F1}, C:{avgC:F1}, 시선:{avgEye:F1}");
    }

    // 평균을 구해주는 간단한 헬퍼 함수
    private float GetAverage(List<int> list)
    {
        float sum = 0;
        for (int i = 0; i < list.Count; i++)
        {
            sum += list[i];
        }
        return sum / list.Count;
    }

    // 점수대별 3단계 등급 평가 함수 (점수 커스텀 가능)
    private string EvaluateGrade(float averageScore)
    {
        if (averageScore >= 80f) return "우수";
        if (averageScore >= 50f) return "보통";
        return "부족";
    }

    void OnRetrySessionPressed()
    {
        // 다시 할 때는 예전 데이터 청소
        UserTracker.ClearAccumulatedData();
        SceneManager.LoadScene("Scene_02_Presentation_LhjBackup"); 
    }

    void OnGoToStartPressed()
    {
        UserTracker.ClearAccumulatedData();
        PresentationStageManager.IsReturningFromPresentation = true;
        SceneManager.LoadScene("Scene_01_Intro_LhjBackup"); 
    }
}