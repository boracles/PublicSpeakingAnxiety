using UnityEngine;
using System.Collections.Generic;

public class AudienceManager : MonoBehaviour
{
    public Animator[] audienceAnimators = new Animator[6];

    // DataCollector에서 호출할 메서드 (이름을 맞췄습니다)
    public void ProcessServerFeedback(string jsonResponse)
    {
        Debug.Log("서버 응답을 받았습니다: " + jsonResponse);
        // 향후 실제 로직을 여기에 구현하세요.
    }

    void Start()
    {
        InvokeRepeating("PlayAllRandom", 0f, 5f);
    }

    void PlayAllRandom()
    {
        // 중복 방지 로직 유지
        List<int> usedIndices = new List<int>();

        foreach (var animator in audienceAnimators)
        {
            int randomIndex;
            // 중복 방지 로직: 6명이 다 다른 클립을 재생하도록 함
            do
            {
                randomIndex = Random.Range(1, 45); 
            } while (usedIndices.Contains(randomIndex));
            
            usedIndices.Add(randomIndex);
            string clipName = "Female_" + randomIndex.ToString("D2");
            animator.Play(clipName);
        }
    }
}