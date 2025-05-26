using UnityEngine;
using System;
using Microsoft.CognitiveServices.Speech;
using Microsoft.CognitiveServices.Speech.Audio;
using System.Threading.Tasks;

public class AzureStreamSender : IDisposable
{
    const int BYTES_PER_SAMPLE = 2;
    PushAudioInputStream push;
    Microsoft.CognitiveServices.Speech.SpeechRecognizer rec;
    readonly System.Diagnostics.Stopwatch sw = new();

    public event Action<string, float, bool> OnResult;   // text, latency, isFinal

    public void Begin(string key, string region, uint sampleRate = 16000)
    {
        var cfg = SpeechConfig.FromSubscription(key, region);
        cfg.SpeechRecognitionLanguage = "ko-KR";

        var fmt = AudioStreamFormat.GetWaveFormatPCM(sampleRate, 16, 1);
        push = AudioInputStream.CreatePushStream(fmt);
        var acfg = AudioConfig.FromStreamInput(push);

        // ② 생성도 풀네임 그대로
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
        if (push == null)
        {
            UnityEngine.Debug.LogWarning("[AzureStreamSender] Push stream not initialized.");
            return;
        }

        if (block == null || block.Length == 0)
        {
            UnityEngine.Debug.LogWarning("[AzureStreamSender] Empty block received.");
            return;
        }

        try
        {
            int len = block.Length * BYTES_PER_SAMPLE;
            byte[] buf = new byte[len];

            for (int i = 0; i < block.Length; i++)
            {
                short s = (short)(Mathf.Clamp(block[i], -1f, 1f) * short.MaxValue);
                buf[i * 2] = (byte)(s & 0xFF);
                buf[i * 2 + 1] = (byte)((s >> 8) & 0xFF);
            }

            push.Write(buf);  // 💥 여기서 크래시 났던 것
        }
        catch (Exception e)
        {
            Debug.LogError($"[AzureStreamSender] push.Write failed: {e.Message}");
        }
    }

    public async Task EndAsync()
    {
        if (rec == null) return;

        try
        {
            await rec.StopContinuousRecognitionAsync();
        }
        catch (Exception e)
        {
            UnityEngine.Debug.LogWarning($"StopContinuousRecognitionAsync failed: {e.Message}");
        }

        rec.Dispose();
        push?.Close();
    }


    public void Dispose()
    {
        _ = EndAsync(); // Fire-and-forget async disposal
    }

}