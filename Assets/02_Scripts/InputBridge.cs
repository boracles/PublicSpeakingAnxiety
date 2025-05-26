using UnityEngine;
using UnityEngine.InputSystem;

public class InputBridge : MonoBehaviour
{
    [SerializeField] QAController qa;

    InputAction aButtonAction;    // 런타임 생성

    void Awake()
    {
        // ① 런타임 InputAction 생성
        aButtonAction = new InputAction(
            name: "A_Button",
            type: InputActionType.Button);

        // ② 필요한 바인딩 추가 (원하는 만큼)
        aButtonAction.AddBinding("<XRController>{RightHand}/primaryButton"); // Quest A
        aButtonAction.AddBinding("<Gamepad>/buttonSouth");                  // 일반 게임패드 A
        aButtonAction.AddBinding("<Keyboard>/space");                       // 스페이스

        // ③ 콜백 구독
        aButtonAction.performed += _ => qa.OnButtonPressed();
        aButtonAction.canceled  += _ => qa.OnButtonReleased();
    }

    void OnEnable()  => aButtonAction.Enable();
    void OnDisable() => aButtonAction.Disable();

    /* ── 레거시 폴링 백업(선택) ── */
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.JoystickButton0)) qa.OnButtonPressed();
        if (Input.GetKeyUp  (KeyCode.JoystickButton0)) qa.OnButtonReleased();
    }
}