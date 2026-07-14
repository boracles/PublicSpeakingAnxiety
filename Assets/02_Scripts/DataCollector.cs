using UnityEngine;
using UnityEngine.Networking;
using System.Collections;
using System.Collections.Generic;

public class DataCollector : MonoBehaviour
{
    private string apiURL = "http://192.168.219.102:5000/api/interview/stream"; // 실제 서버 주소로 변경
    private int sampleRate = 44100;

    void Start()
    {
        StartCoroutine(TrackingLoop());
    }

    private IEnumerator TrackingLoop()
    {
        while (true)
        {
            // 1. 5초 녹음 시작
            AudioClip micClip = Microphone.Start(null, false, 5, sampleRate);
            yield return new WaitForSeconds(5.1f); // 녹음 시간 대기
            Microphone.End(null);

            // 2. 오디오 데이터 변환 및 전송 데이터 구성
            byte[] audioData = SavWav.GetAudioData(micClip); 
            WWWForm form = new WWWForm();
            form.AddBinaryData("audio", audioData, "voice.wav", "audio/wav");
            
            // 3. 현재 상황 데이터 추가 (예: 슬라이드 번호 등)
            form.AddField("slide_id", "current_slide_number"); 

            // 4. 서버 전송
            using (UnityWebRequest www = UnityWebRequest.Post(apiURL, form))
            {
                www.timeout = 30; // 타임아웃 30초 설정[cite: 1]
                yield return www.SendWebRequest();

                if (www.result == UnityWebRequest.Result.Success)
                {
                    string jsonResponse = www.downloadHandler.text;
                    // 서버로부터 받은 클립 ID 리스트를 AudienceManager로 전달
                    FindObjectOfType<AudienceManager>().ProcessServerFeedback(jsonResponse);
                }
                else
                {
                    Debug.LogError("서버 연결 실패: " + www.error);
                }
            }
        }
    }
}