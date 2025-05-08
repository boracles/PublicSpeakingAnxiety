using UnityEngine;

public class AvatarFSM : MonoBehaviour
{
    public enum State { Idle, Thinking, Speaking }

    State currentState;
    public void SetState(State state)
    {
        currentState = state;
        // 실제 애니메이션 전환 등 처리
    }
    
    Animator anim;
    void Awake()=> anim=GetComponent<Animator>();

    public void RaiseHand()
    {
        anim.SetTrigger("Raise");
    }

    public void ToIdle()
    { 
        SetState(State.Idle);
    }
}
