using UnityEngine;
using System;

[RequireComponent(typeof(AudioListener))]
public class MicCapturer : MonoBehaviour
{
    public int sampleRate = 16000;
    public event Action<float[]> OnSegment;     // 20 ms PCM float[]

    const int SEG_MS = 20;
    AudioClip micBuf; int segSamples, readPos;

    void Start()
    {
        segSamples = sampleRate * SEG_MS / 1000;
        micBuf = Microphone.Start(null, true, 60, sampleRate);  // VR 헤드셋 기본 입력
        StartCoroutine(ReadLoop());
    }

    System.Collections.IEnumerator ReadLoop()
    {
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