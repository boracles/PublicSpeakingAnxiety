using System;

/// GPT 답변(한 줄 답) 용
[Serializable]
public struct LLMReply
{
    public string answer;      // 답변 문자열
    public string emotion;     // "neutral" | "happy" …
    public float  speechRate;  // 0.8~1.2
}

/// GPT 질문 생성(1~3개 배열) 용
[Serializable]
public struct LLMQuestionSet
{
    public string[] questions; // 길이 1~3
}