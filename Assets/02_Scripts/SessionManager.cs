using UnityEngine;

public class SessionManager : MonoBehaviour
{
    public static SessionManager Instance;
    public SessionData activeSession; // 씬 1에서 받아온 전체 데이터

    void Awake()
    {
        if (Instance == null) { Instance = this; DontDestroyOnLoad(gameObject); }
        else Destroy(gameObject);
    }

    
}