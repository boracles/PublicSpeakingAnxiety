/****************************************************
 * WavUtility.cs ─ Azure TTS + 마이크 송신 통합형
 ****************************************************/
using System;
using UnityEngine;
using System.Text;         // Encoding.ASCII
using System.IO;           // MemoryStream, BinaryWriter

public static class WavUtility
{
    // [기존 기능] 서버가 준 오디오 바이트를 유니티 AudioClip으로 변환 (재생용)
    public static AudioClip ToAudioClip(byte[] data, string name, out int sampleRate)
    {
        if (Encoding.ASCII.GetString(data, 0, 4) != "RIFF" ||
            Encoding.ASCII.GetString(data, 8, 4) != "WAVE")
            throw new InvalidOperationException("Not a WAV file");

        int FindChunk(string id, int start)
        {
            for (int p = start; p + 8 <= data.Length;)
            {
                uint sz = BitConverter.ToUInt32(data, p + 4);
                if (Encoding.ASCII.GetString(data, p, 4) == id) return p;
                p += 8 + Align2((int)sz);
            }
            throw new Exception($"'{id}' chunk not found");
        }

        int fmt = FindChunk("fmt ", 12);
        int fmtSize   = BitConverter.ToInt32(data, fmt + 4);
        short channels   = BitConverter.ToInt16(data, fmt + 10);
        sampleRate       = BitConverter.ToInt32(data, fmt + 12);
        short bitDepth   = BitConverter.ToInt16(data, fmt + 22);
        if (bitDepth != 16) throw new NotSupportedException("Only 16-bit PCM supported");

        int dataChunk = FindChunk("data", fmt + 8 + Align2(fmtSize));
        int byteLen   = BitConverter.ToInt32(data, dataChunk + 4);
        int pcmOffset = dataChunk + 8;

        while (pcmOffset + 1 < dataChunk + 8 + byteLen &&
               BitConverter.ToInt16(data, pcmOffset) == 0)
            ++pcmOffset;

        bool useSwap = false;

        float Peak(int off, bool swap)
        {
            int max = Math.Min(2048, dataChunk + 8 + byteLen - off);
            float pk = 0f;
            for (int i = 0; i + 1 < max; i += 2)
            {
                short s = swap
                    ? (short)((data[off+i+1] << 8) | data[off+i])
                    : BitConverter.ToInt16(data, off + i);
                pk = Math.Max(pk, Mathf.Abs(s) / 32768f);
            }
            return pk;
        }

        float pA = Peak(pcmOffset,     false);
        float pB = Peak(pcmOffset-1,   false);
        float pS = Peak(pcmOffset,     true );

        if (pB > pA && pB > pS)       pcmOffset -= 1;
        else if (pS > pA)             useSwap = true;

        int totalSamples = (dataChunk + 8 + byteLen - pcmOffset) / 2;
        float[] samples  = new float[totalSamples];

        for (int i = 0, b = pcmOffset; i < totalSamples; ++i, b += 2)
        {
            short s = useSwap
                ? (short)((data[b+1] << 8) | data[b])
                : BitConverter.ToInt16(data, b);
            samples[i] = s / 32768f;
        }

        float peak = 0f;
        foreach (var v in samples) peak = Mathf.Max(peak, Mathf.Abs(v));
        if (peak > 0.0001f && peak < 0.7f)
        {
            float gain = 0.7f / peak;
            for (int i = 0; i < samples.Length; ++i)
                samples[i] = Mathf.Clamp(samples[i] * gain, -1f, 1f);
            Debug.Log($"[WAV] peak {peak:F3} → normalized ×{gain:F1}");
        }

        int frames = totalSamples / channels;
        AudioClip clip = AudioClip.Create(name, frames, channels, sampleRate, false);
        clip.SetData(samples, 0);
        return clip;
    }

    static int Align2(int n) => (n & 1) == 1 ? n + 1 : n;

    // ──────────────────────────────────────────────────────────────────
    // [추가된 신규 기능] 유니티 마이크 AudioClip을 서버 전송용 바이트 배열로 변환
    // ──────────────────────────────────────────────────────────────────
    public static byte[] FromAudioClip(AudioClip clip)
    {
        using (var stream = new MemoryStream())
        {
            using (var writer = new BinaryWriter(stream))
            {
                var samples = new float[clip.samples];
                clip.GetData(samples, 0);

                short[] intData = new short[samples.Length];
                byte[] bytesData = new byte[samples.Length * 2];
                int rescaleFactor = 32767;

                for (int i = 0; i < samples.Length; i++)
                {
                    intData[i] = (short)(samples[i] * rescaleFactor);
                    byte[] byteArr = BitConverter.GetBytes(intData[i]);
                    byteArr.CopyTo(bytesData, i * 2);
                }

                writer.Write(new char[4] { 'R', 'I', 'F', 'F' });
                writer.Write(36 + bytesData.Length);
                writer.Write(new char[4] { 'W', 'A', 'V', 'E' });
                writer.Write(new char[4] { 'f', 'm', 't', ' ' });
                writer.Write(16);
                writer.Write((short)1);
                writer.Write((short)clip.channels);
                writer.Write(clip.frequency);
                writer.Write(clip.frequency * clip.channels * 2);
                writer.Write((short)(clip.channels * 2));
                writer.Write((short)16);
                writer.Write(new char[4] { 'd', 'a', 't', 'a' });
                writer.Write(bytesData.Length);
                writer.Write(bytesData);
            }
            return stream.ToArray();
        }
    }
}