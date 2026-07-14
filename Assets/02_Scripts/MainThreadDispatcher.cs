using UnityEngine;
using System;
using System.Collections.Concurrent;

public class MainThreadDispatcher : MonoBehaviour
{
    private static readonly ConcurrentQueue<Action> _executionQueue = new ConcurrentQueue<Action>();

    public static void Enqueue(Action action) => _executionQueue.Enqueue(action);

    void Update()
    {
        while (_executionQueue.TryDequeue(out var action)) action.Invoke();
    }

    [RuntimeInitializeOnLoadMethod]
    private static void Initialize()
    {
        GameObject go = new GameObject("MainThreadDispatcher");
        go.AddComponent<MainThreadDispatcher>();
        DontDestroyOnLoad(go);
    }
}