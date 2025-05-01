using UnityEngine;
using System;

public class SpeechRecognizer : MonoBehaviour
{
    [Header("Azure Credentials")]
    public string azureKey    = "2SBzXTEuTeWmlQIJWRw3YzCxY3uFJPpERzJPzaj4ZngPzFzeh7L5JQQJ99BEACNns7RXJ3w3AAAAACOGWzMb";
    public string azureRegion = "koreacentral";

    MicCapturer      mic;
    AzureStreamSender sender;

    public event Action<string,bool> OnText;   // (text, isFinal)
    public float lastLatency;                  // 최종 텍스트까지 걸린 시간

    void Awake(){ mic = GetComponent<MicCapturer>(); }

    void Start()
    {
        sender = new AzureStreamSender();
        sender.Begin(azureKey, azureRegion);
        sender.OnResult += (txt, t, fin)=>
        {
            if (fin) lastLatency = t;
            OnText?.Invoke(txt, fin);
        };
        mic.OnSegment += sender.Send;
    }
    void OnDestroy()
    {
        mic.OnSegment -= sender.Send;
        sender.End(); sender.Dispose();
    }
}