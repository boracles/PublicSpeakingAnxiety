using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

public class AudienceAnimationController : MonoBehaviour
{
//     // 유니티 인스펙터에서 채우는 리스트? 다 지워버렸습니다. 
//     // 이제 코드가 폴더를 읽어와서 알아서 내부 메모리에 이 리스트를 만듭니다.
//     private struct AudienceClipData
//     {
//         public string clipId;
//         public List<string> animatorStateNames;
//     }
//     private List<AudienceClipData> clipDatabase = new List<AudienceClipData>();

//     [Header("▶ 애니메이션 파일들이 모여있는 폴더 경로")]
//     [Tooltip("Assets 폴더 하위 경로를 적어주세요. 예: Clips/Female")]
//     public string folderPath = "Clips/Female";

//     [Header("▶ 제어할 청중 Animator들 (6명 전부 드래그)")]
//     public List<Animator> audienceAnimators = new List<Animator>();

//     // ==========================================
//     // ★ [Hazel님 전용 숏컷 코너]
//     // 재생하고 싶은 클립 ID를 여기서 직접 수정하고 저장하세요!
//     // ==========================================
//     private const string TARGET_CLIP_ID = "EM_07"; 

//     [Header("▶ 랜덤 시간차(Delay) 범위 세팅")]
//     public float minDelay = 0.1f;
//     public float maxDelay = 0.6f;

//     void Awake()
//     {
//         // 게임이 켜지자마자 지정된 폴더의 애니메이션 파일명들을 싹 긁어 모읍니다.
//         BuildDatabaseFromFolder();
//     }

//     void Start()
//     {
//         // 자동 빌드 완료 후 바로 실행!
//         PlayAllReactions(TARGET_CLIP_ID);
//     }

//     // [핵심 기능] 폴더에서 파일명 추출해서 자동으로 ID 그룹 매핑하기
//     void BuildDatabaseFromFolder()
// {
//     clipDatabase.Clear();
    
//     // 경로를 인스펙터에서 안 받고, 그냥 Assets/Clips 전체를 검색하게 만듭니다.
//     string searchPath = Application.dataPath + "/06_Animations/Clips/Female"; 
    
//     if (!Directory.Exists(searchPath))
//     {
//         Debug.LogError($"[에러] Assets/Clips 폴더를 찾을 수 없습니다. 경로를 확인하세요: {searchPath}");
//         return;
//     }

//     // 폴더 내 모든 파일을 검색
//     string[] files = Directory.GetFiles(searchPath, "*.*", SearchOption.AllDirectories);

//     foreach (string file in files)
//     {
//         if (file.EndsWith(".meta") || (!file.EndsWith(".fbx") && !file.EndsWith(".anim"))) continue;

//         string fileName = Path.GetFileNameWithoutExtension(file);
//         string[] nameParts = fileName.Split('_');
//         string clipId = (nameParts.Length >= 2) ? (nameParts[0] + "_" + nameParts[1]) : fileName;

//         int index = clipDatabase.FindIndex(d => d.clipId == clipId);
//         if (index >= 0)
//         {
//             if (!clipDatabase[index].animatorStateNames.Contains(fileName))
//                 clipDatabase[index].animatorStateNames.Add(fileName);
//         }
//         else
//         {
//             clipDatabase.Add(new AudienceClipData { clipId = clipId, animatorStateNames = new List<string> { fileName } });
//         }
//     }
// }
//     public void PlayAllReactions(string targetId)
//     {
//         AudienceClipData foundData = clipDatabase.Find(data => data.clipId == targetId);

//         if (string.IsNullOrEmpty(foundData.clipId) || foundData.animatorStateNames == null || foundData.animatorStateNames.Count == 0)
//         {
//             Debug.LogWarning($"[매니저] 자동 빌드된 데이터베이스에서 '{targetId}' ID를 찾을 수 없습니다.");
//             return;
//         }

//         foreach (Animator targetAnimator in audienceAnimators)
//         {
//             if (targetAnimator == null) continue;

//             // 자동 매핑된 Variation 목록 중 랜덤 초이스
//             int randomIndex = Random.Range(0, foundData.animatorStateNames.Count);
//             string chosenStateName = foundData.animatorStateNames[randomIndex];

//             StartCoroutine(PlayWithRandomDelay(targetAnimator, chosenStateName));
//         }
//     }

//     private IEnumerator PlayWithRandomDelay(Animator targetAnimator, string stateName)
//     {
//         float randomDelay = Random.Range(minDelay, maxDelay);
//         yield return new WaitForSeconds(randomDelay);

//         if (targetAnimator != null)
//         {
//             targetAnimator.Play(stateName);
//             Debug.Log($"[{targetAnimator.gameObject.name}] {randomDelay:F2}초 대기 후 랜덤 모션 '{stateName}' 재생!");
//         }
//     }

//     void Update()
//     {
//         if (Input.GetKeyDown(KeyCode.Space))
//         {
//             PlayAllReactions(TARGET_CLIP_ID);
//         }
//     }
}