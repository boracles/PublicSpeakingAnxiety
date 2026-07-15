using UnityEngine;

public sealed class AudienceAnimationActor : MonoBehaviour
{
    [Header("Animator")]
    [Tooltip("비워두면 현재 오브젝트와 자식에서 Animator를 자동으로 찾습니다.")]
    [SerializeField] private Animator animator;

    [Header("Seat role")]
    [Tooltip("일반 좌석=0, 3열 왼쪽=1, 3열 오른쪽=2")]
    [SerializeField] private int seatRole;

    [Header("Animator parameter names")]
    [SerializeField] private string groupParameter = "GroupID";
    [SerializeField] private string motionParameter = "MotionID";
    [SerializeField] private string variantParameter = "VariantID";
    [SerializeField] private string seatRoleParameter = "SeatRole";
    [SerializeField] private string playTrigger = "ChangeGroup";

    public int SeatRole => seatRole;
    public int CurrentGroup { get; private set; } = -1;
    public int CurrentMotion { get; private set; } = -1;
    public int CurrentVariant { get; private set; } = -1;

    private void Awake()
    {
        FindAnimator();

        if (animator == null)
        {
            Debug.LogError(
                $"[AudienceAnimationActor] {gameObject.name}에서 Animator를 찾지 못했습니다.",
                this);

            return;
        }

        animator.SetInteger(seatRoleParameter, seatRole);
    }

    private void FindAnimator()
    {
        if (animator != null)
            return;

        animator = GetComponent<Animator>();

        if (animator == null)
            animator = GetComponentInChildren<Animator>(true);
    }

    /// <summary>
    /// 청중 생성 코드에서 좌석에 따라 호출합니다.
    /// 일반=0, 3열 왼쪽=1, 3열 오른쪽=2
    /// </summary>
    public void SetSeatRole(int role)
    {
        seatRole = role;

        FindAnimator();

        if (animator != null)
            animator.SetInteger(seatRoleParameter, seatRole);
    }

    public void Play(int groupId, int motionId, int variantId)
    {
        FindAnimator();

        if (animator == null)
        {
            Debug.LogWarning(
                $"[AudienceAnimationActor] {gameObject.name}의 Animator가 없어 실행할 수 없습니다.",
                this);

            return;
        }

        CurrentGroup = groupId;
        CurrentMotion = motionId;
        CurrentVariant = variantId;

        animator.SetInteger(groupParameter, groupId);
        animator.SetInteger(motionParameter, motionId);
        animator.SetInteger(variantParameter, variantId);
        animator.SetInteger(seatRoleParameter, seatRole);

        animator.ResetTrigger(playTrigger);
        animator.SetTrigger(playTrigger);
    }
}