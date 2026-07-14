using System.IO;
using UnityEngine;
using System;

public static class SavWav
{
    public static byte[] GetAudioData(AudioClip clip)
    {
        float[] samples = new float[clip.samples * clip.channels];
        clip.GetData(samples, 0);
        short[] intData = new short[samples.Length];
        for (int i = 0; i < samples.Length; i++) intData[i] = (short)(samples[i] * 32767);
        
        byte[] bytes = new byte[intData.Length * 2];
        Buffer.BlockCopy(intData, 0, bytes, 0, bytes.Length);
        
        // WAV 헤더 포함을 위해 MemoryStream 사용
        using (var stream = new MemoryStream())
        {
            using (var writer = new BinaryWriter(stream))
            {
                writer.Write(new char[4] { 'R', 'I', 'F', 'F' });
                writer.Write(36 + bytes.Length);
                writer.Write(new char[4] { 'W', 'A', 'V', 'E' });
                writer.Write(new char[4] { 'f', 'm', 't', ' ' });
                writer.Write(16);
                writer.Write((short)1); // PCM
                writer.Write((short)clip.channels);
                writer.Write(clip.frequency);
                writer.Write(clip.frequency * clip.channels * 2);
                writer.Write((short)(clip.channels * 2));
                writer.Write((short)16); // Bit depth
                writer.Write(new char[4] { 'd', 'a', 't', 'a' });
                writer.Write(bytes.Length);
                writer.Write(bytes);
            }
            return stream.ToArray();
        }
    }
}