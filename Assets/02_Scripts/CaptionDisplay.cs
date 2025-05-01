using TMPro;
using UnityEngine;

public class CaptionDisplay : MonoBehaviour
{
    [SerializeField] SpeechRecognizer stt;
    [SerializeField] TMP_Text         caption;

    volatile string pendingText;   // 다른 스레드 → 메인 스레드 전달용
    volatile bool   needUpdate;

    void OnEnable()  { stt.OnText += CacheText; }
    void OnDisable() { stt.OnText -= CacheText; }

    // Azure 콜백 (백그라운드 스레드) -------------------------
    void CacheText(string t, bool final)
    {
        pendingText = final ? t : $"{t} …";
        needUpdate  = true;              // 플래그만 세트
    }

    // Unity 메인 스레드 ------------------------------------
    void Update()
    {
        if (!needUpdate) return;
        needUpdate = false;              // 플래그 클리어

        caption.text = pendingText;      // 안전하게 UI 갱신
        caption.ForceMeshUpdate();       // 즉시 메시 리빌드
    }
}