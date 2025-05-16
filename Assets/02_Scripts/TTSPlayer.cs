using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using System.IO;

public class TTSPlayer : MonoBehaviour
{
    /* ───── Azure Speech TTS 설정 ───── */
    [Header("Azure Speech TTS")]
    [SerializeField] string speechKey = "";
    [SerializeField] string region    = "koreacentral";
    [SerializeField] string voice     = "ko-KR-SunHiNeural";

    /* ───── Audio / Lip-Sync ───── */
    [Header("Audio & LipSync")]
    [SerializeField] public AudioSource      source;   // 48 kHz Mono
    [SerializeField] OVRLipSyncContext lipSync;

    [Range(0.4f, 1.0f)]
    public float defaultRate = 0.6f; 

    string ttsUrl;

    void Awake()
    {
        SpeechConfigLoader.Load(out speechKey, out region);
        ttsUrl = $"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1";
        if (lipSync && !lipSync.audioSource) lipSync.audioSource = source;
    }

    /* ───── TTS 재생 코루틴 ───── */
    public IEnumerator Speak(string text, float speechRate = -1f,
                             Action<bool> onComplete = null)
    {
        if (speechRate < 0) speechRate = defaultRate;
        speechRate = Mathf.Clamp(speechRate, 0.4f, 1.2f);

        /* ① TTS 호출 */
        byte[] wavBytes = null;
        yield return StartCoroutine(GetTtsData(text, speechRate, b => wavBytes = b));
        if (wavBytes == null) { onComplete?.Invoke(false); yield break; }

        /* ② 임시 WAV 저장 */
        string wavPath = Path.Combine(Application.temporaryCachePath,
                                      $"tts_{Guid.NewGuid()}.wav");
        File.WriteAllBytes(wavPath, wavBytes);

        /* ③ Unity 디코딩 */
        using (UnityWebRequest req =
               UnityWebRequestMultimedia.GetAudioClip("file://" + wavPath, AudioType.WAV))
        {
            yield return req.SendWebRequest();
            if (req.result != UnityWebRequest.Result.Success)
            {
                Debug.LogWarning(req.error);
                onComplete?.Invoke(false);
                yield break;
            }

            AudioClip clip = DownloadHandlerAudioClip.GetContent(req);

            /* ④ 재생 */
            source.clip = clip;
            source.Play();
            while (source.isPlaying) yield return null;

            /* ⑤ 정리 */
            onComplete?.Invoke(true);
            Destroy(clip);
            File.Delete(wavPath);
        }
    }

    /* ───── Azure TTS REST 호출 ───── */
    IEnumerator GetTtsData(string text, float rate, Action<byte[]> onDone)
    {
        int pct    = Mathf.RoundToInt((rate - 1f) * 100);   // 0.6 → –40
        string sign = pct > 0 ? "+" : "";                   // +10 / -40
        string prosodyRate = $"{sign}{pct}%";               // “-40%”

        string ssml = $@"<speak version=""1.0"" xml:lang=""ko-KR"">
  <voice name=""{voice}"">
    <prosody rate=""{prosodyRate}"" pitch=""0%"">{text}</prosody>
  </voice>
</speak>";

        using (UnityWebRequest req = new UnityWebRequest(ttsUrl, "POST"))
        {
            byte[] body = Encoding.UTF8.GetBytes(ssml);
            req.uploadHandler   = new UploadHandlerRaw(body);
            req.downloadHandler = new DownloadHandlerBuffer();
            req.SetRequestHeader("Content-Type", "application/ssml+xml");
            req.SetRequestHeader("X-Microsoft-OutputFormat",
                                 "riff-48khz-16bit-mono-pcm");
            req.SetRequestHeader("Ocp-Apim-Subscription-Key", speechKey);
            req.timeout = 15;

            yield return req.SendWebRequest();

            if (req.result != UnityWebRequest.Result.Success)
            {
                Debug.LogWarning($"[TTS] {req.responseCode}  {req.error}");
                onDone(null);
            }
            else
            {
                onDone(req.downloadHandler.data);
            }
        }
    }

    /* 홀수 바이트 패딩 보정 */
    static int Align2(int n) => (n & 1) == 1 ? n + 1 : n;
}
