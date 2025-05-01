using TMPro;
using UnityEngine;

public class CaptionDisplay : MonoBehaviour
{
    [SerializeField] SpeechRecognizer stt;
    [SerializeField] TMP_Text         caption;

    void OnEnable()  { stt.OnText += UpdateText; }
    void OnDisable() { stt.OnText -= UpdateText; }

    void UpdateText(string t, bool final)
    {
        caption.text = final ? t : $"{t} …";
    }
}