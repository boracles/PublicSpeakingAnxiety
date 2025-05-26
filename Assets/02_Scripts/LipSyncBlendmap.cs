using UnityEngine;

[RequireComponent(typeof(OVRLipSyncContext))]
public class LipSyncBlendMap : MonoBehaviour
{
    [SerializeField] SkinnedMeshRenderer faceMesh;
    [SerializeField] bool clearEachFrame = true;

    [System.Serializable]
    public struct Map
    {
        [Range(0, 14)] public int visemeSlot;
        public int[] blendShapeIndex;
        [Range(0f, 2f)] public float weightMultiplier;
    }

    [SerializeField, HideInInspector]
    public Map[] maps = new Map[]
    {
        new Map { visemeSlot = 1, blendShapeIndex = new int[] { 52, 53 }, weightMultiplier = 1f },       // P, B, M
        new Map { visemeSlot = 2, blendShapeIndex = new int[] { 46, 47 }, weightMultiplier = 0.8f },     // F, V
        new Map { visemeSlot = 3, blendShapeIndex = new int[] { 56, 57 }, weightMultiplier = 1f },       // TH
        new Map { visemeSlot = 4, blendShapeIndex = new int[] { 35 }, weightMultiplier = 1f },           // D, T, S
        new Map { visemeSlot = 5, blendShapeIndex = new int[] { 15 }, weightMultiplier = 1f },           // K, G
        new Map { visemeSlot = 6, blendShapeIndex = new int[] { 9 }, weightMultiplier = 1f },            // CH, SH
        new Map { visemeSlot = 7, blendShapeIndex = new int[] { 37 }, weightMultiplier = 0.8f },         // S, Z
        new Map { visemeSlot = 8, blendShapeIndex = new int[] { 42, 43 }, weightMultiplier = 1f },       // N
        new Map { visemeSlot = 9, blendShapeIndex = new int[] { 51 }, weightMultiplier = 1f },           // R
        new Map { visemeSlot = 10, blendShapeIndex = new int[] { 15 }, weightMultiplier = 1.2f },        // A
        new Map { visemeSlot = 11, blendShapeIndex = new int[] { 46, 47 }, weightMultiplier = 0.8f },    // E
        new Map { visemeSlot = 12, blendShapeIndex = new int[] { 52, 53 }, weightMultiplier = 0.8f },    // I ← 좌우 균형 적용
        new Map { visemeSlot = 13, blendShapeIndex = new int[] { 9 }, weightMultiplier = 1f },           // O
        new Map { visemeSlot = 14, blendShapeIndex = new int[] { 37 }, weightMultiplier = 1f },          // U
    };

    OVRLipSyncContext ctx;

    void Awake()
    {
        ctx = GetComponent<OVRLipSyncContext>();

        maps = new Map[]
        {
            new Map { visemeSlot = 0, blendShapeIndex = new int[] { 35 }, weightMultiplier = 0.1f },         // Silence → mouthClose
            new Map { visemeSlot = 1, blendShapeIndex = new int[] { 52, 53 }, weightMultiplier = 1f },     // P, B, M
            new Map { visemeSlot = 2, blendShapeIndex = new int[] { 48, 49 }, weightMultiplier = 0.4f },   // F, V
            new Map { visemeSlot = 3, blendShapeIndex = new int[] { 56, 57 }, weightMultiplier = 1f },     // TH
            new Map { visemeSlot = 4, blendShapeIndex = new int[] { 34 }, weightMultiplier = 0.3f },         // D, T, S (mouthClose 보강)
            new Map { visemeSlot = 5, blendShapeIndex = new int[] { 40,41,56,57 }, weightMultiplier = 0.3f },         // K, G
            new Map { visemeSlot = 6, blendShapeIndex = new int[] { 36,37 }, weightMultiplier = 0.7f },          // CH, SH
            new Map { visemeSlot = 7, blendShapeIndex = new int[] { 37 }, weightMultiplier = 0.8f },       // S, Z
            new Map { visemeSlot = 8, blendShapeIndex = new int[] { 42, 43 }, weightMultiplier = 1f },     // N
            new Map { visemeSlot = 9, blendShapeIndex = new int[] { 51 }, weightMultiplier = 1f },         // R
            new Map { visemeSlot = 10, blendShapeIndex = new int[] { 34, 56, 57 }, weightMultiplier = 0.05f }, // A (입 벌림 + 하부 립)
            new Map { visemeSlot = 11, blendShapeIndex = new int[] { 34, 52, 53 }, weightMultiplier = 0.1f },  // E
            new Map { visemeSlot = 12, blendShapeIndex = new int[] { 40,41,54,55,56,57 }, weightMultiplier = 0.2f },  // I
            new Map { visemeSlot = 13, blendShapeIndex = new int[] { 34, 36}, weightMultiplier =0.4f },         // O
            new Map { visemeSlot = 14, blendShapeIndex = new int[] { 37 }, weightMultiplier = 1f },        // U

        };
    }

    void Update()
    {
        if (!ctx || !faceMesh) return;

        if (clearEachFrame)
        {
            foreach (var m in maps)
            {
                foreach (var idx in m.blendShapeIndex)
                {
                    if (idx >= 0 && idx < faceMesh.sharedMesh.blendShapeCount)
                        faceMesh.SetBlendShapeWeight(idx, 0);
                }
            }
        }

        var frame = ctx.GetCurrentPhonemeFrame();
        foreach (var m in maps)
        {
            if (m.visemeSlot < 0 || m.visemeSlot >= frame.Visemes.Length)
                continue;

            float visemeValue = frame.Visemes[m.visemeSlot];
            if (visemeValue < 0.2f) continue; // 너무 작은 값 무시

            float w = Mathf.Clamp(visemeValue * 100f * m.weightMultiplier, 0f, 100f);

            foreach (int idx in m.blendShapeIndex)
            {
                if (idx >= 0 && idx < faceMesh.sharedMesh.blendShapeCount)
                    faceMesh.SetBlendShapeWeight(idx, w);
            }
        }

#if UNITY_EDITOR
        Debug.Log($"[Viseme 12] L={faceMesh.GetBlendShapeWeight(52):F2} / R={faceMesh.GetBlendShapeWeight(53):F2}");
#endif
    }
}
