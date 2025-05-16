/****************************************************
 *  WavUtility.cs ─ Azure TTS 16-bit PCM 전용
 *    · data 청크 내부 패딩 / 어긋난 바이트 / 바이트스왑
 *      여부를 자동 탐색해 올바른 PCM 을 추출
 *    · 음량이 너무 낮으면 -3 dB(≈0.7) 까지 자동 정규화
 ****************************************************/
using System;
using UnityEngine;
using System.Text;          // Encoding.ASCII

public static class WavUtility
{
    public static AudioClip ToAudioClip(byte[] data, string name, out int sampleRate)
    {
        /* ── 헤더 검사 ─────────────────────────────── */
        if (Encoding.ASCII.GetString(data, 0, 4) != "RIFF" ||
            Encoding.ASCII.GetString(data, 8, 4) != "WAVE")
            throw new InvalidOperationException("Not a WAV file");

        /* ▼ 범용 청크 탐색 함수 (패딩 포함) */
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

        /* fmt 청크 -------------------------------------------------- */
        int fmt = FindChunk("fmt ", 12);
        int fmtSize   = BitConverter.ToInt32(data, fmt + 4);
        short channels   = BitConverter.ToInt16(data, fmt + 10);
        sampleRate       = BitConverter.ToInt32(data, fmt + 12);
        short bitDepth   = BitConverter.ToInt16(data, fmt + 22);
        if (bitDepth != 16) throw new NotSupportedException("Only 16-bit PCM supported");

        /* data 청크 ------------------------------------------------- */
        int dataChunk = FindChunk("data", fmt + 8 + Align2(fmtSize));
        int byteLen   = BitConverter.ToInt32(data, dataChunk + 4);
        int pcmOffset = dataChunk + 8;            // 첫 PCM 바이트

        /* ① 0 아닌 첫 샘플 위치 찾기 (1 바이트씩 전진) */
        while (pcmOffset + 1 < dataChunk + 8 + byteLen &&
               BitConverter.ToInt16(data, pcmOffset) == 0)
            ++pcmOffset;

        /* ② 정렬 / 바이트스왑 자동 판정 --------------------------- */
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

        float pA = Peak(pcmOffset,     false);            // 현재 정렬
        float pB = Peak(pcmOffset-1,   false);            // 1 byte 뒤
        float pS = Peak(pcmOffset,     true );            // 스왑

        if (pB > pA && pB > pS)       pcmOffset -= 1;     // -1 byte 이동
        else if (pS > pA)             useSwap = true;     // 바이트스왑

        /* ③ PCM → float[] ----------------------------------------- */
        int totalSamples = (dataChunk + 8 + byteLen - pcmOffset) / 2;
        float[] samples  = new float[totalSamples];

        for (int i = 0, b = pcmOffset; i < totalSamples; ++i, b += 2)
        {
            short s = useSwap
                ? (short)((data[b+1] << 8) | data[b])
                : BitConverter.ToInt16(data, b);
            samples[i] = s / 32768f;
        }

        /* ④ 자동 정규화 (최대 -3 dB, 즉 0.7 까지) */
        float peak = 0f;
        foreach (var v in samples) peak = Mathf.Max(peak, Mathf.Abs(v));
        if (peak > 0.0001f && peak < 0.7f)
        {
            float gain = 0.7f / peak;
            for (int i = 0; i < samples.Length; ++i)
                samples[i] = Mathf.Clamp(samples[i] * gain, -1f, 1f);
            Debug.Log($"[WAV] peak {peak:F3} → normalized ×{gain:F1}");
        }

        /* ⑤ AudioClip 생성 ----------------------------------------- */
        int frames = totalSamples / channels;
        AudioClip clip = AudioClip.Create(name, frames, channels, sampleRate, false);
        clip.SetData(samples, 0);
        return clip;
    }

    static int Align2(int n) => (n & 1) == 1 ? n + 1 : n;   // 홀수 → 짝수
}
