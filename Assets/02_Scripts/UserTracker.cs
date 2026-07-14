using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using UnityEngine;
using UnityEngine.Networking;

[Serializable]
public class ServerFeedbackData { public EvcData evc; public DetailScores detail_scores; }
[Serializable]
public class EvcData { public int E; public int V; public int C; }
[Serializable]
public class DetailScores { public int content; public int speed; public int eye_contact; }

public class UserTracker : MonoBehaviour
{
    public string apiURL = "http://192.168.219.102:5000/api/interview/stream";
    public Transform vrCamera;          
    public LayerMask centerWallLayer;   
    private bool isTracking = false;
    private int sampleRate = 16000;      

    // 💡 누락되었던 리스트들 복구
    public static List<int> accumulatedE = new List<int>();
    public static List<int> accumulatedV = new List<int>();
    public static List<int> accumulatedC = new List<int>();
    public static List<int> accumulatedEye = new List<int>();

    public void StartTracking()
    {
        if (Microphone.devices.Length > 0)
        {
            isTracking = true;
            StartCoroutine(TrackingLoop());
        }
    }

    // 💡 누락되었던 StopTracking 복구
    public void StopTracking()
    {
        isTracking = false;
        Microphone.End(null);
    }

    // 💡 누락되었던 ClearAccumulatedData 복구
    public static void ClearAccumulatedData()
    {
        accumulatedE.Clear(); accumulatedV.Clear(); accumulatedC.Clear(); accumulatedEye.Clear();
    }

    private IEnumerator TrackingLoop()
    {
        while (isTracking)
        {
            AudioClip micClip = Microphone.Start(null, false, 5, sampleRate);
            float eyeContactRate = CalculateEyeContactFor5Seconds(); 
            yield return new WaitForSeconds(5f);
            Microphone.End(null);

            // ⚠️ 에러 해결: SavWav.SaveToBytes 대신 직접 변환
            byte[] audioData = SavWav.GetAudioData(micClip); 

            WWWForm form = new WWWForm();
            form.AddBinaryData("audio", audioData, "voice.wav", "audio/wav");
            form.AddField("eye_contact", eyeContactRate.ToString());


            Debug.Log("서버로 데이터를 보냅니다: " + apiURL);

            using (UnityWebRequest www = UnityWebRequest.Post(apiURL, form))
            {
                yield return www.SendWebRequest();
                if (www.result == UnityWebRequest.Result.Success) ProcessServerFeedback(www.downloadHandler.text);
            }
        }
    }

    private float CalculateEyeContactFor5Seconds() { return 0.8f; }

    private void ProcessServerFeedback(string jsonString)
    {
        ServerFeedbackData feedback = JsonUtility.FromJson<ServerFeedbackData>(jsonString);
        if (feedback != null)
        {
            accumulatedE.Add(feedback.evc.E);
            accumulatedV.Add(feedback.evc.V); // 💡 복구
            accumulatedC.Add(feedback.evc.C); // 💡 복구
            accumulatedEye.Add(feedback.detail_scores.eye_contact); // 💡 복구

//             AudienceManager am = FindObjectOfType<AudienceManager>();

//         if (am != null)
//         {
//             // 이전에는 "Bored"나 "Clap"을 썼지만, 이제는 44개 파일명 중 하나를 호출해야 합니다.
//             // 예를 들어, E값이 낮으면 Bored 관련 클립, 높으면 Clap 관련 클립을 호출하도록 수정하세요.
//             string clipId = feedback.evc.E < 50 ? "EM_07_disengaged_negative_F" : "EM_01_approving_smile_F";
//             am.PlayAnimation(clipId);
// }
        }
    }
}