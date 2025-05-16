using UnityEngine;

public class LipSyncDebug : MonoBehaviour
{
    public OVRLipSyncContext ctx;   // Head 오브젝트의 OVRLipSyncContext 드래그

    void Update()
    {
        if (!ctx) return;

        OVRLipSync.Frame frame = ctx.GetCurrentPhonemeFrame();

        // 필드 이름은 frameNumber, Visemes(대문자 V)
        Debug.Log($"VIS frame={frame.frameNumber}  AA={frame.Visemes[10]:F2}");
    }
}