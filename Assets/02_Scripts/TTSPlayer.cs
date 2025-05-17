using System;
using System.Text;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using System.IO;
using System.Collections.Generic;

public class TTSPlayer : MonoBehaviour
{
    /* ───── Azure Speech TTS 설정 ───── */
    [Header("Azure Speech TTS")]
    [SerializeField] string speechKey = "";
    [SerializeField] string region    = "koreacentral";
    [SerializeField] string voice     = "ko-KR-SunHiNeural";

    /* ───── Audio / Lip-Sync ───── */
    [Header("Audio & LipSync")]
    [SerializeField] AudioSource outputSource;    // VoiceOut
    [SerializeField] AudioSource analysisSource;  // Head (mute)
    [SerializeField] OVRLipSyncContext lipSync;

    [Range(0.4f, 1.0f)]
    public float defaultRate = 0.6f; 

    string ttsUrl;

    Dictionary<string, AudioClip> cache = new();  
    
    void Awake()
    {
        SpeechConfigLoader.Load(out speechKey, out region);
        ttsUrl = $"https://{region}.tts.speech.microsoft.com/cognitiveservices/v1";

        // ① 출력용(VoiceOut)
        if (!outputSource)
            outputSource = GameObject.Find("VoiceOut")  // 씬 전체에서 탐색
                ?.GetComponent<AudioSource>();

        // ② 분석용(Head) : lipSync 에 없으면 수동 탐색
        if (!analysisSource)
            analysisSource = lipSync ? lipSync.audioSource : null;

        if (!analysisSource)
            analysisSource = GameObject.Find("Head")    // Head 오브젝트 명시
                ?.GetComponent<AudioSource>();

        // ③ 두 소스가 같다면 복사본 하나 추가(안전장치)
        if (analysisSource == outputSource && analysisSource != null)
        {
            analysisSource = analysisSource.gameObject.AddComponent<AudioSource>();
            analysisSource.playOnAwake = false;
        }

        // ④ 분석용 소스 세팅 & LipSync 연결
        if (analysisSource)
        {
            analysisSource.mute           = false;
            analysisSource.spatialize     = false;   // ⭐ Spatializer 사용 안 함
            analysisSource.spatialBlend   = 0f;      // 2D

            if (lipSync) lipSync.audioSource = analysisSource;
        }
    }
    
    /* 미리 생성해 두고 바로 꺼내 쓰기 */
    public IEnumerator Preload(string text, float speechRate = -1f)
    {
        if (cache.ContainsKey(text)) yield break;

        yield return Speak(text,                // 기존
            speechRate,
            clip => cache[text] = clip,   // onReady: 캐시에 저장
            null);  
    }

    /* 캐시된 음성 즉시 재생 */
    public void PlayCached(string text, float volume = 1f)
    {
        if (cache.TryGetValue(text, out var clip))
        {
            if (outputSource)
                outputSource.PlayOneShot(clip, volume);
            
            if (analysisSource && analysisSource != outputSource)
                analysisSource.PlayOneShot(clip, volume);
        }
    }

    
    /* ───── TTS 재생 코루틴 ───── */
    public IEnumerator Speak(string text, float speechRate = -1f,Action<AudioClip> onReady = null, Action<bool> onComplete = null)  
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
            
            onReady?.Invoke(clip);
            
            if (outputSource)                    // ← 추가: null 보호
            {
                outputSource.clip = clip;
                outputSource.Play();
            }
            
            if (analysisSource)                  // ← 추가: null 보호
            {
                analysisSource.clip = clip;
                analysisSource.Play();

                lipSync?.ResetContext();         // 잔여 버퍼 클리어 (분석용 소스가 있을 때)
            }

            yield return null;
            Debug.Log($"CLIP   len={clip.length:F2}s  freq={clip.frequency}  ch={clip.channels}");

            if (outputSource)
                Debug.Log($"OUT mute={outputSource.mute} vol={outputSource.volume} play={outputSource.isPlaying}");

            if (analysisSource)
                Debug.Log($"ANA mute={analysisSource.mute} vol={analysisSource.volume} play={analysisSource.isPlaying}");

            
            while (outputSource && outputSource.isPlaying) yield return null;

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
