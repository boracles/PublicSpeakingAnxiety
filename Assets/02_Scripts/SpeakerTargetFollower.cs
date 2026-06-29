using UnityEngine;

public class SpeakerTargetFollower : MonoBehaviour
{
    [Header("Target")]
    public Transform cameraTransform;

    [Header("Offset From Camera")]
    public Vector3 worldOffset = new Vector3(0f, -0.15f, 0f);

    private void Awake()
    {
        if (cameraTransform == null && Camera.main != null)
        {
            cameraTransform = Camera.main.transform;
        }
    }

    private void LateUpdate()
    {
        if (cameraTransform == null)
            return;

        transform.position = cameraTransform.position + worldOffset;
        transform.rotation = cameraTransform.rotation;
    }
}