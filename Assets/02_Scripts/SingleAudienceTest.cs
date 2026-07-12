using UnityEngine;

public class SingleAudienceTest : MonoBehaviour
{
    private Animator animator;

    // 인스펙터 창에서 재생하고 싶은 방 이름(클립 ID)을 직접 타이핑할 수 있게 합니다.
    // 예: 애니메이터 창에 넣은 회색 방 이름이 "AL_03" 이라면 여기에 AL_03을 적으면 됩니다.
    [Header("재생할 애니메이션 상태(방) 이름")]
    public string targetClipId = "AL_03"; 

    void Awake()
    {
        animator = GetComponent<Animator>();
    }

    void Update()
    {
        // 1. 스페이스바를 누르면 지정한 애니메이션 방으로 강제 점프(재생)
        if (Input.GetKeyDown(KeyCode.Space))
        {
            Debug.Log($"[테스트] {targetClipId} 애니메이션 재생 시도!");
            
            // 화살표 조건 없이, 애니메이터 창에 있는 '방 이름'으로 즉시 애니메이션을 재생하는 함수입니다.
            animator.Play(targetClipId);
        }

        // 2. 알파벳 R 키를 누르면 다시 기본 대기(Idle) 상태로 복귀
        if (Input.GetKeyDown(KeyCode.R))
        {
            Debug.Log("[테스트] Idle 상태로 복귀!");
            animator.Play("Idle"); // 기본 주황색 방 이름인 "Idle"을 적어줍니다.
        }
    }
}