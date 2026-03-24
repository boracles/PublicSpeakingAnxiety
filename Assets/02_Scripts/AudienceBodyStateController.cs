using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AudienceBodyStateController : MonoBehaviour
{
    [Header("References")]
    public Animator animator;

    [Header("Rig Control")]
    public Rig rig; // RigBuilder에 있는 Rig
    private float targetRigWeight = 1f;

    [Header("Driven Targets")]
    public Transform spine1Target;
    public Transform neck1Target;
    public Transform neck2Target;
    public Transform lowerarmLTarget;
    public Transform lowerarmRTarget;
    public Transform handRTarget;
    public Transform upperarmLTarget;
    public Transform upperarmRTarget;

    [Header("Pose References")]
    public Transform lowerarmLForwardLeanPose;
    public Transform lowerarmRForwardLeanPose;
    public Transform handRForwardLeanPose;
    public Transform upperarmLBackwardLeanClearPose;
    public Transform upperarmRBackwardLeanClearPose;

    [Header("Optional Constraint Weights")]
    public MultiRotationConstraint spine01RotFix;
    public MultiRotationConstraint neck1RotFix;
    public MultiRotationConstraint neck2RotFix;
    public MultiRotationConstraint upperarmLRotFix;
    public MultiRotationConstraint upperarmRRotFix;
    public MultiRotationConstraint lowerarmLRotFix;
    public MultiRotationConstraint lowerarmRRotFix;
    public MultiRotationConstraint handRRotFix;
    public MultiRotationConstraint handLRotFix;

    private float targetUpperarmLWeight;
    private float targetUpperarmRWeight;
    private float targetLowerarmLWeight;
    private float targetLowerarmRWeight;
    private float targetHandRWeight;
    private float targetHandLWeight;
    private float targetNeck1Weight;
    private float targetNeck2Weight;
    private Quaternion baseUpperarmLRot;
    private Quaternion baseUpperarmRRot;

    private Quaternion targetUpperarmLRot;
    private Quaternion targetUpperarmRRot;

    [Header("Blend Speeds")]
    public float postureBlendSpeed = 2.0f;
    public float rigWeightBlendSpeed = 15.0f;

    [Header("Current State")]
    public BodyState currentState = BodyState.NeutralUpright;

    private float targetSpine01Weight;
    private float targetSpine1Z;

    private float targetNeck1Z;
    private float targetNeck2Z;

    private Quaternion baseLowerarmLRot;
    private Quaternion baseLowerarmRRot;
    private Quaternion baseHandRRot;

    private Quaternion targetLowerarmLRot;
    private Quaternion targetLowerarmRRot;
    private Quaternion targetHandRRot;

    private static readonly int AnimStateParam = Animator.StringToHash("AnimState");
    private static readonly int VariantIndexParam = Animator.StringToHash("VariantIndex");

    void Start()
    {
        if (lowerarmLTarget != null)
            baseLowerarmLRot = lowerarmLTarget.localRotation;

        if (lowerarmRTarget != null)
            baseLowerarmRRot = lowerarmRTarget.localRotation;

        if (handRTarget != null)
            baseHandRRot = handRTarget.localRotation;

        if (upperarmLTarget != null)
            baseUpperarmLRot = upperarmLTarget.localRotation;

        if (upperarmRTarget != null)
            baseUpperarmRRot = upperarmRTarget.localRotation;

        ApplyStateImmediate(currentState);
    }

    void LateUpdate()
    {
        UpdateWeights();
    }

    public void SetState(BodyState newState)
    {
        currentState = newState;
        ApplyState(currentState);
    }

    private void ApplyState(BodyState state)
    {
        int animState = 0;

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

        switch (state)
        {
            case BodyState.NeutralUpright:
                animState = 0;
                break;
            case BodyState.AttentiveUpright:
                animState = 1;
                break;
            case BodyState.AttentiveForwardLean:
                animState = 2;
                break;
            case BodyState.LowEnergySlumpedSubtle:
                animState = 3;
                break;
            case BodyState.LowEnergySlumpedClear:
                animState = 4;
                break;
            case BodyState.ReservedBackwardLeanSubtle:
                animState = 5;
                break;
            case BodyState.ReservedBackwardLeanClear:
                animState = 6;
                break;
            default:
                animState = 0;
                break;
        }

        if (animator != null)
        {
            if (state == BodyState.LowEnergySlumpedSubtle ||
                state == BodyState.ReservedBackwardLeanSubtle ||
                state == BodyState.ReservedBackwardLeanClear)
            {
                int variantIndex = Random.Range(0, 2);
                animator.SetInteger(VariantIndexParam, variantIndex);
            }
            else
            {
                animator.SetInteger(VariantIndexParam, 0);
            }

            animator.SetInteger(AnimStateParam, animState);
        }

        switch (state)
        {
            case BodyState.NeutralUpright:
                targetRigWeight = 1f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.AttentiveUpright:
                targetRigWeight = 0.2f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.AttentiveForwardLean:
                targetRigWeight = 0.2f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.LowEnergySlumpedSubtle:
            targetRigWeight = 0.12f;
            if (rig != null) rig.weight = targetRigWeight;

            targetSpine01Weight = 0f;
            targetSpine1Z = -60f;
            targetNeck1Z = -82.5f;
            targetNeck2Z = -55f;
            targetLowerarmLRot = baseLowerarmLRot;
            targetLowerarmRRot = baseLowerarmRRot;
            targetHandRRot = baseHandRRot;
            break;

            case BodyState.LowEnergySlumpedClear:
                targetRigWeight = 0.08f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.ReservedBackwardLeanSubtle:
                targetRigWeight = 0.08f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.ReservedBackwardLeanClear:
                targetRigWeight = 1f;
                if (rig != null) rig.weight = targetRigWeight;

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

                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.SideOrientedNeutral:
            case BodyState.SelfRegulatingSelfContact:
            case BodyState.RestlessFidgetySeat:
                targetRigWeight = 1f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.SelfMonitoringSlightClosed:
                targetRigWeight = 1f;
                if (rig != null) rig.weight = targetRigWeight;

                targetSpine01Weight = 0.2f;
                targetSpine1Z = -62f;
                targetNeck1Z = -82.5f;
                targetNeck2Z = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;
        }
    }

    private Quaternion GetPoseRotation(Transform poseRef, Quaternion fallback)
    {
        if (poseRef == null)
            return fallback;

        return poseRef.localRotation;
    }

    private void ApplyStateImmediate(BodyState state)
    {
        ApplyState(state);

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

        if (lowerarmLTarget != null)
            lowerarmLTarget.localRotation = targetLowerarmLRot;

        if (lowerarmRTarget != null)
            lowerarmRTarget.localRotation = targetLowerarmRRot;

        if (handRTarget != null)
            handRTarget.localRotation = targetHandRRot;

        if (upperarmLTarget != null)
            upperarmLTarget.localRotation = targetUpperarmLRot;

        if (upperarmRTarget != null)
            upperarmRTarget.localRotation = targetUpperarmRRot;
    }

   private void UpdateWeights()
    {
        if (spine01RotFix != null)
        {
            spine01RotFix.weight = Mathf.Lerp(
                spine01RotFix.weight,
                targetSpine01Weight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (spine1Target != null)
        {
            Vector3 current = spine1Target.localEulerAngles;
            float z = Mathf.MoveTowardsAngle(current.z, targetSpine1Z, postureBlendSpeed * 30f * Time.deltaTime);
            spine1Target.localEulerAngles = new Vector3(current.x, current.y, z);
        }

        if (neck1Target != null)
        {
            Vector3 current = neck1Target.localEulerAngles;
            float z = Mathf.MoveTowardsAngle(current.z, targetNeck1Z, postureBlendSpeed * 30f * Time.deltaTime);
            neck1Target.localEulerAngles = new Vector3(current.x, current.y, z);
        }
        if (neck2Target != null)
        {
            Vector3 current = neck2Target.localEulerAngles;
            float z = Mathf.MoveTowardsAngle(current.z, targetNeck2Z, postureBlendSpeed * 30f * Time.deltaTime);
            neck2Target.localEulerAngles = new Vector3(current.x, current.y, z);
        }

        if (upperarmLTarget != null)
        {
            upperarmLTarget.localRotation = Quaternion.Slerp(
                upperarmLTarget.localRotation,
                targetUpperarmLRot,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (upperarmRTarget != null)
        {
            upperarmRTarget.localRotation = Quaternion.Slerp(
                upperarmRTarget.localRotation,
                targetUpperarmRRot,
                Time.deltaTime * postureBlendSpeed
            );
        }
        if (lowerarmLTarget != null)
        {
            lowerarmLTarget.localRotation = Quaternion.Slerp(
                lowerarmLTarget.localRotation,
                targetLowerarmLRot,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (lowerarmRTarget != null)
        {
            lowerarmRTarget.localRotation = Quaternion.Slerp(
                lowerarmRTarget.localRotation,
                targetLowerarmRRot,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (handRTarget != null)
        {
            handRTarget.localRotation = Quaternion.Slerp(
                handRTarget.localRotation,
                targetHandRRot,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (neck1RotFix != null)
        {
            neck1RotFix.weight = Mathf.Lerp(
                neck1RotFix.weight,
                targetNeck1Weight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (neck2RotFix != null)
        {
            neck2RotFix.weight = Mathf.Lerp(
                neck2RotFix.weight,
                targetNeck2Weight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (upperarmLRotFix != null)
        {
            upperarmLRotFix.weight = Mathf.Lerp(
                upperarmLRotFix.weight,
                targetUpperarmLWeight,
                Time.deltaTime * rigWeightBlendSpeed
            );
        }

        if (upperarmRRotFix != null)
        {
            upperarmRRotFix.weight = Mathf.Lerp(
                upperarmRRotFix.weight,
                targetUpperarmRWeight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (lowerarmLRotFix != null)
        {
            lowerarmLRotFix.weight = Mathf.Lerp(
                lowerarmLRotFix.weight,
                targetLowerarmLWeight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (lowerarmRRotFix != null)
        {
            lowerarmRRotFix.weight = Mathf.Lerp(
                lowerarmRRotFix.weight,
                targetLowerarmRWeight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (handRRotFix != null)
        {
            handRRotFix.weight = Mathf.Lerp(
                handRRotFix.weight,
                targetHandRWeight,
                Time.deltaTime * postureBlendSpeed
            );
        }

        if (handLRotFix != null)
        {
            handLRotFix.weight = Mathf.Lerp(
                handLRotFix.weight,
                targetHandLWeight,
                Time.deltaTime * postureBlendSpeed
            );
        }
    }
}