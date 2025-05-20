
using UnityEngine;
using System.Text;
using System.IO;
using System;
using System.Collections.Generic;
using System.Linq;

public class LogRecorder : MonoBehaviour
{
    public static LogRecorder I { get; private set; }

    [Header("Sampling (Hz)")]
    [SerializeField] int gazeHz  = 30;
    [SerializeField] int poseHz  = 30;
    [SerializeField] int audioHz = 10;

    [Header("Meta")]
    [Tooltip("실험 조건 ID (0 = No-FB, 1 = SR, 2 = SC)")]
    public int conditionId = 0;
    [Tooltip("세션·참가자 식별자")]
    public string participant = "P01";

    /* ───────── 내부 버퍼 ───────── */
    readonly StringBuilder beh  = new();
    readonly StringBuilder aud  = new();
    readonly StringBuilder gaze = new();
    readonly StringBuilder pose = new();

    float gNext, pNext, aNext;

    /*  WPM 계산용: 최근 10초간 word 수를 큐로 누적 */
    readonly Queue<(float t,int wc)> wordBuf = new();
    int  lastTotalWords;
    float wpmWindow = 10f;                // 10 초 창

    /*  AudioListener 버퍼 */
    readonly float[] rmsBuf = new float[1024];

    /* ────────── 초기화 ────────── */
    void Awake()
    {
        if (I) { Destroy(gameObject); return; }
        I = this; DontDestroyOnLoad(gameObject);

        beh .AppendLine("t,cond,tag,note");
        aud .AppendLine("t,cond,avgDb,wpm,text");
        gaze.AppendLine("t,cond,hitObj,x,y,z");
        pose.AppendLine("t,cond,pos.x,pos.y,pos.z,rot.x,rot.y,rot.z");
    }

    /* ───────── Behavior 이벤트 ───────── */
    public void LogEvent(string tag, string note = "")
    {
        beh.AppendFormat("{0:F3},{1},{2},{3}\n",
            Time.realtimeSinceStartup, conditionId, tag, note);
    }

    /* ───────── STT 콜백으로 단어 누적 ───────── */
    public void OnSTTResult(string text, bool final)
    {
        if (!final || string.IsNullOrWhiteSpace(text)) return;
        int words = text.Split(new[] { ' ','\n','\t' }, StringSplitOptions.RemoveEmptyEntries).Length;
        wordBuf.Enqueue((Time.realtimeSinceStartup, words));
        lastTotalWords += words;
    }

    /* ───────── Mic + WPM 샘플 ───────── */
    void SampleAudio(float t)
    {
        // RMS → dB
        AudioListener.GetOutputData(rmsBuf, 0);
        float rms = 0f;
        foreach (var s in rmsBuf) rms += s * s;
        rms = Mathf.Sqrt(rms / rmsBuf.Length);
        float dB = 20f * Mathf.Log10(rms + 1e-6f);

        // WPM: 최근 10 s 창 내 word 총합 × 6
        while (wordBuf.Count > 0 && (t - wordBuf.Peek().t) > wpmWindow)
        {
            lastTotalWords -= wordBuf.Dequeue().wc;
        }
        float wpm = lastTotalWords * 6f;

        aud.AppendFormat("{0:F3},{1},{2:F1},{3:F1},\n",
            t, conditionId, dB, wpm);
    }

    /* ───────── 매 프레임 ───────── */
    void Update()
    {
        float t = Time.realtimeSinceStartup;

        /* Gaze */
        if (t >= gNext)
        {
            gNext = t + 1f / gazeHz;
            var cam = Camera.main;
            if (cam)
            {
                var ray = new Ray(cam.transform.position, cam.transform.forward);
                if (Physics.Raycast(ray, out RaycastHit hit, 10f))
                {
                    Vector3 p = hit.point;
                    gaze.AppendFormat("{0:F3},{1},{2},{3:F2},{4:F2},{5:F2}\n",
                        t, conditionId, hit.collider.name, p.x, p.y, p.z);
                }
                else
                {
                    gaze.AppendFormat("{0:F3},{1},None,0,0,0\n", t, conditionId);
                }
            }
        }

        /* Posture */
        if (t >= pNext)
        {
            pNext = t + 1f / poseHz;
            var cam = Camera.main;
            if (cam)
            {
                Vector3 pos = cam.transform.position;
                Vector3 rot = cam.transform.eulerAngles;
                pose.AppendFormat("{0:F3},{1},{2:F3},{3:F3},{4:F3},{5:F1},{6:F1},{7:F1}\n",
                    t, conditionId, pos.x, pos.y, pos.z, rot.x, rot.y, rot.z);
            }
        }

        /* Audio */
        if (t >= aNext)
        {
            aNext = t + 1f / audioHz;
            SampleAudio(t);
        }
    }

    /* ───────── 파일 저장 ───────── */
    bool saved;

    public void SaveToFile()
    {
        if (saved) return; saved = true;

#if UNITY_EDITOR
        string root = Path.Combine(Application.dataPath, "StreamingAssets", "Logs");
#else
        string root = Path.Combine(Application.persistentDataPath, "Logs");
#endif
        root = Path.Combine(root, DateTime.UtcNow.ToString("yyyyMMdd"));
        Directory.CreateDirectory(root);

        string baseName = $"{participant}_{DateTime.UtcNow:HHmmss}";

        File.WriteAllText(Path.Combine(root, $"{baseName}_beh.csv"),  beh .ToString(), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, $"{baseName}_aud.csv"),  aud .ToString(), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, $"{baseName}_gaze.csv"), gaze.ToString(), Encoding.UTF8);
        File.WriteAllText(Path.Combine(root, $"{baseName}_pose.csv"), pose.ToString(), Encoding.UTF8);

        Debug.Log($"[LogRecorder] saved → {root}");
    }

    void OnApplicationQuit()  => SaveToFile();
    void OnDestroy()          => SaveToFile();
}
