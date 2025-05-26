/*
 * LogRecorder 3.0  (2025-05-21)
 * ------------------------------------------------------------
 * • BeginLogging(pid)   : 참가자 ID 지정 + 파일 열기
 * • conditionId         : 0=NF, 1=SR, 2=SC (조건 루프마다 갱신)
 * • Q_START / A_START   : QAController 호출 → Δt 계산용
 * • 모든 조건을 하나의 CSV 세트에 누적 기록
 */

using UnityEngine;
using System;
using System.IO;
using System.Collections.Generic;

public class LogRecorder : MonoBehaviour
{
    public static LogRecorder I { get; private set; }

    /* ---------- 인스펙터 ---------- */
    [Header("Sampling (Hz)")]
    [SerializeField] int gazeHz  = 30;
    [SerializeField] int poseHz  = 30;
    [SerializeField] int audioHz = 10;

    [Header("Meta")]
    [Tooltip("실험 조건 ID (0 = NF, 1 = SR, 2 = SC)")]
    public int conditionId = 0;

    [Header("Flush Interval (sec)")]
    [SerializeField] float flushInterval = 30f;

    /* ---------- 내부 상태 ---------- */
    float gNext, pNext, aNext, flushNext;

    readonly Queue<(float t,int wc)> wordBuf = new();
    int   lastTotalWords;
    const float WPM_WINDOW = 10f;
    readonly float[] rmsBuf = new float[1024];

    /* ---------- 파일 핸들 ---------- */
    StreamWriter behW, audW, gazeW, poseW;
    bool writersReady;
    public string participant = "UNSET";

    /* ---------- Awake ---------- */
    void Awake()
    {
        if (I) { Destroy(gameObject); return; }
        I = this;
        DontDestroyOnLoad(gameObject);
        // 파일은 BeginLogging() 호출 때 열림
    }

    /* =========================================================
     *  외부 공개 API
     * =======================================================*/

    /// <summary>참가자 ID를 지정하고 최초로 파일을 연다 (한 세션당 1회 호출)</summary>
    public void BeginLogging(string participantId)
    {
        if (writersReady) return;          // 이미 열렸으면 무시
        participant = participantId;
        OpenWriters();
        LogEvent("SessionStart");
    }

    public void LogQuestionStart(string qid)  => LogEvent("Q_START", qid);
    public void LogAnswerStart(string qid)    => LogEvent("A_START", qid);
    public void LogAvatarGesture(string st)   => LogEvent("AV_GESTURE", st);

    public void LogEvent(string tag, string note = "")
    {
        if (!writersReady) return;
        behW.WriteLine($"{Time.realtimeSinceStartup:F3},{conditionId},{tag},{note}");
    }

    public void CloseAll()        // 세션 종료 시 호출
    {
        if (!writersReady) return;
        LogEvent("SessionEnd");
        FlushAll();
        behW?.Close(); audW?.Close(); gazeW?.Close(); poseW?.Close();
        writersReady = false;
        Debug.Log("[LogRecorder] files saved & closed.");
    }

    /* =========================================================
     *  파일 열기 / 플러시
     * =======================================================*/
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
        behW  = File.CreateText(Path.Combine(root, $"{baseName}_beh.csv"));
        audW  = File.CreateText(Path.Combine(root, $"{baseName}_aud.csv"));
        gazeW = File.CreateText(Path.Combine(root, $"{baseName}_gaze.csv"));
        poseW = File.CreateText(Path.Combine(root, $"{baseName}_pose.csv"));

        behW .WriteLine("t,cond,tag,note");
        audW .WriteLine("t,cond,avgDb,wpm,text");
        gazeW.WriteLine("t,cond,hitObj,x,y,z");
        poseW.WriteLine("t,cond,pos.x,pos.y,pos.z,rot.x,rot.y,rot.z,rot.w");

        writersReady = true;
        flushNext = Time.realtimeSinceStartup + flushInterval;
    }

    void FlushAll()
    {
        behW?.Flush(); audW?.Flush(); gazeW?.Flush(); poseW?.Flush();
    }

    /* =========================================================
     *  STT 콜백 (WPM + 텍스트)
     * =======================================================*/
    public void OnSTTResult(string text, bool final)
    {
        if (!final || string.IsNullOrWhiteSpace(text) || !writersReady) return;

        int words = text.Split(new[] { ' ', '\n', '\t' }, StringSplitOptions.RemoveEmptyEntries).Length;
        wordBuf.Enqueue((Time.realtimeSinceStartup, words));
        lastTotalWords += words;

        string safe = text.Replace(',', ';');
        audW.WriteLine($"{Time.realtimeSinceStartup:F3},{conditionId},,,{safe}");
    }

    /* =========================================================
     *  오디오 샘플
     * =======================================================*/
    void SampleAudio(float t)
    {
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

        while (wordBuf.Count > 0 && (t - wordBuf.Peek().t) > WPM_WINDOW)
            lastTotalWords -= wordBuf.Dequeue().wc;

        float wpm = lastTotalWords * 6f;
        audW.WriteLine($"{t:F3},{conditionId},{dB:F1},{wpm:F1},");
    }

    // LogRecorder.cs
// ─────────────────────────────────────────────────────────────
    public void LogSurveyAnswer(int qIndex, string qText, string answer)
    {
        if (!writersReady) return;

        // 문장 안에 쉼표가 있으면 세미콜론으로 치환
        qText   = qText.Replace(',', ';');
        answer  = answer.Replace(',', ';');

        behW.WriteLine(
            $"{Time.realtimeSinceStartup:F3}," +
            $"{conditionId}," +
            $"SURVEY_Q{qIndex}," +           // 태그
            $"{qText}|{answer}");            // note 칸 : 질문|응답
    }

    void Update()
    {
        if (!writersReady) return;
        float t = Time.realtimeSinceStartup;

        /* gaze */
        while (t >= gNext)
        {
            gNext += 1f / gazeHz;
            var cam = Camera.main; if (!cam) break;
            Ray ray = new Ray(cam.transform.position, cam.transform.forward);
            if (Physics.Raycast(ray, out RaycastHit hit, 10f))
            {
                Vector3 p = hit.point;
                gazeW.WriteLine($"{t:F3},{conditionId},{hit.collider.name},{p.x:F2},{p.y:F2},{p.z:F2}");
            }
            else gazeW.WriteLine($"{t:F3},{conditionId},None,0,0,0");
        }

        /* pose */
        while (t >= pNext)
        {
            pNext += 1f / poseHz;
            var cam = Camera.main; if (!cam) break;
            Vector3 pos = cam.transform.position;
            Quaternion rot = cam.transform.rotation;
            poseW.WriteLine($"{t:F3},{conditionId},{pos.x:F3},{pos.y:F3},{pos.z:F3},{rot.x:F4},{rot.y:F4},{rot.z:F4},{rot.w:F4}");
        }

        /* audio */
        while (t >= aNext)
        {
            aNext += 1f / audioHz;
            SampleAudio(t);
        }

        /* flush */
        if (t >= flushNext)
        {
            FlushAll();
            flushNext = t + flushInterval;
        }
    }

    /* =========================================================*/
    void OnApplicationQuit() => CloseAll();
    void OnDestroy()         => CloseAll();
}
