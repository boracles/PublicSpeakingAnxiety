using UnityEngine;
using System;
using System.Threading.Tasks;

public class SpeechRecognizer : MonoBehaviour
{
    [Header("Azure Credentials")]
    public string azureKey    = "2SBzXTEuTeWmlQIJWRw3YzCxY3uFJPpERzJPzaj4ZngPzFzeh7L5JQQJ99BEACNns7RXJ3w3AAAAACOGWzMb";
    public string azureRegion = "koreacentral";

    MicCapturer      mic;
    AzureStreamSender sender;

    public event Action<string, bool> OnText;   // (text, isFinal)
    public float lastLatency;                   // 최종 latency

    void Awake() => mic = GetComponent<MicCapturer>();

    void Start()
    {
        sender = new AzureStreamSender();
        sender.Begin(azureKey, azureRegion);

        sender.OnResult += (txt, t, fin) =>
        {
            if (fin) lastLatency = t;
            OnText?.Invoke(txt, fin);
        };
        mic.OnSegment += sender.Send;
    }

    /* 안전하게 인식 종료 후 파괴 */
    async void OnDestroy()
    {
        mic.OnSegment -= sender.Send;
        await sender.EndAsync();   // ⏹️ 완료 대기
    }
}