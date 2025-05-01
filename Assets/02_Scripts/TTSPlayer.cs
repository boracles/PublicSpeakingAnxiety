﻿// ───────────────────────────────────────────────
//  TTSPlayer.cs
//  • Azure Speech TTS REST 호출  → wav → AudioSource
//  • OVRLipSyncContext로 viseme 스트림 재생
// ───────────────────────────────────────────────
using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;

 public class TTSPlayer : MonoBehaviour
{
    [Header("Azure Speech TTS")]
    [SerializeField] string speechKey = "";
    [SerializeField] string region    = "koreacentral";
    [SerializeField] string voice     = "ko-KR-InJoonNeural"; // 한국어 남성

    [Header("Audio & LipSync")]
    [SerializeField] AudioSource       source;   // 48 kHz, Mono
    [SerializeField] OVRLipSyncContext lipSync;

    const int SAMPLE_RATE = 48000;      // LipSync 권장

    /* ────────── 외부 호출용 코루틴 ───────────── */
    public IEnumerator Speak(string text, float speechRate     = 1.0f, Action onComplete    = null)
    {
        byte[] wavBytes = null;
        yield return StartCoroutine(GetTTSData(text, speechRate, bytes => wavBytes = bytes));
        if (wavBytes == null) yield break;

        // 2) WAV → AudioClip
        AudioClip clip = WavUtility.ToAudioClip(wavBytes, "TTS", out _);

        // 3) 재생 + LipSync
        source.clip = clip;
        source.Play();

        yield return new WaitForSeconds(clip.length);
        onComplete?.Invoke();
    }

    IEnumerator GetTTSData(string text, float rate, Action<byte[]> onDone)
    {
        string ssml =
            $@"<speak version=""1.0"" xml:lang=""ko-KR"">
   <voice name=""{voice}"">
     <prosody rate=""{rate * 100:F0}%"" pitch=""0%"">{text}</prosody>
   </voice>
 </speak>";

        string url = $"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1";
        using var req = new UnityWebRequest(url, "POST");
        byte[] body = Encoding.UTF8.GetBytes(ssml);
        req.uploadHandler   = new UploadHandlerRaw(body);
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/ssml+xml");
        req.SetRequestHeader("X-Microsoft-OutputFormat", "riff-48khz-16bit-mono-pcm");
        req.SetRequestHeader("Ocp-Apim-Subscription-Key", speechKey);
        req.timeout = 15;

        yield return req.SendWebRequest();

        if (req.result != UnityWebRequest.Result.Success)
        {
            Debug.LogWarning($"TTS error: {req.error}");
            onDone(null);                // ← 여기
            yield break;
        }
        onDone(req.downloadHandler.data); // ← 여기
    }

}
