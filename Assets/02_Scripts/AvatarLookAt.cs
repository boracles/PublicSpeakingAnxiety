using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AvatarLookAt : MonoBehaviour
{
    [SerializeField] Rig headRig;   // Rig 1 (Rig)
    [SerializeField] TTSPlayer tts; // TTSPlayer
    [SerializeField] float smooth = 4f;

    void Update()
    {
        float tgt = (tts && tts.IsSpeaking) ? 1f : 0f;
        headRig.weight = Mathf.Lerp(headRig.weight, tgt, Time.deltaTime * smooth);
    }
}
