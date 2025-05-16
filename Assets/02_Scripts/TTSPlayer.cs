using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using System.IO;

 public class TTSPlayer : MonoBehaviour
{
       [Header("Azure Speech TTS")]
    [SerializeField] string speechKey = "";
    [SerializeField] string region    = "koreacentral";
    [SerializeField] string voice     = "ko-KR-SunHiNeural";

    [Header("Audio & LipSync")]
    [SerializeField] public AudioSource       source;      // 48 kHz, Mono
    [SerializeField] OVRLipSyncContext lipSync;

    string ttsUrl;

    void Awake()
    {
        SpeechConfigLoader.Load(out speechKey, out region);
        ttsUrl = $"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1";
        if (lipSync && !lipSync.audioSource) lipSync.audioSource = source;
    }

    /* ---------- 여기부터 완전히 교체 ---------- */
    public IEnumerator Speak(string text,
                             float speechRate = 1.0f,
                             Action<bool> onComplete = null)
    {
        /* ➊ TTS 호출 → wavBytes */
        byte[] wavBytes = null;
        yield return StartCoroutine(GetTtsData(text, speechRate, b => wavBytes = b));

        if (wavBytes == null) { onComplete?.Invoke(false); yield break; }

        /* ➋ 임시 wav 파일로 저장 */
        string wavPath = Path.Combine(Application.temporaryCachePath,
                                      $"tts_{Guid.NewGuid()}.wav");
        File.WriteAllBytes(wavPath, wavBytes);
        Debug.Log($"[TTS] saved → {wavPath}");

        /* ➌ Unity 내장 디코더로 AudioClip 로드 */
        using (UnityWebRequest req =
               UnityWebRequestMultimedia.GetAudioClip("file://" + wavPath,
                                                       AudioType.WAV))
        {
            yield return req.SendWebRequest();

            if (req.result != UnityWebRequest.Result.Success)
            {
                Debug.LogWarning($"[TTS] decode err {req.error}");
                onComplete?.Invoke(false);
                yield break;
            }

            AudioClip clip = DownloadHandlerAudioClip.GetContent(req);

            /* ➍ 재생 */
            source.clip = clip;
            source.Play();
            Debug.Log($"[TTS] clip len={clip.length:F2}s");

            yield return new WaitForSeconds(clip.length);
            onComplete?.Invoke(true);

            /* ➎ 정리 */
            Destroy(clip);
            File.Delete(wavPath);     // 임시 파일 삭제
        }
    }

    private IEnumerator GetTtsData(string text, float rate,
        Action<byte[]> onDone)
    {
        string ssml =
            $@"<speak version=""1.0"" xml:lang=""ko-KR"">
  <voice name=""{voice}"">
    <prosody rate=""{rate * 100:F0}%"" pitch=""0%"">{text}</prosody>
  </voice>
</speak>";

        using UnityWebRequest req =
            new UnityWebRequest(ttsUrl, UnityWebRequest.kHttpVerbPOST);
        byte[] body = Encoding.UTF8.GetBytes(ssml);

        req.uploadHandler = new UploadHandlerRaw(body);
        req.downloadHandler = new DownloadHandlerBuffer();
        req.SetRequestHeader("Content-Type", "application/ssml+xml");
        req.SetRequestHeader("X-Microsoft-OutputFormat",
            "riff-48khz-16bit-mono-pcm");
        req.SetRequestHeader("Ocp-Apim-Subscription-Key", speechKey);
        req.timeout = 15;

        yield return req.SendWebRequest();

        if (req.result != UnityWebRequest.Result.Success)
        {
            Debug.LogWarning($"[TTS] {req.responseCode} {req.error}");
            onDone(null);
            yield break;
        }

        onDone(req.downloadHandler.data);
    }
    

}
