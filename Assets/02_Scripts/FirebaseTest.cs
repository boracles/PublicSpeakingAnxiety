using UnityEngine;
using TMPro; // 유니티 최신 텍스트 도구 사용
using Firebase.Database;

public class FirebaseTest : MonoBehaviour
{
    public TMP_InputField pinInputField; // 유니티에서 연결할 입력창

    public void RequestData()
    {
        string pin = pinInputField.text; // 입력창에 쓴 글자를 가져옴
        string path = "sessions/" + pin;
        
        Debug.Log("입력한 PIN으로 데이터 찾는 중: " + path);

        FirebaseDatabase.DefaultInstance.GetReference(path).GetValueAsync().ContinueWith(task => 
        {
            if (task.IsCompleted && task.Result.Exists)
            {
                string json = task.Result.GetRawJsonValue();
                Debug.Log("성공! 정보 가져옴: " + json);
                
                // 여기서 아까 말씀하신 '필요한 일부분'을 뽑아낼 수 있어요!
            }
        });
    }
}