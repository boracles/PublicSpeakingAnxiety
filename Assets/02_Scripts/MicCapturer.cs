using UnityEngine;
using System;
using System.Collections;

[RequireComponent(typeof(AudioListener))]
public class MicCapturer : MonoBehaviour
{
    public int sttRate = 16000;                  // Azure에 보낼 목표
    public event Action<float[]> OnSegment16k;   // 20 ms @16 kHz
public event Action<float[]> OnSegment   { add => OnSegment16k += value; 
                                               remove => OnSegment16k -= value; }


    const int SEG_MS = 20;

   public bool IsReady => micBuf && Microphone.IsRecording(device);

    AudioClip micBuf;
	string     device; 
    int inRate;      // 실제 녹음 레이트 (24k/48k 등)
    int segIn, segOut, readPos;
    float[] tmpIn;   // 1프레임 @inRate
    float   resampleStep;

  void Emit(float[] seg16)
    {
        OnSegment16k?.Invoke(seg16);   // (별칭을 통해 OnSegment도 같이 호출)
    }

    void Start()
    {
        device = Microphone.devices.Length > 0 ? Microphone.devices[0] : null;
        if (device == null) { Debug.LogError("No mic device"); return; }

        Microphone.GetDeviceCaps(device, out int min, out int max);
        inRate = (max > 0) ? max : AudioSettings.outputSampleRate;   // fallback

        segIn  =  inRate * SEG_MS / 1000;   // 960 @48k
        segOut = sttRate * SEG_MS / 1000;   // 320 @16k
        tmpIn  = new float[segIn];
        resampleStep = (float)inRate / sttRate;

         micBuf = Microphone.Start(device, true, 60, inRate);
        StartCoroutine(ReadLoop());
    }

    IEnumerator ReadLoop()
    {
        while (Microphone.IsRecording(device))
        {
            int cur = Microphone.GetPosition(device);
            while (Available(cur) >= segIn)
            {
                micBuf.GetData(tmpIn, readPos);
                readPos = (readPos + segIn) % micBuf.samples;

                float[] seg16 = Downsample(tmpIn);   // ↓↓↓
                OnSegment16k?.Invoke(seg16);
            }
            yield return null;
        }
    }
    int Available(int cur) => cur >= readPos ? cur - readPos
                    : micBuf.samples - readPos + cur;

    /* ---- 가장 단순한 down-sampling : nearest-neighbour ---- */
    float[] Downsample(float[] inBuf)
    {
        float[] outBuf = new float[segOut];
        for (int i = 0; i < segOut; i++)
            outBuf[i] = inBuf[(int)(i * resampleStep)];
        return outBuf;
    }

	void OnDestroy()
	{
    	if (Microphone.IsRecording(device))
        	Microphone.End(device);
	}
}
