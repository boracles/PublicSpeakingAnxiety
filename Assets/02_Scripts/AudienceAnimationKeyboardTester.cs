using System.Collections.Generic;
using UnityEngine;

/// <summary>
/// 씬 전체 청중 애니메이션 키보드 테스트 관리자입니다.
///
/// 1 = BL
/// 2 = AL
/// 3 = CT
/// 4 = EM
/// 5 = ACT
/// R = 현재 그룹 다시 랜덤 실행
/// </summary>
public sealed class AudienceAnimationKeyboardTester : MonoBehaviour
{
    private const int GroupBL = 0;
    private const int GroupAL = 1;
    private const int GroupCT = 2;
    private const int GroupEM = 3;
    private const int GroupACT = 4;

    [Header("Audience")]
    [Tooltip("실행 중 생성된 AudienceAnimationActor를 자동으로 찾습니다.")]
    [SerializeField] private AudienceAnimationActor[] audience;

    [Header("Keyboard test")]
    [SerializeField] private bool enableKeyboardInput = true;

    private int currentGroup = GroupBL;

    private struct MotionChoice
    {
        public MotionChoice(int motionId, int variantId)
        {
            MotionId = motionId;
            VariantId = variantId;
        }

        public int MotionId { get; }
        public int VariantId { get; }
    }

    private void Awake()
    {
        RefreshAudience();
    }

