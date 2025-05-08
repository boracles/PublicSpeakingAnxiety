using UnityEngine;
using TMPro;   // 결과를 UI로도 보고 싶다면

public class ChatManager : MonoBehaviour
{
    [SerializeField] LLMClient llm;   // OpenAIClient 드래그
    [Header("Optional UI")]
    [SerializeField] TMP_Text  output; // TextMeshPro-UGUI

    void Start()
    {
        // 테스트용 프롬프트
        string prompt = "In one sentence, explain what a black hole is.";
        StartCoroutine(llm.Query(prompt, OnReply));
    }

    void OnReply(LLMReply reply, float latency)
    {
        string msg = $"⏱ {latency:F1}s | 💬 {reply.answer}";
        Debug.Log(msg);
        if (output != null) output.text = msg;
    }

    // UI 버튼에 연결하려면:
    public void AskFromInput(TMP_InputField input)
    {
        string prompt = input.text;
        if (!string.IsNullOrWhiteSpace(prompt))
            StartCoroutine(llm.Query(prompt, OnReply));
    }
}