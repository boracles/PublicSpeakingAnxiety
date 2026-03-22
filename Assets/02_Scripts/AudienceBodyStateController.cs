using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AudienceBodyStateController : MonoBehaviour
{
    [Header("References")]
    public Animator animator;

    [Header("Driven Targets")]
    public Transform spine1Target;
    public Transform neck2Target;
    public Transform lowerarmLTarget;
    public Transform lowerarmRTarget;
    public Transform handRTarget;

    [Header("Pose References")]
    public Transform lowerarmLForwardLeanPose;
    public Transform lowerarmRForwardLeanPose;
    public Transform handRForwardLeanPose;

    [Header("Optional Posture Fix")]
    public MultiRotationConstraint spine01RotFix;

    [Header("Blend Speeds")]
    public float postureBlendSpeed = 2.0f;

    [Header("Current State")]
    public BodyState currentState = BodyState.NeutralUpright;

    private BodyState previousState;

    private float targetSpine01Weight;
    private float targetSpine1Z;
    private float targetNeckZ;

    private Quaternion baseLowerarmLRot;
    private Quaternion baseLowerarmRRot;
    private Quaternion baseHandRRot;

    private Quaternion targetLowerarmLRot;
    private Quaternion targetLowerarmRRot;
    private Quaternion targetHandRRot;

    private static readonly int BodyStateParam = Animator.StringToHash("BodyState");

    void Start()
    {
        if (lowerarmLTarget != null)
            baseLowerarmLRot = lowerarmLTarget.localRotation;

        if (lowerarmRTarget != null)
            baseLowerarmRRot = lowerarmRTarget.localRotation;

        if (handRTarget != null)
            baseHandRRot = handRTarget.localRotation;

        previousState = currentState;
        ApplyStateImmediate(currentState);
    }

    void LateUpdate()
    {
        if (currentState != previousState)
        {
            ApplyState(currentState);
            previousState = currentState;
        }

        UpdateWeights();
    }

    public void SetState(BodyState newState)
    {
        currentState = newState;
    }

    private void ApplyState(BodyState state)
    {
        if (animator != null)
            animator.SetInteger(BodyStateParam, (int)state);

        switch (state)
        {
            case BodyState.NeutralUpright:
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeckZ = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.AttentiveUpright:
                targetSpine01Weight = 0.5f;
                targetSpine1Z = -66f;
                targetNeckZ = -65f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.AttentiveForwardLean:
                targetSpine01Weight = 1f;
                targetSpine1Z = -72f;
                targetNeckZ = -70f;
                targetLowerarmLRot = GetPoseRotation(lowerarmLForwardLeanPose, baseLowerarmLRot);
                targetLowerarmRRot = GetPoseRotation(lowerarmRForwardLeanPose, baseLowerarmRRot);
                targetHandRRot = GetPoseRotation(handRForwardLeanPose, baseHandRRot);
                break;

            case BodyState.LowEnergySlumped:
            case BodyState.ReservedBackwardLean:
            case BodyState.SideOrientedNeutral:
            case BodyState.SelfRegulatingSelfContact:
            case BodyState.RestlessFidgetySeat:
                targetSpine01Weight = 0f;
                targetSpine1Z = -60f;
                targetNeckZ = -55f;
                targetLowerarmLRot = baseLowerarmLRot;
                targetLowerarmRRot = baseLowerarmRRot;
                targetHandRRot = baseHandRRot;
                break;

            case BodyState.SelfMonitoringSlightClosed:
                targetSpine01Weight = 0.2f;
                targetSpine1Z = -62f;
                targetNeckZ = -58f;
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

        if (spine01RotFix != null)
            spine01RotFix.weight = targetSpine01Weight;

        if (spine1Target != null)
        {
            Vector3 euler = spine1Target.localEulerAngles;
            spine1Target.localEulerAngles = new Vector3(euler.x, euler.y, targetSpine1Z);
        }

        if (neck2Target != null)
        {
            Vector3 euler = neck2Target.localEulerAngles;
            neck2Target.localEulerAngles = new Vector3(euler.x, euler.y, targetNeckZ);
        }

        if (lowerarmLTarget != null)
            lowerarmLTarget.localRotation = targetLowerarmLRot;

        if (lowerarmRTarget != null)
            lowerarmRTarget.localRotation = targetLowerarmRRot;

        if (handRTarget != null)
            handRTarget.localRotation = targetHandRRot;
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
            float z = Mathf.LerpAngle(current.z, targetSpine1Z, Time.deltaTime * postureBlendSpeed);
            spine1Target.localEulerAngles = new Vector3(current.x, current.y, z);
        }

        if (neck2Target != null)
        {
            Vector3 current = neck2Target.localEulerAngles;
            float z = Mathf.LerpAngle(current.z, targetNeckZ, Time.deltaTime * postureBlendSpeed);
            neck2Target.localEulerAngles = new Vector3(current.x, current.y, z);
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
    }
}