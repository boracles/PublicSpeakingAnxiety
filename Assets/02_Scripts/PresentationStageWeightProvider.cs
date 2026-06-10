using UnityEngine;

public static class PresentationStageWeightProvider
{
    // Return order: Org, Sup, Msg, CER
    public static Vector4 GetContentWeights(PresentationStage stage)
    {
        switch (stage)
        {
            case PresentationStage.Orientation:
                return new Vector4(0.35f, 0.05f, 0.50f, 0.10f);

            case PresentationStage.Rationale:
                return new Vector4(0.15f, 0.20f, 0.25f, 0.40f);

            case PresentationStage.Framework:
                return new Vector4(0.20f, 0.15f, 0.20f, 0.45f);

            case PresentationStage.Purpose:
                return new Vector4(0.20f, 0.05f, 0.55f, 0.20f);

            case PresentationStage.Methods:
                return new Vector4(0.25f, 0.30f, 0.10f, 0.35f);

            case PresentationStage.Results:
                return new Vector4(0.15f, 0.35f, 0.25f, 0.25f);

            case PresentationStage.Implication:
                return new Vector4(0.15f, 0.20f, 0.35f, 0.30f);

            case PresentationStage.Termination:
                return new Vector4(0.30f, 0.05f, 0.55f, 0.10f);

            default:
                return new Vector4(0.25f, 0.25f, 0.25f, 0.25f);
        }
    }
}