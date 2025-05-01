using UnityEngine;

public class AvatarFSM : MonoBehaviour
{
    Animator anim;
    void Awake()=> anim=GetComponent<Animator>();

    public void RaiseHand() => anim.SetTrigger("Raise");
    public void ToIdle()    => anim.SetTrigger("Idle");
}
