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
            controller.SetState(BodyState.LowEnergySlumped);
    }
}