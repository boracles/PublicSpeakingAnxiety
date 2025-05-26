using UnityEngine;
using System;

[RequireComponent(typeof(AudioListener))]
public class MicCapturer : MonoBehaviour
{
    public int sampleRate = 16000;
    public event Action<float[]> OnSegment;     // 20 ms PCM float[]

    public bool IsReady { get; private set; }   // ✅ 마이크 준비 여부

    const int SEG_MS = 20;
    AudioClip micBuf; int segSamples, readPos;

    void Start()
    {
        segSamples = sampleRate * SEG_MS / 1000;
        micBuf = Microphone.Start(null, true, 60, sampleRate);
        StartCoroutine(InitAndReadLoop());
    }

    System.Collections.IEnumerator InitAndReadLoop()
    {
        // 마이크 시작될 때까지 대기
        while (!(Microphone.IsRecording(null) && Microphone.GetPosition(null) > 0))
        {
            yield return null;
        }

        IsReady = true;  // ✅ mic 준비 완료

        while (Microphone.IsRecording(null))
        {
            int cur = Microphone.GetPosition(null);
            while (Available(cur) >= segSamples)
            {
                float[] seg = new float[segSamples];
                micBuf.GetData(seg, readPos);
                readPos = (readPos + segSamples) % micBuf.samples;
                OnSegment?.Invoke(seg);
            }
            yield return null;
        }
    }

    int Available(int cur) => cur >= readPos ? cur - readPos :
        micBuf.samples - readPos + cur;
}