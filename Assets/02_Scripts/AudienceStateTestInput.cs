using UnityEngine;

public class AudienceStateTestInput : MonoBehaviour
{
    public AudienceBodyStateController controller;

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
            controller.SetState(BodyState.NeutralUpright);

        if (Input.GetKeyDown(KeyCode.Alpha2))
            controller.SetState(BodyState.AttentiveUpright);

        if (Input.GetKeyDown(KeyCode.Alpha3))
            controller.SetState(BodyState.AttentiveForwardLean);

        if (Input.GetKeyDown(KeyCode.Alpha4))
            controller.SetState(BodyState.LowEnergySlumpedSubtle);

        if (Input.GetKeyDown(KeyCode.Alpha5))
            controller.SetState(BodyState.LowEnergySlumpedClear);

        if (Input.GetKeyDown(KeyCode.Alpha6))
            controller.SetState(BodyState.ReservedBackwardLeanSubtle);

        if (Input.GetKeyDown(KeyCode.Alpha7))
            controller.SetState(BodyState.ReservedBackwardLeanClear);
    }
}