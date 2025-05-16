using System;         
using System.Text; 
using UnityEngine;

public static class WavUtility
{
    // 16-bit PCM WAV → AudioClip
    public static AudioClip ToAudioClip(byte[] data, string name, out int sampleRate)
    {
        // 1. RIFF / WAVE 헤더 체크
        if (Encoding.ASCII.GetString(data, 0, 4) != "RIFF" ||
            Encoding.ASCII.GetString(data, 8, 4) != "WAVE")
            throw new InvalidOperationException("Not a valid WAV file");

        // 2. fmt 청크 위치 찾기
        int fmt = 12;
        while (Encoding.ASCII.GetString(data, fmt, 4) != "fmt ")
            fmt += 8 + BitConverter.ToInt32(data, fmt + 4);   // chunkID+size 스킵

        short channels = BitConverter.ToInt16(data, fmt + 10);
        sampleRate     = BitConverter.ToInt32(data, fmt + 12);
        short bitDepth = BitConverter.ToInt16(data, fmt + 22);    // 16

        // 3. data 청크 위치 찾기
        int dataOffset = fmt + 8 + BitConverter.ToInt32(data, fmt + 4);
        while (Encoding.ASCII.GetString(data, dataOffset, 4) != "data")
            dataOffset += 8 + BitConverter.ToInt32(data, dataOffset + 4);

        int pcmOffset   = dataOffset + 8;
        int bytesLength = BitConverter.ToInt32(data, dataOffset + 4);
        int totalSamples = bytesLength / (bitDepth / 8);

        // 4. 16-bit → float 변환
        float[] samples = new float[totalSamples];
        for (int i = 0, b = pcmOffset; i < totalSamples; i++, b += 2)
            samples[i] = BitConverter.ToInt16(data, b) / 32768f;

        // 5. AudioClip 생성
        int frames = totalSamples / channels;
        AudioClip clip = AudioClip.Create(name, frames, channels, sampleRate, false);
        clip.SetData(samples, 0);
        return clip;
    }

}