    private void Update()
    {
        if (!enableKeyboardInput)
            return;

        if (Input.GetKeyDown(KeyCode.Alpha1) ||
            Input.GetKeyDown(KeyCode.Keypad1))
        {
            PlayRandomBL();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha2) ||
                 Input.GetKeyDown(KeyCode.Keypad2))
        {
            PlayRandomAL();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha3) ||
                 Input.GetKeyDown(KeyCode.Keypad3))
        {
            PlayRandomCT();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha4) ||
                 Input.GetKeyDown(KeyCode.Keypad4))
        {
            PlayRandomEM();
        }
        else if (Input.GetKeyDown(KeyCode.Alpha5) ||
                 Input.GetKeyDown(KeyCode.Keypad5))
        {
            PlayRandomACT();
        }
        else if (Input.GetKeyDown(KeyCode.R))
        {
            ReplayCurrentGroup();
        }
    }

    private void RefreshAudience()
    {
        // 실행 중 프리팹으로 새로 생성된 청중을 다시 검색합니다.
        audience = FindObjectsByType<AudienceAnimationActor>(
            FindObjectsSortMode.None);
    }

    public void PlayRandomBL()
    {
        PlayRandomGroup(GroupBL);
    }

    public void PlayRandomAL()
    {
        PlayRandomGroup(GroupAL);
    }

    public void PlayRandomCT()
    {
        PlayRandomGroup(GroupCT);
    }

    public void PlayRandomEM()
    {
        PlayRandomGroup(GroupEM);
    }

    public void PlayRandomACT()
    {
        PlayRandomGroup(GroupACT);
    }

    public void ReplayCurrentGroup()
    {
        PlayRandomGroup(currentGroup);
    }

    public void PlayRandomGroup(int groupId)
    {
        // 키를 누른 시점에 존재하는 청중을 다시 찾습니다.
        RefreshAudience();

        if (audience == null || audience.Length == 0)
        {
            Debug.LogWarning(
                "[AudienceAnimationTester] 현재 생성된 청중 캐릭터가 없습니다.",
                this);

            return;
        }

        currentGroup = groupId;

        if (groupId == GroupACT)
        {
            ValidateSeatPair();
            PlayRandomACTForAudience();
        }
        else
        {
            PlayOrdinaryGroupForAudience(groupId);
        }
    }

    private void PlayOrdinaryGroupForAudience(int groupId)
    {
        List<MotionChoice> choices = BuildChoices(groupId);

        if (choices.Count == 0)
        {
            Debug.LogWarning(
                $"[AudienceAnimationTester] GroupID {groupId}의 후보가 없습니다.",
                this);

            return;
        }

        foreach (AudienceAnimationActor actor in audience)
        {
            if (actor == null)
                continue;

            MotionChoice choice =
                PickDifferentChoice(choices, actor, groupId);

            actor.Play(
                groupId,
                choice.MotionId,
                choice.VariantId);
        }

        Debug.Log(
            $"[AudienceAnimationTester] GroupID {groupId} 랜덤 실행, 청중 {audience.Length}명",
            this);
    }

    private void PlayRandomACTForAudience()
    {
        AudienceAnimationActor leftSeat = FindSeatRole(1);
        AudienceAnimationActor rightSeat = FindSeatRole(2);

        bool canPlayConversation =
            leftSeat != null && rightSeat != null;

        // ACT 후보 8개 중 8번이 선택되면
        // 3열 좌우 캐릭터가 동시에 대화합니다.
        bool playConversation =
            canPlayConversation && Random.Range(1, 9) == 8;

        foreach (AudienceAnimationActor actor in audience)
        {
            if (actor == null)
                continue;

            bool isConversationPair =
                actor == leftSeat || actor == rightSeat;

            if (playConversation && isConversationPair)
            {
                // 왼쪽 좌석(Role 1)은 오른쪽을 보는 모션,
                // 오른쪽 좌석(Role 2)은 왼쪽을 보는 모션이
                // Animator의 SeatRole 조건으로 선택됩니다.
                actor.Play(GroupACT, 8, 1);
            }
            else
            {
                int motionId = PickDifferentACTMotion(actor);
                actor.Play(GroupACT, motionId, 1);
            }
        }

        if (playConversation)
        {
            Debug.Log(
                "[AudienceAnimationTester] 3열 좌우 ACT_08 동시 실행",
                this);
        }
        else
        {
            Debug.Log(
                $"[AudienceAnimationTester] ACT 랜덤 실행, 청중 {audience.Length}명",
                this);
        }
    }

    private static int PickDifferentACTMotion(
        AudienceAnimationActor actor)
    {
        // ACT_01부터 ACT_07까지
        int motionId = Random.Range(1, 8);

        if (actor.CurrentGroup == GroupACT &&
            actor.CurrentMotion == motionId)
        {
            motionId = motionId % 7 + 1;
        }

        return motionId;
    }

    private AudienceAnimationActor FindSeatRole(int role)
    {
        foreach (AudienceAnimationActor actor in audience)
        {
            if (actor != null && actor.SeatRole == role)
                return actor;
        }

        return null;
    }

    private void ValidateSeatPair()
    {
        int leftCount = 0;
        int rightCount = 0;

        foreach (AudienceAnimationActor actor in audience)
        {
            if (actor == null)
                continue;

            if (actor.SeatRole == 1)
                leftCount++;

            if (actor.SeatRole == 2)
                rightCount++;
        }

        if (leftCount != 1 || rightCount != 1)
        {
            Debug.LogWarning(
                "[AudienceAnimationTester] ACT_08 동시 실행에는 " +
                "SeatRole 1과 2가 각각 한 명씩 필요합니다. " +
                $"현재 Role1={leftCount}, Role2={rightCount}",
                this);
        }
    }

    private static List<MotionChoice> BuildChoices(int groupId)
    {
        var choices = new List<MotionChoice>();

        switch (groupId)
        {
            case GroupBL:
                AddVariants(choices, 1, 3);
                break;

            case GroupAL:
                AddVariants(choices, 1, 3);
                AddVariants(choices, 2, 2);
                AddVariants(choices, 3, 2);
                break;

            case GroupCT:
                AddVariants(choices, 1, 3);
                AddVariants(choices, 2, 3);
                AddVariants(choices, 3, 2);
                AddVariants(choices, 5, 3);
                AddVariants(choices, 6, 3);
                AddVariants(choices, 7, 3);
                AddVariants(choices, 8, 3);
                break;

            case GroupEM:
                AddVariants(choices, 1, 3);
                AddVariants(choices, 2, 3);
                AddVariants(choices, 4, 2);
                AddVariants(choices, 5, 3);
                AddVariants(choices, 7, 3);
                break;
        }

        return choices;
    }

    private static void AddVariants(
        List<MotionChoice> choices,
        int motionId,
        int variantCount)
    {
        for (int variantId = 1;
             variantId <= variantCount;
             variantId++)
        {
            choices.Add(
                new MotionChoice(motionId, variantId));
        }
    }

    private static MotionChoice PickDifferentChoice(
        List<MotionChoice> choices,
        AudienceAnimationActor actor,
        int groupId)
    {
        int startIndex = Random.Range(0, choices.Count);

        for (int offset = 0;
             offset < choices.Count;
             offset++)
        {
            MotionChoice candidate =
                choices[(startIndex + offset) % choices.Count];

            bool isSameChoice =
                actor.CurrentGroup == groupId &&
                actor.CurrentMotion == candidate.MotionId &&
                actor.CurrentVariant == candidate.VariantId;

            if (!isSameChoice)
                return candidate;
        }

        return choices[startIndex];
    }
}