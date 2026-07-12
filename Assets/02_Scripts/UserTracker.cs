using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;

// 서버에서 5초마다 보내오는 JSON 구조 매핑 클래스
[Serializable]
public class ServerFeedbackData
{
    public EvcData evc;
    public DetailScores detail_scores;
}

[Serializable]
public class EvcData
{
    public int E; // 몰입도 관련 (예: Engagement/Eye contact)
    public int V; // 신뢰도 관련 (예: Voice/Volume)
    public int C; // 명확도 관련 (예: Content/Clarity)
}

[Serializable]
public class DetailScores
{
    public int content;
    public int speed;
    public int eye_contact;
}

public class UserTracker : MonoBehaviour
{
    [Header("서버 주소 (실전 연동용)")]
    public string apiURL = "https://jihoo-server.com/api/interview/stream";

    [Header("참조 오브젝트 설정")]
    public Transform vrCamera;          
    public LayerMask centerWallLayer;   

    private AudioClip micClip;
    private bool isTracking = false;
    private int sampleRate = 16000;      
    private string saveFolderPath;

    // 🌟 [핵심] 씬이 넘어가도 데이터가 유지되는 정적(static) 누적 리스트
    public static List<int> accumulatedE = new List<int>();
    public static List<int> accumulatedV = new List<int>();
    public static List<int> accumulatedC = new List<int>();
    public static List<int> accumulatedEye = new List<int>();

    void Start()
    {
        saveFolderPath = Path.Combine(Application.dataPath, "SavedAudio");
        if (!Directory.Exists(saveFolderPath))
        {
            Directory.CreateDirectory(saveFolderPath);
        }

        // 새 세션 시작 시 이전 데이터 초기화
        ClearAccumulatedData();
    }

    public static void ClearAccumulatedData()
    {
        accumulatedE.Clear();
        accumulatedV.Clear();
        accumulatedC.Clear();
        accumulatedEye.Clear();
    }

    public void StartTracking()
    {
        if (Microphone.devices.Length > 0)
        {
            isTracking = true;
            StartCoroutine(TrackingLoop());
        }
    }

    public void StopTracking()
    {
        isTracking = false; 
        Microphone.End(null);   
        StopAllCoroutines();    
    }

    private IEnumerator TrackingLoop()
    {
        int timeline = 0;

        while (isTracking)
        {
            micClip = Microphone.Start(null, false, 5, sampleRate);
            float hitCount = 0;
            float totalFrames = 0;
            float timer = 0;

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

            Microphone.End(null); 
            timeline += 5;        

            // [가상 가동] 원래는 서버 응답 바이트를 문자열로 파싱해야 합니다.
            // 여기서는 보내주신 이미지 양식의 가짜 응답 데이터 데이터를 파싱하는 시뮬레이션을 합니다.
            string mockResponseJson = "{ \"evc\": { \"E\": 78, \"V\": 71, \"C\": 85 }, \"detail_scores\": { \"content\": 82, \"speed\": 74, \"eye_contact\": 80 } }";
            
            ProcessServerFeedback(mockResponseJson);
        }
    }

    private void ProcessServerFeedback(string jsonString)
    {
        try
        {
            ServerFeedbackData feedback = JsonUtility.FromJson<ServerFeedbackData>(jsonString);
            if (feedback != null)
            {
                // 5초마다 리스트에 점수 데이터 축적
                accumulatedE.Add(feedback.evc.E);
                accumulatedV.Add(feedback.evc.V);
                accumulatedC.Add(feedback.evc.C);
                accumulatedEye.Add(feedback.detail_scores.eye_contact);

                //Debug.Log($"[데이터 누적] 현재 누적 횟수: {accumulatedE.Count}회");
            }
        }
        catch (Exception e)
        {
            Debug.LogError($"JSON 파싱 에러: {e.Message}");
        }
    }
}