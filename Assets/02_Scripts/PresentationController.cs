using UnityEngine;

public class PresentationController : MonoBehaviour
{
    [SerializeField] private RealtimeSttController sttController;

    public void StartPresentation()
    {
        // 기존 발표 시작 로직
        // 타이머 시작
        // 청중 반응 초기화
        // 발표 단계 초기화

        sttController.StartStt();
    }

    public void EndPresentation()
    {
        // 기존 발표 종료 로직
        // 타이머 중지
        // 최종 평가 정리

        sttController.StopStt();
    }
}