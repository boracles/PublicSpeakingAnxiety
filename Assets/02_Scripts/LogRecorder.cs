
using UnityEngine;
using System.Text;
using System.IO;
using System;
using System.Collections.Generic;
using System.Linq;

public class LogRecorder : MonoBehaviour
{
    public static LogRecorder I { get; private set; }

    [Header("Sampling (Hz)")] [SerializeField]
    int gazeHz = 30;

    [SerializeField] int poseHz = 30;
    [SerializeField] int audioHz = 10;

    [Header("Meta")] [Tooltip("실험 조건 ID (0 = No-FB, 1 = SR, 2 = SC)")]
    public int conditionId = 0;

    [Tooltip("세션·참가자 식별자")] public string participant = "P01";

    [Header("Disk Flush (sec)")] [SerializeField]
    float flushInterval = 30f;

    // 내부 상태
    float gNext, pNext, aNext, flushNext;

    /*  WPM 계산용: 최근 10초간 word 수를 큐로 누적 */
    readonly Queue<(float t,int wc)> wordBuf = new();
    int   lastTotalWords;
    private const float WPM_WINDOW = 10f;

    readonly float[] rmsBuf = new float[1024];

    /* ────────── 파일 핸들 ────────── */
    StreamWriter behW, audW, gazeW, poseW;
    bool writersReady;

    void Awake()
    {
        if (I)
        {
            Destroy(gameObject);
            return;
        }

        I = this;
        DontDestroyOnLoad(gameObject);

        OpenWriters();
    }

    void OpenWriters()
    {
#if UNITY_EDITOR
        string root = Path.Combine(Application.dataPath, "StreamingAssets", "Logs");
#else
        string root = Path.Combine(Application.persistentDataPath, "Logs");
#endif
        root = Path.Combine(root, DateTime.UtcNow.ToString("yyyyMMdd"));
        Directory.CreateDirectory(root);

        string baseName = $"{participant}_{DateTime.UtcNow:HHmmss}";
        behW = File.CreateText(Path.Combine(root, $"{baseName}_beh.csv"));
        audW = File.CreateText(Path.Combine(root, $"{baseName}_aud.csv"));
        gazeW = File.CreateText(Path.Combine(root, $"{baseName}_gaze.csv"));
        poseW = File.CreateText(Path.Combine(root, $"{baseName}_pose.csv"));

        behW.WriteLine("t,cond,tag,note");
        audW.WriteLine("t,cond,avgDb,wpm,text");
        gazeW.WriteLine("t,cond,hitObj,x,y,z");
        poseW.WriteLine("t,cond,pos.x,pos.y,pos.z,rot.x,rot.y,rot.z,rot.w");

        writersReady = true;
        flushNext = Time.realtimeSinceStartup + flushInterval;
    }

    /*────────── 이벤트 태깅 API ─────────*/
    public void LogQuestionStart(string qid)
        => LogEvent("Q_START", qid);

    public void LogAnswerStart(string qid)
        => LogEvent("A_START", qid);

    public void LogAvatarGesture(string state)
        => LogEvent("AV_GESTURE", state);

    public void LogEvent(string tag, string note = "")
    {
        if (!writersReady) return;
        behW.WriteLine($"{Time.realtimeSinceStartup:F3},{conditionId},{tag},{note}");
    }

    /*────────── STT 콜백 ─────────*/
    public void OnSTTResult(string text, bool final)
    {
        if (!final || string.IsNullOrWhiteSpace(text) || !writersReady) return;

        /* WPM 누적 */
        int words = text.Split(new[] {' ', '\n', '\t'},
            StringSplitOptions.RemoveEmptyEntries).Length;
        wordBuf.Enqueue((Time.realtimeSinceStartup, words));
        lastTotalWords += words;

        /* 텍스트 로그 (쉼표는 세미콜론으로 치환) */
        string safeText = text.Replace(',', ';');
        audW.WriteLine($"{Time.realtimeSinceStartup:F3},{conditionId},,,{safeText}");
    }

    void SampleAudio(float t)
    {
        /* RMS (L/R 평균) */
        float rms0 = 0f, rms1 = 0f;
        AudioListener.GetOutputData(rmsBuf, 0);
        foreach (var s in rmsBuf) rms0 += s * s;
        rms0 = Mathf.Sqrt(rms0 / rmsBuf.Length);

        if (AudioSettings.speakerMode != AudioSpeakerMode.Mono)
        {
            AudioListener.GetOutputData(rmsBuf, 1);
            foreach (var s in rmsBuf) rms1 += s * s;
            rms1 = Mathf.Sqrt(rms1 / rmsBuf.Length);
        }
        float rms = (rms0 + rms1) * 0.5f;
        float dB  = 20f * Mathf.Log10(rms + 1e-6f);

        /* WPM (10 s 창) */
        while (wordBuf.Count > 0 && (t - wordBuf.Peek().t) > WPM_WINDOW)
            lastTotalWords -= wordBuf.Dequeue().wc;

        float wpm = lastTotalWords * 6f;
        audW.WriteLine($"{t:F3},{conditionId},{dB:F1},{wpm:F1},");
    }
    
    void Update()
    {
        if (!writersReady) return;
        float t = Time.realtimeSinceStartup;

        /* 시선 */
        while (t >= gNext)
        {
            gNext += 1f / gazeHz;
            var cam = Camera.main;
            if (!cam) break;

            Ray ray = new Ray(cam.transform.position, cam.transform.forward);
            if (Physics.Raycast(ray, out RaycastHit hit, 10f))
            {
                Vector3 p = hit.point;
                gazeW.WriteLine($"{t:F3},{conditionId},{hit.collider.name},{p.x:F2},{p.y:F2},{p.z:F2}");
            }
            else
            {
                gazeW.WriteLine($"{t:F3},{conditionId},None,0,0,0");
            }
        }

        /* 자세 */
        while (t >= pNext)
        {
            pNext += 1f / poseHz;
            var cam = Camera.main;
            if (!cam) break;

            Vector3 pos = cam.transform.position;
            Quaternion rot = cam.transform.rotation;
            poseW.WriteLine(
                $"{t:F3},{conditionId},{pos.x:F3},{pos.y:F3},{pos.z:F3},{rot.x:F4},{rot.y:F4},{rot.z:F4},{rot.w:F4}");
        }

        /* 오디오 */
        while (t >= aNext)
        {
            aNext += 1f / audioHz;
            SampleAudio(t);
        }

        /* 주기적 Flush */
        if (t >= flushNext)
        {
            FlushAll();
            flushNext = t + flushInterval;
        }
    }

    void FlushAll()
    {
        behW?.Flush();
        audW?.Flush();
        gazeW?.Flush();
        poseW?.Flush();
    }


    /* ───────── 파일 저장 ───────── */
    bool saved;

    public void ResetRecorder(int newCondId, string newParticipant)
    {
        FlushAll();
        behW?.Close();
        audW?.Close();
        gazeW?.Close();
        poseW?.Close();
        conditionId = newCondId;
        participant = newParticipant;
        lastTotalWords = 0;
        wordBuf.Clear();
        OpenWriters();
    }

    void OnApplicationQuit() => CloseAll();
    void OnDestroy() => CloseAll();

    public void CloseAll()
    {
        if (!writersReady) return;
        FlushAll();
        behW?.Close();
        audW?.Close();
        gazeW?.Close();
        poseW?.Close();
        writersReady = false;
        Debug.Log("[LogRecorder] files saved & closed.");
    }
}
