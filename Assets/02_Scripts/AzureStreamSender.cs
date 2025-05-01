using UnityEngine;
using System;
using System.Diagnostics;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
public class AzureStreamSender : IDisposable
{
    const int BYTES_PER_SAMPLE = 2;
    PushAudioInputStream push;
    Microsoft.CognitiveServices.Speech.SpeechRecognizer rec;   // ← 풀네임
    readonly Stopwatch  sw = new();

    public event Action<string,float,bool> OnResult;

    public void Begin(string key, string region, uint sampleRate = 16000)
    {
        var cfg = SpeechConfig.FromSubscription(key, region);
        cfg.SpeechRecognitionLanguage = "ko-KR";

        var format = AudioStreamFormat.GetWaveFormatPCM(sampleRate,
            (byte)16, (byte)1);
        push = AudioInputStream.CreatePushStream(format);
        var acfg = AudioConfig.FromStreamInput(push);

        rec = new Microsoft.CognitiveServices.Speech.SpeechRecognizer(cfg, acfg);

        rec.Recognizing += (_, e) =>
            OnResult?.Invoke(e.Result.Text, (float)sw.Elapsed.TotalSeconds, false);
        rec.Recognized += (_, e) =>
            OnResult?.Invoke(e.Result.Text, (float)sw.Elapsed.TotalSeconds, true);

        sw.Restart();
        _ = rec.StartContinuousRecognitionAsync();
    }

    public void Send(float[] block)
    {
        int len = block.Length * BYTES_PER_SAMPLE;
        var buf = new byte[len];

        for (int i = 0; i < block.Length; i++)
        {
            short s = (short)(Mathf.Clamp(block[i], -1f, 1f) * short.MaxValue);
            buf[i * 2]     = (byte)(s & 0xFF);
            buf[i * 2 + 1] = (byte)((s >> 8) & 0xFF);
        }
        push.Write(buf);                         // ← byte[] 오버로드
    }

    public void End()      => _ = rec.StopContinuousRecognitionAsync();
    public void Dispose()  { rec?.Dispose(); push?.Close(); }
}