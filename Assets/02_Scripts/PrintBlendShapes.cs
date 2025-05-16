// Head(스킨메시)에 붙여 두고 한 번만 실행 ► Console에 “번호 : 이름”이 뜹니다.
#if UNITY_EDITOR
using UnityEngine;

public class PrintBlendShapes : MonoBehaviour
{
    [ContextMenu("Print BlendShapes")]
    void Print()
    {
        var mesh = GetComponent<SkinnedMeshRenderer>().sharedMesh;
        for (int i = 0; i < mesh.blendShapeCount; i++)
            Debug.Log($"{i} : {mesh.GetBlendShapeName(i)}");
    }
}
#endif