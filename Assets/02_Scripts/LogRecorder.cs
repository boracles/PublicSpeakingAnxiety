using System.Linq; 
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

    class Stats {
        public List<float> lag = new();
        public int gazeHit, gazeTotal;
        public float dbSum, wpmSum, headVelSum;
        public int dbN,    wpmN,  headN;
    }
    readonly Dictionary<int, Stats> S = new();          // cond → Stats
    Stats Cur => S.TryGetValue(conditionId, out var s) ? s : S[conditionId] = new Stats();

// Q-START 시간 임시 저장
    readonly Dictionary<string, float> qTime = new();

    Quaternion prevRot;
    float lastDb, lastWpm; 
    void Awake()
    {
        if (I) { Destroy(gameObject); return; }
        I = this;
        DontDestroyOnLoad(gameObject);
        // 파일은 BeginLogging() 호출 때 열림
    }

    public void BeginLogging(string participantId)
    {
        if (writersReady) return;

        participant = participantId;
        OpenWriters();
        LogEvent("SessionStart");
        
        prevRot = Camera.main ?            // 헤드 각속도 첫 프레임용
            Camera.main.transform.rotation :
            Quaternion.identity;

        gNext = pNext = aNext =            // 샘플 타이머 리셋
            Time.realtimeSinceStartup;
    }

    public void LogQuestionStart(string qid)  => LogEvent("Q_START", qid);
    public void LogAnswerStart(string qid)    => LogEvent("A_START", qid);
    public void LogAvatarGesture(string st)   => LogEvent("AV_GESTURE", st);

    public void LogEvent(string tag, string note = "")
    {
        if (!writersReady) return;

        float t = Time.realtimeSinceStartup;
        behW.WriteLine($"{t:F3},{conditionId},{tag},{note}");

        // ───── Δt_resp 집계용 추가 로직 ─────
        if (tag == "Q_START")
        {
            // 질문 시작 시각 저장 (key = qid)
            qTime[note] = t;
        }
        else if (tag == "A_START" && qTime.Remove(note, out float qt))
        {
            // 대응하는 Q_START가 있으면 지연 계산 후 누적
            Cur.lag.Add(t - qt);   // Cur = S[conditionId]  (Stats 구조체)
        }
    }

    public void CloseAll()        // 세션 종료 시 호출
    {
        if (!writersReady) return;      // 아직 안 열렸으면 아무 것도 안 함

        WriteSummary();                 // ① 요약 CSV 먼저 저장
        LogEvent("SessionEnd");         // ② 세션 종료 태그 기록
        FlushAll();                     // ③ 버퍼 비우기
        behW?.Close(); audW?.Close(); gazeW?.Close(); poseW?.Close();
        writersReady = false;
        Debug.Log("[LogRecorder] files saved & closed.");
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
        
        lastDb  = dB;
        lastWpm = wpm;
    }

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
                /* ★ ① 집계 추가 */
                Cur.gazeTotal++;
                if (hit.collider.name.Contains("Avatar")) Cur.gazeHit++;

                Vector3 p = hit.point;
                gazeW.WriteLine($"{t:F3},{conditionId},{hit.collider.name},{p.x:F2},{p.y:F2},{p.z:F2}");
            }
            else
            {
                Cur.gazeTotal++;                    // ‘Avatar’ 아님
                gazeW.WriteLine($"{t:F3},{conditionId},None,0,0,0");
            }
        }

        /* pose */
        while (t >= pNext)
        {
            pNext += 1f / poseHz;
            var cam = Camera.main; if (!cam) break;

            Vector3 pos = cam.transform.position;
            Quaternion rot = cam.transform.rotation;

            /* ★ ② 집계 추가 */
            float ang = Quaternion.Angle(prevRot, rot) / Time.deltaTime;
            Cur.headVelSum += ang;  Cur.headN++;
            prevRot = rot;

            poseW.WriteLine($"{t:F3},{conditionId},{pos.x:F3},{pos.y:F3},{pos.z:F3},{rot.x:F4},{rot.y:F4},{rot.z:F4},{rot.w:F4}");
        }

        /* audio */
        while (t >= aNext)
        {
            aNext += 1f / audioHz;
            SampleAudio(t);   // ← 내부에서 dB·wpm 계산 후 CSV 작성

            /* ★ ③ 집계 추가 (SampleAudio 끝난 직후 바로) */
            Cur.dbSum  += lastDb;   Cur.dbN++;     // lastDb: SampleAudio 내부에서 public 필드로 저장
            Cur.wpmSum += lastWpm;  Cur.wpmN++;    // lastWpm: 마찬가지
        }

        /* flush */
        if (t >= flushNext)
        {
            FlushAll();
            flushNext = t + flushInterval;
        }
    }

    void WriteSummary()
    {
        /* ① 파일 경로 구성 + 폴더 생성 */
        string root = Path.Combine(Application.persistentDataPath, "Logs",
            DateTime.UtcNow.ToString("yyyyMMdd"));
        Directory.CreateDirectory(root);      // ← 폴더가 없으면 만들어 줌

        string baseName = $"{participant}_{DateTime.UtcNow:HHmmss}";
        string path     = Path.Combine(root, $"{baseName}_summary.csv");

        /* ② 요약 CSV 작성 */
        using var sw = File.CreateText(path);
        sw.WriteLine("cond,lag_m,lag_sd,n_lag,fix_pct,db_m,wpm_m,head_vel_m");

        foreach (var (cid, st) in S)
        {
            /* ── 기초 통계 ───────────────────────── */
            float mLag = st.lag.Any() ? st.lag.Average() : 0f;
            float sdLag = st.lag.Count > 1
                ? Mathf.Sqrt(st.lag.Select(x => (x - mLag) * (x - mLag)).Average())
                : 0f;
            float pct = st.gazeTotal > 0
                ? (float)st.gazeHit / st.gazeTotal * 100f
                : 0f;

            /* ── 0 분모 보호 ─────────────────────── */
            float dbM   = st.dbN   > 0 ? st.dbSum      / st.dbN   : 0f;
            float wpmM  = st.wpmN  > 0 ? st.wpmSum     / st.wpmN  : 0f;
            float headM = st.headN > 0 ? st.headVelSum / st.headN : 0f;

            /* ── 한 줄 출력 ─────────────────────── */
            sw.WriteLine(
                $"{cid},{mLag:F3},{sdLag:F3},{st.lag.Count}," +
                $"{pct:F1},{dbM:F1},{wpmM:F1},{headM:F2}");
        }
    }

    void OnApplicationQuit() => CloseAll();
    void OnDestroy()         => CloseAll();
}
