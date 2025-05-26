using UnityEngine;
using System;
using System.Threading.Tasks;

public class SpeechRecognizer : MonoBehaviour
{
    [Header("Azure Credentials")]
    public string azureKey = "2SBzXTEuTeWmlQIJWRw3YzCxY3uFJPpERzJPzaj4ZngPzFzeh7L5JQQJ99BEACNns7RXJ3w3AAAAACOGWzMb";
    public string azureRegion = "koreacentral";

    MicCapturer mic;
    AzureStreamSender sender;

    public event Action<string, bool> OnText;   // (text, isFinal)
    public float lastLatency;                   // 최종 latency

    public bool IsUserSpeaking { get; private set; } = false;
    float speakCooldown = 0f;

    void Update()
    {
        if (IsUserSpeaking)
        {
            speakCooldown -= Time.deltaTime;
            if (speakCooldown <= 0f)
                IsUserSpeaking = false;
        }
    }
    
    void Awake()
    {
        mic = GetComponent<MicCapturer>();
        mic.OnSegment += HandleSegment; // 🧠 여기서 감지
    }
    void HandleSegment(float[] audio)
    {
        IsUserSpeaking = true;
        speakCooldown = 1.2f; // 사용자가 말하면 1.2초 동안 유지
    }
    void Start()
    {
        StartCoroutine(InitWhenMicReady());
    }

    System.Collections.IEnumerator InitWhenMicReady()
    {
        yield return new WaitUntil(() => mic != null && mic.IsReady);
        _ = Init();  // async Task fire-and-forget 호출
    }

    async Task Init()
    {
        try
        {
            sender = new AzureStreamSender();
            sender.Begin(azureKey, azureRegion);  // 비동기 작업이면 await 필요
            mic.OnSegment += sender.Send;
        }
        catch (Exception e)
        {
            UnityEngine.Debug.LogError($"SpeechRecognizer Init failed: {e.Message}");
        }
    }

    async void OnDestroy()
    {
        if (sender != null)
        {
            mic.OnSegment -= sender.Send;
            await sender.EndAsync();
        }
    }
}