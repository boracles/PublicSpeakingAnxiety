using UnityEngine;
using System;

public class MicCapturer : MonoBehaviour
{
    public int sampleRate = 16000;
    public event Action<float[]> OnSegment; // 10 ms 단위 오디오 버퍼

    AudioClip micBuf;
    const int SEG_MS = 20;              // 20 ms == 320 샘플(16 kHz)
    int readPos = 0, segSamples;

    void Start()
    {
        segSamples = sampleRate * SEG_MS / 1000;
        micBuf = Microphone.Start("", true, 60, sampleRate);
        StartCoroutine(ReadLoop());
    }

    System.Collections.IEnumerator ReadLoop()
    {
        while (Microphone.IsRecording(null))
        {
            int curPos = Microphone.GetPosition(null);
            while (AvailableSamples(curPos) >= segSamples)
            {
                float[] seg = new float[segSamples];
                micBuf.GetData(seg, readPos);
                readPos = (readPos + segSamples) % micBuf.samples;
                OnSegment?.Invoke(seg);
            }
            yield return null;
        }
    }
    int AvailableSamples(int cur) =>
        cur >= readPos ? cur - readPos : micBuf.samples - readPos + cur;
}