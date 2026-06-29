using UnityEngine;

public class AudienceSeatSlot : MonoBehaviour
{
    [Header("Seat Transform")]
    public Transform seatPoint;

    [Header("Local Gaze Targets")]
    public Transform laptopAnchor;
    public Transform laptopTarget;
    public Transform awayTarget;

    [Header("Away Target Auto Placement")]
    public bool autoPlaceAwayTarget = true;

    // SeatPoint 기준 local offset.
    // X: 좌우, Y: 위, Z: 앞/뒤
    public Vector3 awayLocalOffset = new Vector3(1.2f, 1.25f, 0.4f);

    [Tooltip("체크하면 좌석마다 왼쪽/오른쪽 Away 방향을 랜덤하게 바꿀 수 있음")]
    public bool randomizeAwaySide = false;

    [Header("Runtime")]
    public bool hasLaptop;
    public GameObject spawnedLaptop;

    private void Reset()
    {
        TryFindChildren();
    }

    private void OnValidate()
    {
        TryFindChildren();

        if (autoPlaceAwayTarget)
        {
            PlaceAwayTarget();
        }
    }

    [ContextMenu("Find Child Targets")]
    public void TryFindChildren()
    {
        if (seatPoint == null)
            seatPoint = transform.Find("SeatPoint");

        if (laptopAnchor == null)
            laptopAnchor = transform.Find("LaptopAnchor");

        if (laptopTarget == null)
            laptopTarget = transform.Find("LaptopTarget");

        if (awayTarget == null)
            awayTarget = transform.Find("AwayTarget");
    }

    [ContextMenu("Place Away Target")]
    public void PlaceAwayTarget()
    {
        if (seatPoint == null || awayTarget == null)
            return;

        Vector3 offset = awayLocalOffset;

        if (randomizeAwaySide)
        {
            offset.x *= Random.value > 0.5f ? 1f : -1f;
        }

        awayTarget.position =
            seatPoint.position
            + seatPoint.right * offset.x
            + Vector3.up * offset.y
            + seatPoint.forward * offset.z;
    }
}