using UnityEngine;
using System.Text;
using System.Collections.Concurrent;

public class TranscriptBuffer : MonoBehaviour
{
    [SerializeField] SpeechRecognizer stt;

    readonly StringBuilder sb = new();
    readonly ConcurrentQueue<(string txt, bool fin)> q = new();

    float  lastSpeechTime;
    bool   gotFinal;

    /* ★ 람다 참조를 보관할 필드 */
    System.Action<string,bool> _handler;

    void OnEnable()
    {
        if (!stt) stt = GetComponent<SpeechRecognizer>();

        /* 람다를 변수에 저장한 뒤 동일 참조로 += */
        _handler = (txt, fin) => q.Enqueue((txt, fin));
        stt.OnText += _handler;
    }

    void OnDisable()
    {
        if (stt && _handler != null)
            stt.OnText -= _handler;   // 같은 참조로 -=
    }

    void Update()
    {
        while (q.TryDequeue(out var item))
        {
            sb.Append(item.txt).Append(' ');
            lastSpeechTime = Time.time;
            if (item.fin) gotFinal = true;
        }
    }

    /* ----------  QAController API ---------- */

    public void Clear()
    {
        sb.Clear(); q.Clear();
        gotFinal = false;
        lastSpeechTime = Time.time;
    }

    public bool IsAnswerFinished(float silenceSec = 1.5f) =>
        gotFinal && Time.time - lastSpeechTime > silenceSec;

    public string Consume()
    {
        string all = sb.ToString();
        Clear();
        return all.Trim();
    }
}