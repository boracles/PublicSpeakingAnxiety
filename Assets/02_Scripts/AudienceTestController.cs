using UnityEngine;

public class AudienceTestController : MonoBehaviour
{
    // 테스트할 청중 캐릭터의 Animator를 인스펙터에서 드래그 앤 드롭 하세요.
    [SerializeField] private Animator audienceAnimator; 

    // 1번 버튼: 격한 동의 (고개 끄덕임)
    public void PlayAgreementNod()
    {
        TriggerAnimation("Nod");
    }

    // 2번 버튼: 지루함 (낮은 몰입)
    public void PlayLowEngagement()
    {
        TriggerAnimation("Bored");
    }

    // 3번 버튼: 시선 분산 (두리번거림)
    public void PlayGazeShift()
    {
        TriggerAnimation("GazeShift");
    }

    private void TriggerAnimation(string triggerName)
    {
        if (audienceAnimator != null)
        {
            audienceAnimator.SetTrigger(triggerName);
            Debug.Log($"<color=yellow>[애니메이션 테스트]</color> {triggerName} 재생!");
        }
        else
        {
            Debug.LogError("[애니메이션 테스트] 캐릭터의 Animator가 연결되지 않았습니다!");
        }
    }
}