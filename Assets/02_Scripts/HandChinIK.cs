/*
 * HandChinIK.cs
 *  ─────────────────────────────────────────────────────
 *  특정 애니메이터 스테이트(예: “Sitting Bored Hand Chin”)가
 *  활성화되어 있을 때만 IK로 손 위치·회전을 턱 앞에 맞춰 줍니다.
 *  - Idle·다른 포즈에서는 가중치가 서서히 0으로 내려가 손이 제자리로 복귀합니다.
 */
using UnityEngine;

[RequireComponent(typeof(Animator))]
public class HandChinIK : MonoBehaviour
{
    /* ---------- 레퍼런스 ---------- */
    [Header("References")]
    [SerializeField] Animator  anim;            // 아바타 Animator
    [SerializeField] Transform chinTarget;      // 턱 앞쪽 빈 오브젝트

    /* ---------- IK 옵션 ---------- */
    [Header("IK Options")]
    [Tooltip("IK를 적용할 애니메이터 스테이트 이름 (대·소문자 일치)")]
    [SerializeField] string ikStateName = "Sitting Bored Hand Chin";

    [Tooltip("애니메이터 레이어 인덱스 (Base Layer = 0)")]
    [SerializeField] int layerIndex = 0;

    [Tooltip("ChinTarget에서 살짝 전방으로 띄울 오프셋(m)")]
    [SerializeField] Vector3 localOffset = new(0f, 0f, 0.07f);

    [Tooltip("IK 가중치 전환 속도 (초당 변화량)")]
    [Range(1f, 20f)]
    [SerializeField] float blendSpeed = 5f;

    /* ---------- 내부 상태 ---------- */
    float ikWeight;  // 0 ↔ 1 사이 부드럽게 변화

    /* ---------- IK 처리 ---------- */
    void OnAnimatorIK(int _)
    {
        if (!anim || !chinTarget) return;

        // (1) 현재 스테이트가 목표 이름인가?
        bool active = anim.GetCurrentAnimatorStateInfo(layerIndex).IsName(ikStateName);

        // (2) weight 부드럽게 보간
        float target = active ? 1f : 0f;
        ikWeight = Mathf.MoveTowards(ikWeight, target, Time.deltaTime * blendSpeed);

        // (3) 가중치 적용
        anim.SetIKPositionWeight(AvatarIKGoal.RightHand, ikWeight);

        if (ikWeight > 0f)
        {
            // 위치
            Vector3 pos = chinTarget.position + chinTarget.TransformVector(localOffset);
            anim.SetIKPosition(AvatarIKGoal.RightHand, pos);

            // 회전
            Vector3 palmFwd = (chinTarget.position - pos).normalized;
            Quaternion rot  = Quaternion.LookRotation(palmFwd, chinTarget.up);

            float rotW = ikWeight * 0.4f;               // 40 %
            anim.SetIKRotationWeight(AvatarIKGoal.RightHand, rotW);
            anim.SetIKRotation     (AvatarIKGoal.RightHand, rot);
        }
        else
        {
            // 비활성 구간에서는 회전 가중치를 0으로
            anim.SetIKRotationWeight(AvatarIKGoal.RightHand, 0f);
        }

    }

#if UNITY_EDITOR
    /* ---------- 자동 레퍼런스 채우기 ---------- */
    void Reset()
    {
        anim = GetComponent<Animator>();
    }
#endif
}
