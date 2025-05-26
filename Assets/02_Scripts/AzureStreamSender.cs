using UnityEngine;
using System;
using System.Diagnostics;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
using System.Threading.Tasks; 

/// <summary>
/// PushAudioInputStream → Azure Speech 연속 인식 송신기
/// </summary>
public class AzureStreamSender : IDisposable
{
    const int BYTES_PER_SAMPLE = 2;
    
    PushAudioInputStream  push;
    Microsoft.CognitiveServices.Speech.SpeechRecognizer rec;
    readonly Stopwatch    sw = new();      // latency 측정용

    public event Action<string, float, bool> OnResult;   // text, latency, isFinal

    public void Begin(string key, string region, uint sampleRate = 16000)
    {
        var cfg = SpeechConfig.FromSubscription(key, region);
        cfg.SpeechRecognitionLanguage = "ko-KR";

        var fmt  = AudioStreamFormat.GetWaveFormatPCM(sampleRate, 16, 1);
        push     = AudioInputStream.CreatePushStream(fmt);
        var acfg = AudioConfig.FromStreamInput(push);

        // ② 생성도 풀네임 그대로
        rec = new Microsoft.CognitiveServices.Speech.SpeechRecognizer(cfg, acfg);

        rec.Recognizing += (_, e) =>
            OnResult?.Invoke(e.Result.Text, (float)sw.Elapsed.TotalSeconds, false);
        rec.Recognized  += (_, e) =>
            OnResult?.Invoke(e.Result.Text, (float)sw.Elapsed.TotalSeconds, true);

        sw.Restart();
        _ = rec.StartContinuousRecognitionAsync();
    }

    public void Send(float[] block)
    {
        int len = block.Length * BYTES_PER_SAMPLE;
        byte[] buf = new byte[len];

        for (int i = 0; i < block.Length; i++)
        {
            short s = (short)(Mathf.Clamp(block[i], -1f, 1f) * short.MaxValue);
            buf[i * 2]     = (byte)(s & 0xFF);
            buf[i * 2 + 1] = (byte)((s >> 8) & 0xFF);
        }
        push.Write(buf);
    }
    
    /* ─ 안전 종료 (async) ─ */
    public async Task EndAsync()
    {
        if (rec == null) return;

        await rec.StopContinuousRecognitionAsync();
        rec.Dispose();
        push?.Close();
    }

    /* IDispose 구현 (EndAsync가 실제 정리) */
    public void Dispose() { /* nothing */ }
}