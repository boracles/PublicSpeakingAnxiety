using System.Collections;
using System.IO;
using UnityEngine;

public class RealTimeInterviewManager : MonoBehaviour
{
    [Header("서버 주소 (실전 연동용)")]
    public string apiURL = "https://jihoo-server.com/api/interview/stream";

    [Header("참조 오브젝트 설정")]
    public Transform vrCamera;          // VR 메인 카메라
    public Animator[] audienceAnimators; // 청중  Animator들
    public LayerMask centerWallLayer;   // 정면 시선 감지용 레이어

    private AudioClip micClip;
    private bool isInterviewing = false;
    private int sampleRate = 16000;      // 16kHz
    private string saveFolderPath;

    void Start()
    {
        // 파일이 저장될 폴더 경로 설정 (유니티 프로젝트 폴더 내부 Assets/SavedAudio/)
        saveFolderPath = Path.Combine(Application.dataPath, "SavedAudio");
        
        // 만약 폴더가 없으면 자동으로 새로 만듭니다.
        if (!Directory.Exists(saveFolderPath))
        {
            Directory.CreateDirectory(saveFolderPath);
        }

        Debug.Log($"[시스템] 오디오 저장 폴더 경로: {saveFolderPath}");

        // 면접 즉시 기동
        StartInterview();
    }

    public void StartInterview()
    {
        if (Microphone.devices.Length > 0)
        {
            isInterviewing = true;
            StartCoroutine(InterviewLoop());
            Debug.Log("[시스템] 5초 단위 추적 및 파일 저장 루프 시작!");
        }
        else
        {
            Debug.LogError("[에러] 마이크를 찾을 수 없습니다!");
        }
    }

    private IEnumerator InterviewLoop()
    {
        int timeline = 0;

        while (isInterviewing)
        {
            // 1. 5초 녹음 시작
            micClip = Microphone.Start(null, false, 5, sampleRate);
            
            float hitCount = 0;
            float totalFrames = 0;
            float timer = 0;

            // 2. 5초 대기 및 시선 계산
            while (timer < 5f)
            {
                timer += Time.deltaTime;
                totalFrames++;
                if (Physics.Raycast(vrCamera.position, vrCamera.forward, 100f, centerWallLayer))
                {
                    hitCount++;
                }
                yield return null;
            }

            Microphone.End(null); // 녹음 오프
            timeline += 5;        // 시간 증가

            float eyeContactRatio = (totalFrames > 0) ? (hitCount / totalFrames) : 0f;

            // 3. 오디오를 .wav 바이트 배열로 인코딩
            byte[] wavBytes = WavUtility.FromAudioClip(micClip);

            // 🌟 4. [추가] 내 컴퓨터 실제 폴더에 파일 저장하기!
            string fileName = $"speech_{timeline}s.wav";
            string fullPath = Path.Combine(saveFolderPath, fileName);
            File.WriteAllBytes(fullPath, wavBytes);
            Debug.Log($"<color=green>[파일 저장 완료]</color> 경로: {fullPath}");

            // 5. 가상 연산 및 애니메이션 트리거 호출
            StartCoroutine(SendPackage(wavBytes, eyeContactRatio, timeline));
        }
    }

    private IEnumerator SendPackage(byte[] audioData, float eyeRatio, int timeStamp)
    {
        Debug.Log($"<color=cyan>[5초 데이터 생성]</color> 타임라인: {timeStamp}초 / 시선 고정률: {eyeRatio * 100:F1}%");
        yield return new WaitForSeconds(0.2f);

        // 기본 자동 가짜 반응 생성 (키보드 수동 조작을 하지 않을 때의 대비책)
        string[] fakeReactions = { "Good_Nod", "Bad_Distracted", "Normal_Idle" };
        string chosenReaction = fakeReactions[Random.Range(0, fakeReactions.Length)];

        TriggerAudienceAnimation(chosenReaction);
    }

    // 🎭 외부(수동 가짜 상태 테스트)나 내부에서 공용으로 찌르는 애니메이션 연출 창구
    public void TriggerAudienceAnimation(string reactionCode)
    {
        Debug.Log($"<color=yellow>[애니메이션 발동]</color> 상태 코드: {reactionCode}");

        foreach (Animator anim in audienceAnimators)
        {
            if (anim == null) continue;

            if (reactionCode == "Good_Nod")
            {
                anim.SetTrigger("PlayAgreementNod");
            }
            else if (reactionCode == "Bad_Distracted")
            {
                anim.SetTrigger("PlayLowEngagement");
            }
            else if (reactionCode == "Normal_Idle")
            {
                anim.SetTrigger("ReturnToIdle");
            }
        }
    }
}