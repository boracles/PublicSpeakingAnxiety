using System;
using UnityEngine;

public static class WavUtility
{
    // 16-bit PCM WAV → AudioClip
    public static AudioClip ToAudioClip(byte[] wavBytes, string clipName, out int sampleRate)
    {
        // ── WAV 헤더 파싱 ─────────────────────────────
        // RIFF header 44 bytes
        sampleRate = BitConverter.ToInt32(wavBytes, 24);
        short channels   = BitConverter.ToInt16(wavBytes, 22);
        int   dataStart  = Array.IndexOf(wavBytes, (byte)'d', 36) + 8; // "data" chunk
        int   samples    = (wavBytes.Length - dataStart) / 2;         // 16-bit → /2

        float[] audioData = new float[samples];
        int offset = dataStart;
        for (int i = 0; i < samples; i++)
        {
            short sample = BitConverter.ToInt16(wavBytes, offset);
            audioData[i] = sample / 32768f;
            offset += 2;
        }

        AudioClip clip = AudioClip.Create(clipName, samples / channels, channels, sampleRate, false);
        clip.SetData(audioData, 0);
        return clip;
    }
}