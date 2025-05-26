using UnityEngine;
using UnityEngine.Animations.Rigging;

public class AvatarLookAt : MonoBehaviour
{
    [SerializeField] Rig headRig;
    [SerializeField] MultiAimConstraint headConstraint;
    [SerializeField] Transform[] lookTargets; // 0 = Player, 1 = Monitor
    [SerializeField] float smooth = 4f;
    [SerializeField] float minSwitchTime = 1.5f;
    [SerializeField] float maxSwitchTime = 4f;

    [Header("External Input")]
    [SerializeField] TTSPlayer tts;
    [SerializeField] SpeechRecognizer stt;

    float switchTimer = 0f;
    float nextSwitchDelay = 0f;
    int currentTargetIndex = -1;
    
    float minLockTime = 1.0f;
    float lockTimer = 0f;

    void Start()
    {
        PickNewTarget();
    }

    void Update()
    {
        bool ttsSpeaking = tts && tts.IsSpeaking;
        bool playerSpeaking = stt && stt.IsUserSpeaking;

        float tgt = (ttsSpeaking || playerSpeaking) ? 1f : 0f;
        headRig.weight = Mathf.Lerp(headRig.weight, tgt, Time.deltaTime * smooth);

        if (playerSpeaking && headRig.weight > 0.95f)
        {
            switchTimer += Time.deltaTime;
            lockTimer += Time.deltaTime;

            if (switchTimer >= nextSwitchDelay && lockTimer >= minLockTime)
            {
                PickNewTarget();
                lockTimer = 0f;
            }
        }
        else if (ttsSpeaking)
        {
            SetLookTarget(lookTargets[0]); // 플레이어 쪽만 고정
        }
        else
        {
            switchTimer = 0f;
        }
    }

    void PickNewTarget()
    {
        switchTimer = 0f;
        nextSwitchDelay = Random.Range(minSwitchTime, maxSwitchTime);

        int nextIndex;
        do
        {
            nextIndex = Random.Range(0, lookTargets.Length);
        } while (nextIndex == currentTargetIndex); // 반복 방지

        currentTargetIndex = nextIndex;
        SetLookTarget(lookTargets[currentTargetIndex]);
    }

    void SetLookTarget(Transform target)
    {
        var src = headConstraint.data.sourceObjects;
        src.SetTransform(0, target);
        headConstraint.data.sourceObjects = src;
    }
}
