using UnityEngine;

public class TranscriptBuffer : MonoBehaviour
{
    [SerializeField] SpeechRecognizer stt;
    readonly System.Text.StringBuilder sb = new();

    void OnEnable()  => stt.OnText += OnSentence;
    void OnDisable() => stt.OnText -= OnSentence;

    void OnSentence(string txt, bool final)
    {
        if (final) sb.AppendLine(txt);
    }
    public string GetLastNChars(int n=2000)
        => sb.Length<=n ? sb.ToString() : sb.ToString(sb.Length-n, n);
}

