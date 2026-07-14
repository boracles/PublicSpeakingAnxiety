using UnityEngine;
using System.Collections.Generic;

public class SimpleRandomAnimator : MonoBehaviour
{
    private Animator animator;
    // 아까 그 목록입니다.
    private List<string> clipNames = new List<string> {
        "AL_01_active_following_F", "AL_01_agreement_nod_F", "AL_01_stable_attention_F",
        "AL_02_attentive_slide_check_F", "AL_02_slight_head_tilt_check_F",
        "AL_03_low_engagement_positive_F",
        "BL_01_neutral_listening_F", "BL_02_neutral_gaze_shift_F", "BL_03_quiet_stable_posture_F",
        "CT_01_comprehension_nod_F", "CT_01_slide_speaker_tracking_F", "CT_01_stable_comprehension_F",
        "CT_02_closed_comprehension_F", "CT_02_limited_nod_reserved_F", "CT_02_understood_but_reserved_F",
        "CT_03_delayed_gaze_return_F", "CT_03_understood_low_engagement_F", "CT_05_trying_to_understand_F",
        "EM_01_approving_smile_F", "EM_05_cold_monitoring_F","ACT_01_Laptop Typing"
    };

    void Start()
    {
        animator = GetComponent<Animator>();
        // 5초마다 랜덤으로 재생하는 루프 시작
        InvokeRepeating("PlayRandom", 0f, 5f);
    }

    void PlayRandom()
    {
        string randomClip = clipNames[Random.Range(0, clipNames.Count)];
        animator.CrossFade(randomClip, 0.5f);
    }
}