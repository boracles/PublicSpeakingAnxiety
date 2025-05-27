using UnityEngine;
using System;
using System.Threading.Tasks;
using System.Collections;

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
    mic.OnSegment16k += HandleSegment;   // 이름 수정
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
    _ = Init();
}

    async Task Init()
    {
        try
        {
            sender = new AzureStreamSender();
            sender.Begin(azureKey, azureRegion);  // 마이크 전송 시작
            mic.OnSegment += sender.Send;

            // ✅ STT 결과 수신 → 이벤트 전달
            sender.OnResult += (text, latency, isFinal) =>
            {
                lastLatency = latency;
                OnText?.Invoke(text, isFinal);
            };
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