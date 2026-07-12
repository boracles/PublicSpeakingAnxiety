using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HumanoidAudienceManager : MonoBehaviour
{
    // 인스펙터에서 깔끔하게 관리할 수 있는 클립 데이터 구조
    [System.Serializable]
    public struct AudienceClipData
    {
        [Tooltip("대표 클립 ID (예: AL_03, BL_01)")]
        public string clipId;
        
        [Tooltip("이 ID 하위에 존재하는 실제 애니메이터 상태(방) 이름들 (Variation)")]
        public List<string> animatorStateNames;
    }

    [Header("▶ 청중 애니메이션 데이터베이스")]
    [Tooltip("여기에 26개 노가다하셨던 것처럼 Clip ID와 실제 애니메이터 방 이름들을 매핑해 주세요.")]
    public List<AudienceClipData> clipDatabase = new List<AudienceClipData>();

    [Header("▶ 제어할 청중들 (Animator 컴포넌트들)")]
    [Tooltip("씬에 배치된 청중 6명의 Animator를 여기에 드래그 앤 드롭으로 다 넣어주세요.")]
    public List<Animator> audienceAnimators = new List<Animator>();

    [Header("▶ 시간차(Delay) 세팅")]
    public float minDelay = 0.1f; // 's'를 'f'로 올바르게 수정했습니다!
    public float maxDelay = 0.6f; // 's'를 'f'로 올바르게 수정했습니다!

    [Header("▶ 키보드 스페이스바 테스트용 클립 ID")]
    [Tooltip("플레이 중에 스페이스바를 누르면, 여기에 적은 Clip ID가 강제로 실행됩니다! (예: AL_03)")]
    public string testClipId = "AL_03"; 

    // 외부(서버 등)에서 이 함수를 "AL_03" 같은 ID와 함께 호출하면 작동합니다.
    public void PlayAudienceReaction(string targetId)
    {
        // 1. 데이터베이스에서 입력받은 ID가 있는지 찾기
        AudienceClipData foundData = clipDatabase.Find(data => data.clipId == targetId);

        // 예외 처리: 데이터가 없거나 변형 애니메이션 리스트가 비어있다면 무시
        if (string.IsNullOrEmpty(foundData.clipId) || foundData.animatorStateNames == null || foundData.animatorStateNames.Count == 0)
        {
            Debug.LogWarning($"[경고] 입력된 클립 ID '{targetId}'를 데이터베이스에서 찾을 수 없거나 하위 리스트가 비어있습니다.");
            return;
        }

        Debug.Log($"[매니저] 클립 ID '{targetId}' 신호 수신! 청중 6명에게 시간차 랜덤 분배를 시작합니다.");

        // 2. 모든 청중에게 시간차를 두고 애니메이션을 재생시키는 코루틴 실행
        foreach (Animator audience in audienceAnimators)
        {
            if (audience == null) continue;

            // 하위 Variation 리스트 중에서 랜덤으로 하나를 초이스 (예: AL_03_01, AL_03_02 중 랜덤)
            int randomIndex = Random.Range(0, foundData.animatorStateNames.Count);
            string chosenStateName = foundData.animatorStateNames[randomIndex];

            // 각각의 청중이 따로따로 시간차를 갖도록 독립적인 코루틴으로 실행
            StartCoroutine(PlayWithRandomDelay(audience, chosenStateName));
        }
    }

    // 시간차를 만들어주는 핵심 기능
    private IEnumerator PlayWithRandomDelay(Animator animator, string stateName)
    {
        // minDelay(0.1초) ~ maxDelay(0.6초) 사이의 무작위 시간을 기다림
        float randomDelay = Random.Range(minDelay, maxDelay);
        yield return new WaitForSeconds(randomDelay);

        // 대기 시간이 끝나면 해당 청중에게 애니메이션 재생 명령 투하!
        animator.Play(stateName);
    }

    void Update()
    {
        // 테스트용: 플레이 중에 스페이스바를 누르면 인스펙터 창의 'Test Clip Id'에 적힌 값을 가져와 실행합니다.
        if (Input.GetKeyDown(KeyCode.Space))
        {
            PlayAudienceReaction(testClipId);
        }
    }
}