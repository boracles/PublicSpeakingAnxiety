using UnityEngine;
using System;

public static class SpeechConfigLoader
{
    [Serializable] private struct SpeechCfg { public string key; public string region; }

    public static void Load(out string key, out string region)
    {
        TextAsset json = Resources.Load<TextAsset>("speech"); // Resources/speech.json
        if (json == null)
        {
            Debug.LogError("[SpeechConfigLoader] speech.json not found!");
            key = region = "";
            return;
        }
        var cfg = JsonUtility.FromJson<SpeechCfg>(json.text);
        key    = cfg.key.Trim();
        region = cfg.region.Trim();
    }
}