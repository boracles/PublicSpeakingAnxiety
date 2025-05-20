using UnityEngine;
using OVR;

[RequireComponent(typeof(OVRLipSyncContext))]
public class LipSyncBlendMap : MonoBehaviour
{
    [SerializeField] SkinnedMeshRenderer faceMesh;
    [SerializeField] bool clearEachFrame = true;

    [System.Serializable] public struct Map
    {
        [Range(0,14)] public int visemeSlot;
        public int[] blendShapeIndex;
        [Range(0f,2f)] public float weightMultiplier;
    }
    public Map[] maps;

    OVRLipSyncContext ctx;

    void Awake() => ctx = GetComponent<OVRLipSyncContext>();

    void Update()
    {
        if (!ctx || !faceMesh) return;

        if (clearEachFrame)
            for (int i = 0; i < faceMesh.sharedMesh.blendShapeCount; i++)
                faceMesh.SetBlendShapeWeight(i, 0);

        var frame = ctx.GetCurrentPhonemeFrame();
        foreach (var m in maps)
        {
            float w = frame.Visemes[m.visemeSlot] * 100f * m.weightMultiplier;
            foreach (int idx in m.blendShapeIndex)
                faceMesh.SetBlendShapeWeight(idx, w);
        }

        // --- 디버그: PP 좌우 값 확인
        float l = faceMesh.GetBlendShapeWeight(52);
        float r = faceMesh.GetBlendShapeWeight(53);
        Debug.Log($"PP L={l:F1} R={r:F1}");
    }
}