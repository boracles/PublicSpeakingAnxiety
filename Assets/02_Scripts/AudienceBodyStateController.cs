using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AudienceBodyStateController : MonoBehaviour
{
    [Header("References")]
    public Animator animator;

    [Header("Rig Control")]
    public Rig rig;
    private float targetRigWeight = 1f;

    [Header("Position Control")]
    public Transform bodyRoot;
    public float forwardLeanXOffset = -0.3f;

    private Vector3 baseBodyRootLocalPos;
    private Vector3 targetBodyRootLocalPos;

    [Header("Position Blend")]
    public float bodyRootPositionBlendSpeed = 8f;

    [Header("Driven Targets")]
    public Transform spine1Target;
    public Transform neck1Target;
    public Transform neck2Target;
    public Transform upperarmLTarget;
    public Transform upperarmRTarget;
    public Transform lowerarmLTarget;
    public Transform lowerarmRTarget;
    public Transform handRTarget;
    public Transform handLTarget;

    [Header("Pose References")]
    public Transform lowerarmLForwardLeanPose;
    public Transform lowerarmRForwardLeanPose;
    public Transform handRForwardLeanPose;
    public Transform upperarmLBackwardLeanClearPose;
    public Transform upperarmRBackwardLeanClearPose;
    public Transform handLSelfMonitoringPose;
    public Transform lowerarmLSelfMonitoringPose;
    public Transform lowerarmLSelfMonitoringMarkedPose;

    [Header("Optional Constraint Weights")]
    public MultiRotationConstraint spine01RotFix;
    public MultiRotationConstraint neck1RotFix;
    public MultiRotationConstraint neck2RotFix;
    public MultiRotationConstraint upperarmLRotFix;
    public MultiRotationConstraint upperarmRRotFix;
    public MultiRotationConstraint lowerarmLRotFix;
    public MultiRotationConstraint lowerarmRRotFix;
    public MultiRotationConstraint handLRotFix;
    public MultiRotationConstraint handRRotFix;

    [Header("Blend Speeds")]
    public float postureBlendSpeed = 2.0f;
    public float rigWeightBlendSpeed = 15.0f;

    [Header("Current State")]
    public BodyState currentState = BodyState.NeutralUpright;

    private BodyState baseState;
    private Coroutine temporaryActionCoroutine;
    private bool isTemporaryAction = false;

    private float targetSpine01Weight;
    private float targetNeck1Weight;
    private float targetNeck2Weight;
    private float targetUpperarmLWeight;
    private float targetUpperarmRWeight;
    private float targetLowerarmLWeight;
    private float targetLowerarmRWeight;
    private float targetHandLWeight;
    private float targetHandRWeight;

    private float targetSpine1Z;
    private float targetNeck1Z;
    private float targetNeck2Z;

    private Quaternion baseUpperarmLRot;
    private Quaternion baseUpperarmRRot;
    private Quaternion baseLowerarmLRot;
    private Quaternion baseLowerarmRRot;
    private Quaternion baseHandRRot;
    private Quaternion baseHandLRot;
    private Quaternion targetHandLRot;

    private Quaternion targetUpperarmLRot;
    private Quaternion targetUpperarmRRot;
    private Quaternion targetLowerarmLRot;
    private Quaternion targetLowerarmRRot;
    private Quaternion targetHandRRot;

    private static readonly int AnimStateParam = Animator.StringToHash("AnimState");
    private static readonly int VariantIndexParam = Animator.StringToHash("VariantIndex");

    private static readonly int SideOrientedTriggerParam = Animator.StringToHash("SideOrientedTrigger");
    private bool suppressNeckForSideAction = false;

    void Start()
    {
        if (bodyRoot != null)
        {
            baseBodyRootLocalPos = bodyRoot.localPosition;
            targetBodyRootLocalPos = baseBodyRootLocalPos;
        }

        if (upperarmLTarget != null) baseUpperarmLRot = upperarmLTarget.localRotation;
        if (upperarmRTarget != null) baseUpperarmRRot = upperarmRTarget.localRotation;
        if (lowerarmLTarget != null) baseLowerarmLRot = lowerarmLTarget.localRotation;
        if (lowerarmRTarget != null) baseLowerarmRRot = lowerarmRTarget.localRotation;
        if (handRTarget != null) baseHandRRot = handRTarget.localRotation;
        if (handLTarget != null) baseHandLRot = handLTarget.localRotation;

        baseState = currentState;
        ApplyStateImmediate(currentState);
    }

    void LateUpdate()
    {
        UpdateWeights();
    }

    public void SetState(BodyState newState)
    {
        baseState = newState;
        currentState = newState;
        isTemporaryAction = false;
        ApplyState(currentState);
    }

    private void ApplyState(BodyState state)
    {
        ResetTargetsToDefault();

        int animState = GetAnimState(state);
        int variantIndex = GetVariantIndex(state);

        if (animator != null)
        {
            animator.SetInteger(VariantIndexParam, variantIndex);
            animator.SetInteger(AnimStateParam, animState);
        }

        switch (state)
        {
            case BodyState.NeutralUpright:
                targetRigWeight = 1f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.AttentiveUpright:
                targetRigWeight = 0.2f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.AttentiveForwardLean:
                targetRigWeight = 0.2f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;

                targetLowerarmLRot = GetPoseRotation(lowerarmLForwardLeanPose, baseLowerarmLRot);
                targetLowerarmRRot = GetPoseRotation(lowerarmRForwardLeanPose, baseLowerarmRRot);
                targetHandRRot = GetPoseRotation(handRForwardLeanPose, baseHandRRot);

                if (bodyRoot != null)
                {
                    targetBodyRootLocalPos = baseBodyRootLocalPos + new Vector3(forwardLeanXOffset, 0f, 0f);
                }
                break;

            case BodyState.LowEnergySlumpedSubtle:
                targetRigWeight = 0.12f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.LowEnergySlumpedClear:
                targetRigWeight = 0.08f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.ReservedBackwardLeanSubtle:
                targetRigWeight = 0.08f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.ReservedBackwardLeanClear:
                targetRigWeight = 1f;
                targetSpine01Weight = 0f;

                targetNeck1Weight = 0f;
                targetNeck2Weight = 0f;

                targetUpperarmLWeight = 1f;
                targetUpperarmRWeight = 1f;

                targetLowerarmLWeight = 0f;
                targetLowerarmRWeight = 0f;
                targetHandLWeight = 0f;
                targetHandRWeight = 0f;

                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;

                targetUpperarmLRot = GetPoseRotation(upperarmLBackwardLeanClearPose, baseUpperarmLRot);
                targetUpperarmRRot = GetPoseRotation(upperarmRBackwardLeanClearPose, baseUpperarmRRot);
                break;

            case BodyState.SelfMonitoringSlightClosedSubtle:
                targetRigWeight = 1.0f;

                targetSpine01Weight = 0f;
                targetNeck1Weight = 0f;
                targetNeck2Weight = 0f;
                targetUpperarmLWeight = 0f;
                targetUpperarmRWeight = 0f;
                targetLowerarmLWeight = 1f;
                targetLowerarmRWeight = 0f;
                targetHandLWeight = 1f;
                targetHandRWeight = 0f;

                targetSpine1Z = -62f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;

                targetLowerarmLRot = GetPoseRotation(lowerarmLSelfMonitoringPose, baseLowerarmLRot);
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandLRot = GetPoseRotation(handLSelfMonitoringPose, baseHandLRot);
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.SelfMonitoringSlightClosedClear:
                targetRigWeight = 1.0f;

                targetSpine01Weight = 0f;
                targetNeck1Weight = 0.5f;
                targetNeck2Weight = 0f;
                targetUpperarmLWeight = 0f;
                targetUpperarmRWeight = 0f;
                targetLowerarmLWeight = 0f;
                targetLowerarmRWeight = 0f;
                targetHandLWeight = 1.0f;
                targetHandRWeight = 0f;

                targetSpine1Z = -63f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;

                targetLowerarmLRot = GetPoseRotation(lowerarmLSelfMonitoringMarkedPose, baseLowerarmLRot);
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandLRot = GetPoseRotation(handLSelfMonitoringPose, baseHandLRot);
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.SideOrientedNeutral:
                targetRigWeight = 1f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;

            case BodyState.SelfRegulatingDiscomfort:
                targetRigWeight = 1f;
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                break;
        }

        if (rig != null)
            rig.weight = targetRigWeight;
    }

    private int GetAnimState(BodyState state)
    {
        switch (state)
        {
            case BodyState.NeutralUpright: return 0;
            case BodyState.AttentiveUpright: return 1;
            case BodyState.AttentiveForwardLean: return 2;
            case BodyState.LowEnergySlumpedSubtle: return 3;
            case BodyState.LowEnergySlumpedClear: return 4;
            case BodyState.ReservedBackwardLeanSubtle: return 5;
            case BodyState.ReservedBackwardLeanClear: return 6;
            case BodyState.SelfMonitoringSlightClosedSubtle: return 7;
            case BodyState.SelfMonitoringSlightClosedClear: return 8;
            case BodyState.SideOrientedNeutral: return 9;
            case BodyState.SelfRegulatingDiscomfort: return 10;
            default: return 0;
        }
    }

    private int GetVariantIndex(BodyState state)
    {
        switch (state)
        {
            case BodyState.LowEnergySlumpedSubtle:
            case BodyState.ReservedBackwardLeanSubtle:
            case BodyState.ReservedBackwardLeanClear:
            case BodyState.SelfMonitoringSlightClosedSubtle:
            case BodyState.SideOrientedNeutral:
                return Random.Range(0, 2);

            default:
                return 0;
        }
    }

    private Quaternion GetPoseRotation(Transform poseRef, Quaternion fallback)
    {
        return poseRef == null ? fallback : poseRef.localRotation;
    }

    private void ApplyStateImmediate(BodyState state)
    {
        ApplyState(state);

        if (rig != null) rig.weight = targetRigWeight;

        if (spine01RotFix != null) spine01RotFix.weight = targetSpine01Weight;
        if (neck1RotFix != null) neck1RotFix.weight = targetNeck1Weight;
        if (neck2RotFix != null) neck2RotFix.weight = targetNeck2Weight;
        if (upperarmLRotFix != null) upperarmLRotFix.weight = targetUpperarmLWeight;
        if (upperarmRRotFix != null) upperarmRRotFix.weight = targetUpperarmRWeight;
        if (lowerarmLRotFix != null) lowerarmLRotFix.weight = targetLowerarmLWeight;
        if (lowerarmRRotFix != null) lowerarmRRotFix.weight = targetLowerarmRWeight;
        if (handLRotFix != null) handLRotFix.weight = targetHandLWeight;
        if (handRRotFix != null) handRRotFix.weight = targetHandRWeight;

        if (spine1Target != null)
        {
            Vector3 euler = spine1Target.localEulerAngles;
            spine1Target.localEulerAngles = new Vector3(euler.x, euler.y, targetSpine1Z);
        }

        if (neck1Target != null)
        {
            Vector3 euler = neck1Target.localEulerAngles;
            neck1Target.localEulerAngles = new Vector3(euler.x, euler.y, targetNeck1Z);
        }

        if (neck2Target != null)
        {
            Vector3 euler = neck2Target.localEulerAngles;
            neck2Target.localEulerAngles = new Vector3(euler.x, euler.y, targetNeck2Z);
        }

        if (upperarmLTarget != null) upperarmLTarget.localRotation = targetUpperarmLRot;
        if (upperarmRTarget != null) upperarmRTarget.localRotation = targetUpperarmRRot;
        if (lowerarmLTarget != null) lowerarmLTarget.localRotation = targetLowerarmLRot;
        if (lowerarmRTarget != null) lowerarmRTarget.localRotation = targetLowerarmRRot;
        if (handRTarget != null) handRTarget.localRotation = targetHandRRot;
        if (handLTarget != null)
            handLTarget.localRotation = targetHandLRot;
        if (bodyRoot != null)
            bodyRoot.localPosition = targetBodyRootLocalPos;
    }

    private void UpdateWeights()
    {
        if (rig != null)
            rig.weight = targetRigWeight;

        if (spine01RotFix != null)
            spine01RotFix.weight = targetSpine01Weight;

        if (neck1RotFix != null)
            neck1RotFix.weight = targetNeck1Weight;

        if (neck2RotFix != null)
            neck2RotFix.weight = targetNeck2Weight;

        if (upperarmLRotFix != null)
            upperarmLRotFix.weight = targetUpperarmLWeight;

        if (upperarmRRotFix != null)
            upperarmRRotFix.weight = targetUpperarmRWeight;

        if (lowerarmLRotFix != null)
            lowerarmLRotFix.weight = targetLowerarmLWeight;

        if (lowerarmRRotFix != null)
            lowerarmRRotFix.weight = targetLowerarmRWeight;

        if (handLRotFix != null)
            handLRotFix.weight = targetHandLWeight;

        if (handRRotFix != null)
            handRRotFix.weight = targetHandRWeight;

        if (spine1Target != null)
        {
            Vector3 euler = spine1Target.localEulerAngles;
            spine1Target.localEulerAngles = new Vector3(euler.x, euler.y, targetSpine1Z);
        }

        if (neck1Target != null)
        {
            Vector3 euler = neck1Target.localEulerAngles;
            neck1Target.localEulerAngles = new Vector3(euler.x, euler.y, targetNeck1Z);
        }

        if (neck2Target != null)
        {
            Vector3 euler = neck2Target.localEulerAngles;
            neck2Target.localEulerAngles = new Vector3(euler.x, euler.y, targetNeck2Z);
        }

        if (upperarmLTarget != null)
            upperarmLTarget.localRotation = targetUpperarmLRot;

        if (upperarmRTarget != null)
            upperarmRTarget.localRotation = targetUpperarmRRot;

        if (lowerarmLTarget != null)
            lowerarmLTarget.localRotation = targetLowerarmLRot;

        if (lowerarmRTarget != null)
            lowerarmRTarget.localRotation = targetLowerarmRRot;

        if (handRTarget != null)
            handRTarget.localRotation = targetHandRRot;

        if (handLTarget != null)
            handLTarget.localRotation = targetHandLRot;
        if (bodyRoot != null)
        {
            bodyRoot.localPosition = Vector3.Lerp(
                bodyRoot.localPosition,
                targetBodyRootLocalPos,
                Time.deltaTime * bodyRootPositionBlendSpeed
            );
        }
    }

    private void ResetTargetsToDefault()
    {
        targetNeck1Weight = 1f;
        targetNeck2Weight = 1f;
        targetUpperarmLWeight = 1f;
        targetUpperarmRWeight = 1f;
        targetLowerarmLWeight = 1f;
        targetLowerarmRWeight = 1f;
        targetHandLWeight = 1f;
        targetHandRWeight = 1f;

        targetUpperarmLRot = baseUpperarmLRot;
        targetUpperarmRRot = baseUpperarmRRot;
        targetLowerarmLRot = baseLowerarmLRot;
        targetLowerarmRRot = baseLowerarmRRot;
        targetHandRRot = baseHandRRot;
        targetHandLRot = baseHandLRot;

        targetBodyRootLocalPos = baseBodyRootLocalPos;
    }

    public void PlaySideOrientedAction()
    {
        if (animator == null) return;

        suppressNeckForSideAction = true;
        animator.ResetTrigger(SideOrientedTriggerParam);
        animator.SetTrigger(SideOrientedTriggerParam);
    }

    public void EndSideOrientedAction()
    {
        suppressNeckForSideAction = false;
    }
}