using UnityEngine;
using System.Collections.Generic;

public class AudienceRandomController : MonoBehaviour
{
    private Animator animator;
    // 제공해주신 파일명 전체 목록 (확장자 .fbx 제외)
    private List<string> clipNames = new List<string> {
        "AL_01_active_following_F", "AL_01_agreement_nod_F", "AL_01_stable_attention_F",
        "AL_02_attentive_slide_check_F", "AL_02_slight_head_tilt_check_F",
        "AL_03_low_engagement_positive_F", "AL_03_passive_acceptance_F",
        "BL_01_neutral_listening_F", "BL_02_neutral_gaze_shift_F", "BL_03_quiet_stable_posture_F",
        "CT_01_comprehension_nod_F", "CT_01_slide_speaker_tracking_F", "CT_01_stable_comprehension_F",
        "CT_02_closed_comprehension_F", "CT_02_limited_nod_reserved_F", "CT_02_understood_but_reserved_F",
        "CT_03_delayed_gaze_return_F", "CT_03_understood_low_engagement_F",
        "CT_05_confused_glance_F", "CT_05_head_tilt_recheck_F", "CT_05_trying_to_understand_F",
        "EM_01_approving_smile_F"
    };

    void Start()
    {
        animator = GetComponent<Animator>();
        // 5초마다 랜덤 재생
        InvokeRepeating("PlayRandomClip", 0f, 5f);
    }

    void PlayRandomClip()
    {
        if (clipNames.Count > 0)
        {
            string randomClip = clipNames[Random.Range(0, clipNames.Count)];
            // 애니메이터에 있는 State 이름이 파일 이름과 일치해야 함
            animator.Play(randomClip);
            Debug.Log("재생 중: " + randomClip);
        }
    }
}