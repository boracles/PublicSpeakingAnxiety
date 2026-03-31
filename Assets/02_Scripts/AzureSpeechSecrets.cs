using System;
using System.IO;
using UnityEngine;

[Serializable]
public class AzureSpeechSecretData
{
    public string speechKey;
    public string speechRegion;
}

public static class AzureSpeechSecrets
{
    private static AzureSpeechSecretData _cache;

    public static string SpeechKey => Load().speechKey;
    public static string SpeechRegion => Load().speechRegion;

    private static AzureSpeechSecretData Load()
    {
        if (_cache != null) return _cache;

        string path = Path.Combine(Application.dataPath, "../UserSettings/azure_speech.local.json");

        if (!File.Exists(path))
        {
            Debug.LogError($"Secret file not found: {path}");
            _cache = new AzureSpeechSecretData();
            return _cache;
        }

        string json = File.ReadAllText(path);
        _cache = JsonUtility.FromJson<AzureSpeechSecretData>(json);

        if (_cache == null)
            _cache = new AzureSpeechSecretData();

        return _cache;
    }
}