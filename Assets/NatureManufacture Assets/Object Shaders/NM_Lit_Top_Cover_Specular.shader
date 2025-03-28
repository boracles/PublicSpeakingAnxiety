﻿Shader "NatureManufacture/URP/Lit/Specular Top Cover"
{
    Properties
    {
        _AlphaCutoff("Alpha Cutoff", Range(0, 1)) = 0
        _BaseColor("Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BaseColorMap("Base Map(RGB) Alpha(A)", 2D) = "white" {}
        [ToggleUI]_BaseUsePlanarUV("Base Use Planar UV", Float) = 0
        _BaseTilingOffset("Base Tiling and Offset", Vector) = (1, 1, 0, 0)
        _SpecularColor("Specular Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_SpecularColorMap("Specular Map", 2D) = "white" {}
        [Normal][NoScaleOffset]_BaseNormalMap("Base Normal Map", 2D) = "bump" {}
        _BaseNormalScale("Base Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BaseMaskMap("Base Mask Map AO(G) SM(A)", 2D) = "white" {}
        _BaseAORemapMin("Base AO Remap Min", Range(0, 1)) = 0
        _BaseAORemapMax("Base AO Remap Max", Range(0, 1)) = 1
        _BaseSmoothnessRemapMin("Base Smoothness Remap Min", Range(0, 1)) = 0
        _BaseSmoothnessRemapMax("Base Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_CoverMaskA("Cover Mask (A)", 2D) = "white" {}
        _CoverMaskPower("Cover Mask Power", Range(0, 10)) = 1
        _Cover_Amount("Cover Amount", Range(0, 2)) = 2
        _Cover_Amount_Grow_Speed("Cover Amount Grow Speed", Range(0, 5)) = 3
        _Cover_Max_Angle("Cover Max Angle", Range(0.001, 90)) = 35
        _Cover_Min_Height("Cover Min Height", Float) = -10000
        _Cover_Min_Height_Blending("Cover Min Height Blending", Range(0, 500)) = 1
        _CoverBaseColor("Cover Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_CoverBaseColorMap("Cover Base Map", 2D) = "white" {}
        [ToggleUI]_CoverUsePlanarUV("Cover Use Planar UV", Float) = 1
        _CoverTilingOffset("Cover Tiling Offset", Vector) = (1, 1, 0, 0)
        _CoverSpecularColor("Cover Specular Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_CoverSpecularColorMap("Cover Specular Map", 2D) = "white" {}
        [Normal][NoScaleOffset]_CoverNormalMap("Cover Normal Map", 2D) = "bump" {}
        _CoverNormalScale("Cover Normal Scale", Range(0, 8)) = 1
        _CoverNormalBlendHardness("Cover Normal Blend Hardness", Range(0, 8)) = 1
        _CoverHardness("Cover Hardness", Range(0, 10)) = 5
        _CoverHeightMapMin("Cover Height Map Min", Float) = 0
        _CoverHeightMapMax("Cover Height Map Max", Float) = 1
        _CoverHeightMapOffset("Cover Height Map Offset", Float) = 0
        [NoScaleOffset]_CoverMaskMap("Cover Mask Map AO(G) H(B) SM(A)", 2D) = "white" {}
        _CoverAORemapMin("Cover AO Remap Min", Range(0, 1)) = 0
        _CoverAORemapMax("Cover AO Remap Max", Range(0, 1)) = 1
        _CoverSmoothnessRemapMin("Cover Smoothness Remap Min", Range(0, 1)) = 0
        _CoverSmoothnessRemapMax("Cover Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_DetailMap("Detail Map Base (R) Ny(G) Sm(B) Nx(A)", 2D) = "white" {}
        _DetailTilingOffset("Detail Tiling Offset", Vector) = (1, 1, 0, 0)
        _DetailAlbedoScale("Detail Albedo Scale", Range(0, 2)) = 0
        _DetailNormalScale("Detail Normal Scale", Range(0, 2)) = 0
        _DetailSmoothnessScale("Detail Smoothness Scale", Range(0, 2)) = 0
        _WetColor("Wet Color Vertex(R)", Color) = (0.7735849, 0.7735849, 0.7735849, 0)
        _WetSmoothness("Wet Smoothness Vertex(R)", Range(0, 1)) = 1
        [Toggle]_USEDYNAMICCOVERTSTATICMASKF("Use Dynamic Cover (T) Static Mask (F)", Float) = 1
        [HideInInspector]_WorkflowMode("_WorkflowMode", Float) = 0
        [HideInInspector]_CastShadows("_CastShadows", Float) = 1
        [HideInInspector]_ReceiveShadows("_ReceiveShadows", Float) = 1
        [HideInInspector]_Surface("_Surface", Float) = 0
        [HideInInspector]_Blend("_Blend", Float) = 0
        [HideInInspector]_AlphaClip("_AlphaClip", Float) = 1
        [HideInInspector]_BlendModePreserveSpecular("_BlendModePreserveSpecular", Float) = 0
        [HideInInspector]_SrcBlend("_SrcBlend", Float) = 1
        [HideInInspector]_DstBlend("_DstBlend", Float) = 0
        [HideInInspector][ToggleUI]_ZWrite("_ZWrite", Float) = 1
        [HideInInspector]_ZWriteControl("_ZWriteControl", Float) = 0
        [HideInInspector]_ZTest("_ZTest", Float) = 4
        [HideInInspector]_Cull("_Cull", Float) = 2
        [HideInInspector]_AlphaToMask("_AlphaToMask", Float) = 1
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Opaque"
            "UniversalMaterialType" = "Lit"
            "Queue"="AlphaTest"
            "DisableBatching"="LODFading"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        AlphaToMask [_AlphaToMask]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_SHADOW_COORD
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 sh;
            #endif
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 probeOcclusion;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 probeOcclusion : INTERP3;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 shadowCoord : INTERP4;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 fogFactorAndVertexLight : INTERP9;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP10;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP11;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4.xyz);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4, _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4, _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float, 2, _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float;
            Unity_Add_float(_Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float, float(-1), _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float;
            Unity_Multiply_float_float(_Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float, _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float;
            Unity_Saturate_float(_Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float, _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float;
            Unity_Absolute_float(_Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83;
            float3 _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(_Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4, _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_ad1db3524021ac898447cb6f6daa4180;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv0 = IN.uv0;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv2 = IN.uv2;
            float4 _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_ad1db3524021ac898447cb6f6daa4180, _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4, _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4, _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3, (_Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4.xyz), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float;
            Unity_OneMinus_float(_Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3, (_OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float.xxx), _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f617479b11216b84b89956263f8d3c08_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SpecularColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.uv0 = IN.uv0;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.uv2 = IN.uv2;
            float4 _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_f617479b11216b84b89956263f8d3c08_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d, _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_112303b9c27a1284b20f0a5c49fb436a_Out_0_Vector4 = _SpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4, _Property_112303b9c27a1284b20f0a5c49fb436a_Out_0_Vector4, _Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0c768f7d1094a8878d837f25970dbd49_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverSpecularColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4b88db16993b7d84a6c9e021b5992a38;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.uv0 = IN.uv0;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.uv2 = IN.uv2;
            float4 _PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_0c768f7d1094a8878d837f25970dbd49_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4b88db16993b7d84a6c9e021b5992a38, _PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_51d3c44a7110108d9e8c9a3acf54125f_Out_0_Vector4 = _CoverSpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4, _Property_51d3c44a7110108d9e8c9a3acf54125f_Out_0_Vector4, _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4, _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxxx), _Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c3340c29f2140f8f8bbbca8e3ac6e935_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.uv0 = IN.uv0;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.uv2 = IN.uv2;
            float4 _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c3340c29f2140f8f8bbbca8e3ac6e935_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798, _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_R_1_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[0];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_G_2_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[1];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_B_3_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[2];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_A_4_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17db4be114794884ae7d51b4ff3236fa_Out_0_Float = _BaseAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8d5959b3eb3a981a491d5f157b6e7a5_Out_0_Float = _BaseAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_882d119ede9a3e8fa5f4007386055eb4_Out_0_Vector2 = float2(_Property_17db4be114794884ae7d51b4ff3236fa_Out_0_Float, _Property_f8d5959b3eb3a981a491d5f157b6e7a5_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float;
            Unity_Remap_float(_Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_G_2_Float, float2 (0, 1), _Vector2_882d119ede9a3e8fa5f4007386055eb4_Out_0_Vector2, _Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e353baf414594b8882fb914562e81165_Out_0_Float = _BaseSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9fca56cf8fdacc8c992be037c63a0fcc_Out_0_Float = _BaseSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_b97c14631eda2a8f96509e399d91fd4e_Out_0_Vector2 = float2(_Property_e353baf414594b8882fb914562e81165_Out_0_Float, _Property_9fca56cf8fdacc8c992be037c63a0fcc_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float;
            Unity_Remap_float(_Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_A_4_Float, float2 (0, 1), _Vector2_b97c14631eda2a8f96509e399d91fd4e_Out_0_Vector2, _Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float, 2, _Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float;
            Unity_Add_float(_Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float, float(-1), _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_401569542f83a881a05eb0986cdfe456_Out_0_Float = _DetailSmoothnessScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float;
            Unity_Multiply_float_float(_Add_90fe4c7160867189855da1debdba6c07_Out_2_Float, _Property_401569542f83a881a05eb0986cdfe456_Out_0_Float, _Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float;
            Unity_Saturate_float(_Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float, _Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float;
            Unity_Absolute_float(_Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float, _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da;
            float _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float, _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float, _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float, _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da, _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float, _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1938f682185f2684bdb56c7122e6e217_Out_0_Vector2 = float2(_Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float, _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5e08cfb127183a8993376f9087501eee_Out_0_Float = _CoverAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f9b151dbb2e38b80ae34d2cb39e48968_Out_0_Float = _CoverAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_2936191c743e7e85b321164ea0868f15_Out_0_Vector2 = float2(_Property_5e08cfb127183a8993376f9087501eee_Out_0_Float, _Property_f9b151dbb2e38b80ae34d2cb39e48968_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float, float2 (0, 1), _Vector2_2936191c743e7e85b321164ea0868f15_Out_0_Vector2, _Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_fc781de8b634448e9eaf731f6deea7ab_Out_0_Float = _CoverSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9ec153766553ef8f9837b25f052b5489_Out_0_Float = _CoverSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_64f7b7c5bb94cf839bc5b9ceeee149e7_Out_0_Vector2 = float2(_Property_fc781de8b634448e9eaf731f6deea7ab_Out_0_Float, _Property_9ec153766553ef8f9837b25f052b5489_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float, float2 (0, 1), _Vector2_64f7b7c5bb94cf839bc5b9ceeee149e7_Out_0_Vector2, _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1ff7ced4c39e238dbca2a0ed97b7f617_Out_0_Vector2 = float2(_Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float, _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2;
            Unity_Lerp_float2(_Vector2_1938f682185f2684bdb56c7122e6e217_Out_0_Vector2, _Vector2_1ff7ced4c39e238dbca2a0ed97b7f617_Out_0_Vector2, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xx), _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_R_1_Float = _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2[0];
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_G_2_Float = _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2[1];
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_B_3_Float = 0;
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_db3738be692e59879a26d5bfe67edc38_Out_0_Float = _WetSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float;
            Unity_Lerp_float(_Split_beb57fcf05cbb6809f536625bac5fcbc_G_2_Float, _Property_db3738be692e59879a26d5bfe67edc38_Out_0_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float, _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            surface.NormalTS = _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Specular = (_Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4.xyz);
            surface.Smoothness = _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float;
            surface.Occlusion = _Split_beb57fcf05cbb6809f536625bac5fcbc_R_1_Float;
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma shader_feature_fragment _ _SURFACE_TYPE_TRANSPARENT
        #pragma shader_feature_local_fragment _ _ALPHAPREMULTIPLY_ON
        #pragma shader_feature_local_fragment _ _ALPHAMODULATE_ON
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local_fragment _ _SPECULAR_SETUP
        #pragma shader_feature_local _ _RECEIVE_SHADOWS_OFF
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_SHADOW_COORD
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 staticLightmapUV;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 dynamicLightmapUV;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 sh;
            #endif
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 probeOcclusion;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 fogFactorAndVertexLight;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 shadowCoord;
            #endif
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 staticLightmapUV : INTERP0;
            #endif
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #endif
            #if !defined(LIGHTMAP_ON)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 sh : INTERP2;
            #endif
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 probeOcclusion : INTERP3;
            #endif
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 shadowCoord : INTERP4;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP6;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP7;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP8;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 fogFactorAndVertexLight : INTERP9;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP10;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP11;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4.xyz);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float
        {
        };
        
        void SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(float Vector1_32317166, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float IN, out float SmoothnessOverlay_1)
        {
        float _Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float = Vector1_32317166;
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        Unity_Lerp_float(_Property_728cc50521e9e988ac9cbff4872d5139_Out_0_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float);
        SmoothnessOverlay_1 = _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Float;
        }
        
        void Unity_Lerp_float2(float2 A, float2 B, float2 T, out float2 Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4, _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4, _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float, 2, _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float;
            Unity_Add_float(_Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float, float(-1), _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float;
            Unity_Multiply_float_float(_Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float, _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float;
            Unity_Saturate_float(_Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float, _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float;
            Unity_Absolute_float(_Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83;
            float3 _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(_Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4, _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_ad1db3524021ac898447cb6f6daa4180;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv0 = IN.uv0;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv2 = IN.uv2;
            float4 _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_ad1db3524021ac898447cb6f6daa4180, _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4, _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4, _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3, (_Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4.xyz), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float;
            Unity_OneMinus_float(_Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3, (_OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float.xxx), _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f617479b11216b84b89956263f8d3c08_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_SpecularColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.uv0 = IN.uv0;
            _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d.uv2 = IN.uv2;
            float4 _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_f617479b11216b84b89956263f8d3c08_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d, _PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_112303b9c27a1284b20f0a5c49fb436a_Out_0_Vector4 = _SpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_b414d1b5f4b94583b24eca320a17ce5d_XZ_2_Vector4, _Property_112303b9c27a1284b20f0a5c49fb436a_Out_0_Vector4, _Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0c768f7d1094a8878d837f25970dbd49_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverSpecularColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4b88db16993b7d84a6c9e021b5992a38;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.uv0 = IN.uv0;
            _PlanarNM_4b88db16993b7d84a6c9e021b5992a38.uv2 = IN.uv2;
            float4 _PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_0c768f7d1094a8878d837f25970dbd49_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4b88db16993b7d84a6c9e021b5992a38, _PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_51d3c44a7110108d9e8c9a3acf54125f_Out_0_Vector4 = _CoverSpecularColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_4b88db16993b7d84a6c9e021b5992a38_XZ_2_Vector4, _Property_51d3c44a7110108d9e8c9a3acf54125f_Out_0_Vector4, _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_589dd3239f9b0180a41a877e92129d86_Out_2_Vector4, _Multiply_7c126a5e6707b98c9d609eab51a4ea2e_Out_2_Vector4, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxxx), _Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_c3340c29f2140f8f8bbbca8e3ac6e935_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.uv0 = IN.uv0;
            _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798.uv2 = IN.uv2;
            float4 _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_c3340c29f2140f8f8bbbca8e3ac6e935_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798, _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_R_1_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[0];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_G_2_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[1];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_B_3_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[2];
            float _Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_A_4_Float = _PlanarNM_4ccd2898ce29eb8cb83d70f42545f798_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_17db4be114794884ae7d51b4ff3236fa_Out_0_Float = _BaseAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8d5959b3eb3a981a491d5f157b6e7a5_Out_0_Float = _BaseAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_882d119ede9a3e8fa5f4007386055eb4_Out_0_Vector2 = float2(_Property_17db4be114794884ae7d51b4ff3236fa_Out_0_Float, _Property_f8d5959b3eb3a981a491d5f157b6e7a5_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float;
            Unity_Remap_float(_Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_G_2_Float, float2 (0, 1), _Vector2_882d119ede9a3e8fa5f4007386055eb4_Out_0_Vector2, _Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_e353baf414594b8882fb914562e81165_Out_0_Float = _BaseSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9fca56cf8fdacc8c992be037c63a0fcc_Out_0_Float = _BaseSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_b97c14631eda2a8f96509e399d91fd4e_Out_0_Vector2 = float2(_Property_e353baf414594b8882fb914562e81165_Out_0_Float, _Property_9fca56cf8fdacc8c992be037c63a0fcc_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float;
            Unity_Remap_float(_Split_2e6f7bdf69b05c8fa427b0e2f6ad5d00_A_4_Float, float2 (0, 1), _Vector2_b97c14631eda2a8f96509e399d91fd4e_Out_0_Vector2, _Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float, 2, _Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float;
            Unity_Add_float(_Multiply_0732b1d3268d4a82b0a5f5d8a9ab5015_Out_2_Float, float(-1), _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_401569542f83a881a05eb0986cdfe456_Out_0_Float = _DetailSmoothnessScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float;
            Unity_Multiply_float_float(_Add_90fe4c7160867189855da1debdba6c07_Out_2_Float, _Property_401569542f83a881a05eb0986cdfe456_Out_0_Float, _Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float;
            Unity_Saturate_float(_Multiply_066c7502ba1d068b80c94d9b0e6d847b_Out_2_Float, _Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float;
            Unity_Absolute_float(_Saturate_fe9c59f87b4c918db2b01b4fbdd0384d_Out_1_Float, _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da;
            float _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float;
            SG_BlendOverlayDetailSmoothness_06e12138dc89c0040b45a57abe520a1a_float(_Remap_b79b15e7c7684e82841e76ea04b64b1c_Out_3_Float, _Add_90fe4c7160867189855da1debdba6c07_Out_2_Float, _Absolute_6a695442ee4e45848edcae77b3cebe4d_Out_1_Float, _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da, _BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float;
            Unity_Saturate_float(_BlendOverlayDetailSmoothness_032bd77f1d1b168ea120852e47b545da_SmoothnessOverlay_1_Float, _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1938f682185f2684bdb56c7122e6e217_Out_0_Vector2 = float2(_Remap_41a03cd97d23b8828a061c7cd45ea3a4_Out_3_Float, _Saturate_eb8ade7db870ae8c9e5a51a081a695bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_5e08cfb127183a8993376f9087501eee_Out_0_Float = _CoverAORemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f9b151dbb2e38b80ae34d2cb39e48968_Out_0_Float = _CoverAORemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_2936191c743e7e85b321164ea0868f15_Out_0_Vector2 = float2(_Property_5e08cfb127183a8993376f9087501eee_Out_0_Float, _Property_f9b151dbb2e38b80ae34d2cb39e48968_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float, float2 (0, 1), _Vector2_2936191c743e7e85b321164ea0868f15_Out_0_Vector2, _Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_fc781de8b634448e9eaf731f6deea7ab_Out_0_Float = _CoverSmoothnessRemapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9ec153766553ef8f9837b25f052b5489_Out_0_Float = _CoverSmoothnessRemapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_64f7b7c5bb94cf839bc5b9ceeee149e7_Out_0_Vector2 = float2(_Property_fc781de8b634448e9eaf731f6deea7ab_Out_0_Float, _Property_9ec153766553ef8f9837b25f052b5489_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float, float2 (0, 1), _Vector2_64f7b7c5bb94cf839bc5b9ceeee149e7_Out_0_Vector2, _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_1ff7ced4c39e238dbca2a0ed97b7f617_Out_0_Vector2 = float2(_Remap_910576e3fb14d2828990f97334f2c8f4_Out_3_Float, _Remap_86d725bf6a583687961ea716cc00b05d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2;
            Unity_Lerp_float2(_Vector2_1938f682185f2684bdb56c7122e6e217_Out_0_Vector2, _Vector2_1ff7ced4c39e238dbca2a0ed97b7f617_Out_0_Vector2, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xx), _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_R_1_Float = _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2[0];
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_G_2_Float = _Lerp_269f9e6c4c4f558b9ce93506d424f1c9_Out_3_Vector2[1];
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_B_3_Float = 0;
            float _Split_beb57fcf05cbb6809f536625bac5fcbc_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_db3738be692e59879a26d5bfe67edc38_Out_0_Float = _WetSmoothness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float;
            Unity_Lerp_float(_Split_beb57fcf05cbb6809f536625bac5fcbc_G_2_Float, _Property_db3738be692e59879a26d5bfe67edc38_Out_0_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float, _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            surface.NormalTS = _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Specular = (_Lerp_47ca78e28d9a1080952043471bd239f8_Out_3_Vector4.xyz);
            surface.Smoothness = _Lerp_b76e2a994fc7788fb9f68d906a1d2d2b_Out_3_Float;
            surface.Occlusion = _Split_beb57fcf05cbb6809f536625bac5fcbc_R_1_Float;
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP3;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthOnly"
            Tags
            {
                "LightMode" = "DepthOnly"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        ColorMask R
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull [_Cull]
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define USE_UNITY_CROSSFADE 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/LODCrossFade.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 TangentSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float = _CoverNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_dbc7c8413d1704879478e13baa7b66f1_Out_0_Float, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_316925999eb53a86a3669e22c8809208_Out_2_Vector3, (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.NormalTS = _Lerp_6c096bfe241ea2898fb3c496a3f320f8_Out_3_Vector3;
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_INSTANCEID
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv1 : TEXCOORD1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord1 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP5;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP6;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4.xyz);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4, _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4, _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float, 2, _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float;
            Unity_Add_float(_Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float, float(-1), _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float;
            Unity_Multiply_float_float(_Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float, _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float;
            Unity_Saturate_float(_Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float, _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float;
            Unity_Absolute_float(_Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83;
            float3 _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(_Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4, _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_ad1db3524021ac898447cb6f6daa4180;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv0 = IN.uv0;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv2 = IN.uv2;
            float4 _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_ad1db3524021ac898447cb6f6daa4180, _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4, _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4, _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3, (_Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4.xyz), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float;
            Unity_OneMinus_float(_Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3, (_OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float.xxx), _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP2;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull [_Cull]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4.xyz);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4, _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4, _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float, 2, _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float;
            Unity_Add_float(_Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float, float(-1), _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float;
            Unity_Multiply_float_float(_Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float, _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float;
            Unity_Saturate_float(_Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float, _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float;
            Unity_Absolute_float(_Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83;
            float3 _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(_Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4, _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_ad1db3524021ac898447cb6f6daa4180;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv0 = IN.uv0;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv2 = IN.uv2;
            float4 _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_ad1db3524021ac898447cb6f6daa4180, _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4, _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4, _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3, (_Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4.xyz), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float;
            Unity_OneMinus_float(_Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3, (_OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float.xxx), _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull [_Cull]
        Blend [_SrcBlend] [_DstBlend]
        ZTest [_ZTest]
        ZWrite [_ZWrite]
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature_local_fragment _ _ALPHATEST_ON
        #pragma shader_feature_local _ _USEDYNAMICCOVERTSTATICMASKF_ON
        
        #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            #define KEYWORD_PERMUTATION_0
        #else
            #define KEYWORD_PERMUTATION_1
        #endif
        
        
        // Defines
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMALMAP 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define _NORMAL_DROPOFF_TS 1
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_NORMAL
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TANGENT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define ATTRIBUTES_NEED_COLOR
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_POSITION_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_NORMAL_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TANGENT_WS
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD0
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_TEXCOORD2
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        #define VARYINGS_NEED_COLOR
        #endif
        
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionOS : POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalOS : NORMAL;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentOS : TANGENT;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0 : TEXCOORD0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2 : TEXCOORD2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : COLOR;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
            #endif
        };
        struct Varyings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        struct SurfaceDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 WorldSpaceBiTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 AbsoluteWorldSpacePosition;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 uv2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 VertexColor;
            #endif
        };
        struct VertexDescriptionInputs
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceNormal;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpaceTangent;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 ObjectSpacePosition;
            #endif
        };
        struct PackedVaryings
        {
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 positionCS : SV_POSITION;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 tangentWS : INTERP0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord0 : INTERP1;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 texCoord2 : INTERP2;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float4 color : INTERP3;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 positionWS : INTERP4;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             float3 normalWS : INTERP5;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
            #endif
        };
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord2.xyzw = input.texCoord2;
            output.color.xyzw = input.color;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.color = input.color.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        #endif
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float _AlphaCutoff;
        float4 _BaseColor;
        float4 _BaseColorMap_TexelSize;
        float _BaseUsePlanarUV;
        float4 _BaseTilingOffset;
        float4 _SpecularColor;
        float4 _SpecularColorMap_TexelSize;
        float4 _BaseNormalMap_TexelSize;
        float _BaseNormalScale;
        float4 _BaseMaskMap_TexelSize;
        float _BaseAORemapMin;
        float _BaseAORemapMax;
        float _BaseSmoothnessRemapMin;
        float _BaseSmoothnessRemapMax;
        float4 _CoverMaskA_TexelSize;
        float _CoverMaskPower;
        float _Cover_Amount;
        float _Cover_Amount_Grow_Speed;
        float _Cover_Max_Angle;
        float _Cover_Min_Height;
        float _Cover_Min_Height_Blending;
        float4 _CoverBaseColor;
        float4 _CoverBaseColorMap_TexelSize;
        float _CoverUsePlanarUV;
        float4 _CoverTilingOffset;
        float4 _CoverSpecularColor;
        float4 _CoverSpecularColorMap_TexelSize;
        float4 _CoverNormalMap_TexelSize;
        float _CoverNormalScale;
        float _CoverNormalBlendHardness;
        float _CoverHardness;
        float _CoverHeightMapMin;
        float _CoverHeightMapMax;
        float _CoverHeightMapOffset;
        float4 _CoverMaskMap_TexelSize;
        float _CoverAORemapMin;
        float _CoverAORemapMax;
        float _CoverSmoothnessRemapMin;
        float _CoverSmoothnessRemapMax;
        float4 _DetailMap_TexelSize;
        float4 _DetailTilingOffset;
        float _DetailAlbedoScale;
        float _DetailNormalScale;
        float _DetailSmoothnessScale;
        float4 _WetColor;
        float _WetSmoothness;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        SAMPLER(SamplerState_Linear_Repeat_Aniso8);
        TEXTURE2D(_BaseColorMap);
        SAMPLER(sampler_BaseColorMap);
        TEXTURE2D(_SpecularColorMap);
        SAMPLER(sampler_SpecularColorMap);
        TEXTURE2D(_BaseNormalMap);
        SAMPLER(sampler_BaseNormalMap);
        TEXTURE2D(_BaseMaskMap);
        SAMPLER(sampler_BaseMaskMap);
        TEXTURE2D(_CoverMaskA);
        SAMPLER(sampler_CoverMaskA);
        TEXTURE2D(_CoverBaseColorMap);
        SAMPLER(sampler_CoverBaseColorMap);
        TEXTURE2D(_CoverSpecularColorMap);
        SAMPLER(sampler_CoverSpecularColorMap);
        TEXTURE2D(_CoverNormalMap);
        SAMPLER(sampler_CoverNormalMap);
        TEXTURE2D(_CoverMaskMap);
        SAMPLER(sampler_CoverMaskMap);
        TEXTURE2D(_DetailMap);
        SAMPLER(sampler_DetailMap);
        
        // Graph Includes
        // GraphIncludes: <None>
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
        Out = A * B;
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Branch_float2(float Predicate, float2 True, float2 False, out float2 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float
        {
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_2EBA7A3B, float Boolean_7ABB9909, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float IN, out float4 XZ_2)
        {
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Property_30834f691775a0898a45b1c868520436_Out_0_Boolean = Boolean_7ABB9909;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4 = Vector4_2EBA7A3B;
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[0];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[1];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[2];
        float _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float = _Property_8a66888ec47d0687ab1cb2f8abdc9da8_Out_0_Vector4[3];
        float _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float;
        Unity_Divide_float(float(1), _Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_e64179199923c58289b6aa94ea6c9178_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4 = IN.uv0;
        float4 _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4 = IN.uv2;
        float4 _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4;
        Unity_Branch_float4(_Property_f17c7bf877e64b6abdd66b1fe9f5accc_Out_0_Boolean, _UV_029e8e8198564838b9389b902a09fb22_Out_0_Vector4, _UV_7a6209af1506424fb75c81e87e42035a_Out_0_Vector4, _Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4);
        float2 _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_R_1_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_G_2_Float);
        float2 _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2 = float2(_Split_2f0f52f6ef8c0e81af0da6476402bc1f_B_3_Float, _Split_2f0f52f6ef8c0e81af0da6476402bc1f_A_4_Float);
        float2 _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_fc37bb4bf641457cbbc6e290603056ff_Out_3_Vector4.xy), _Vector2_16c15d3bbdd14b85bd48e3a6cb318af7_Out_0_Vector2, _Vector2_f8d75f54e7705083bbec539a60185577_Out_0_Vector2, _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2);
        float2 _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2;
        Unity_Branch_float2(_Property_30834f691775a0898a45b1c868520436_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_d91e2d25acd34686b562b7fe7e9d1d27_Out_3_Vector2, _Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2);
        UnitySamplerState _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_e8746b9475c94530ba35ba8019ad2ae0_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_8e5a4e8f4d52fc8aadd1f46485afc933_Out_3_Vector2) );
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        XZ_2 = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_SquareRoot_float4(float4 In, out float4 Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float(float In, out float Out)
        {
            Out = sign(In);
        }
        
        void Unity_Ceiling_float(float In, out float Out)
        {
            Out = ceil(In);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        struct Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float
        {
        };
        
        void SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(float4 Color_9AA111D3, float Vector1_FBE622A2, float Vector1_8C15C351, Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float IN, out float3 OutVector4_1)
        {
        float4 _Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4 = Color_9AA111D3;
        float4 _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4;
        Unity_SquareRoot_float4(_Property_012510d774fb7f8b860f5270dca4500f_Out_0_Vector4, _SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4);
        float _Property_a00e29241d12f983b30177515b367ec9_Out_0_Float = Vector1_FBE622A2;
        float _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float;
        Unity_Sign_float(_Property_a00e29241d12f983b30177515b367ec9_Out_0_Float, _Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float);
        float _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float;
        Unity_Add_float(_Sign_343a45ede7349283a681c6bd9998fd8e_Out_1_Float, float(1), _Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float);
        float _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float;
        Unity_Multiply_float_float(_Add_681019b8f5d3d68bb482d419c9fc61a9_Out_2_Float, 0.5, _Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float);
        float _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float;
        Unity_Ceiling_float(_Multiply_e8f4cb722712a880ac0db6c7461427f7_Out_2_Float, _Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float);
        float _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float = Vector1_8C15C351;
        float _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float;
        Unity_Multiply_float_float(_Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Property_2db1c747a05ee284a8b00076062f91a4_Out_0_Float, _Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float);
        float4 _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4;
        Unity_Lerp_float4(_SquareRoot_c2c57d0223a9538aa9240890c3cacb0c_Out_1_Vector4, (_Ceiling_95ad15988aa9b98184875fa754feae01_Out_1_Float.xxxx), (_Multiply_9564ecda5193bc8286d9ff771c9226cd_Out_2_Float.xxxx), _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4);
        float4 _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Lerp_b3cdb01fc3c5b988ac9b184943bf7c01_Out_3_Vector4, _Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4);
        OutVector4_1 = (_Multiply_39d1daff98488f8ea2cd794ad4f20926_Out_2_Vector4.xyz);
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_SquareRoot_float(float In, out float Out)
        {
            Out = sqrt(In);
        }
        
        void Unity_Sign_float3(float3 In, out float3 Out)
        {
            Out = sign(In);
        }
        
        void Unity_Clamp_float3(float3 In, float3 Min, float3 Max, out float3 Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        struct Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float
        {
        float3 WorldSpaceNormal;
        float3 WorldSpaceTangent;
        float3 WorldSpaceBiTangent;
        float3 AbsoluteWorldSpacePosition;
        half4 uv0;
        half4 uv2;
        };
        
        void SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(UnityTexture2D Texture2D_80A3D28F, float4 Vector4_82674548, float Boolean_9FF42DF6, UnitySamplerState _SamplerState, float Boolean_5ddfe6daabcc4715a44b5f34fc19becb, Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float IN, out float4 XZ_2)
        {
        float _Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean = Boolean_9FF42DF6;
        UnityTexture2D _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D = Texture2D_80A3D28F;
        float _Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
        float _Split_89ed63cb625cb3878c183d0b71c03400_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
        float _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
        float _Split_89ed63cb625cb3878c183d0b71c03400_A_4_Float = 0;
        float4 _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4;
        float3 _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3;
        float2 _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2;
        Unity_Combine_float(_Split_89ed63cb625cb3878c183d0b71c03400_R_1_Float, _Split_89ed63cb625cb3878c183d0b71c03400_B_3_Float, float(0), float(0), _Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, _Combine_cf2d04ff119ad88493f6460431765cbb_RGB_5_Vector3, _Combine_cf2d04ff119ad88493f6460431765cbb_RG_6_Vector2);
        float4 _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4 = Vector4_82674548;
        float _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[0];
        float _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[1];
        float _Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[2];
        float _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float = _Property_3fa1d6f912feb481ba60f2e55e62e746_Out_0_Vector4[3];
        float _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float;
        Unity_Divide_float(float(1), _Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float);
        float4 _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4;
        Unity_Multiply_float4_float4(_Combine_cf2d04ff119ad88493f6460431765cbb_RGBA_4_Vector4, (_Divide_c36b770dfaa0bb8f85ab27da5fd794f0_Out_2_Float.xxxx), _Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4);
        float _Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean = Boolean_5ddfe6daabcc4715a44b5f34fc19becb;
        float4 _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4 = IN.uv0;
        float4 _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4 = IN.uv2;
        float4 _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4;
        Unity_Branch_float4(_Property_058f4fba88c3437288219f1929444bf2_Out_0_Boolean, _UV_43d85b3291324c848dfbeec6adac2a71_Out_0_Vector4, _UV_36881dcaab9040168fc5215dcd00f352_Out_0_Vector4, _Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4);
        float2 _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_R_1_Float, _Split_a2e12fa5931da084b2949343a539dfd8_G_2_Float);
        float2 _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2 = float2(_Split_a2e12fa5931da084b2949343a539dfd8_B_3_Float, _Split_a2e12fa5931da084b2949343a539dfd8_A_4_Float);
        float2 _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2;
        Unity_TilingAndOffset_float((_Branch_8054d58a73be4ce1b22d48a84389ae07_Out_3_Vector4.xy), _Vector2_6845d21872714d889783b0cb707df3e9_Out_0_Vector2, _Vector2_e2e2263627c6098e96a5b5d29350ad03_Out_0_Vector2, _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2);
        float2 _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2;
        Unity_Branch_float2(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, (_Multiply_14cec4902d0a00829e4555071a1b8ad1_Out_2_Vector4.xy), _TilingAndOffset_17582d056c0b8a8dab1017d37497fe59_Out_3_Vector2, _Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2);
        UnitySamplerState _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState = _SamplerState;
        float4 _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.tex, _Property_69f1ed7efd1b494e91f626b88ab2363c_Out_0_SamplerState.samplerstate, _Property_3e01b4d2fc68d48ba3acbba9d5881e59_Out_0_Texture2D.GetTransformedUV(_Branch_1e152f3aac57448f8518bf2852c000c3_Out_3_Vector2) );
        _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4);
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.r;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.g;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.b;
        float _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_A_7_Float = _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.a;
        float2 _Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2 = float2(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_R_4_Float, _SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_G_5_Float);
        float3 _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3;
        Unity_Sign_float3(IN.WorldSpaceNormal, _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3);
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_R_1_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[0];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[1];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_B_3_Float = _Sign_3a6ebf59931cf08cb0482e0144ddac24_Out_1_Vector3[2];
        float _Split_6299d4ddcc4c74828aea40a46fdb896e_A_4_Float = 0;
        float2 _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2 = float2(_Split_6299d4ddcc4c74828aea40a46fdb896e_G_2_Float, float(1));
        float2 _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2;
        Unity_Multiply_float2_float2(_Vector2_ad6bd100e273d78fa409a30a77bfa2cc_Out_0_Vector2, _Vector2_b76cb1842101e58b9e636d49b075c612_Out_0_Vector2, _Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2);
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float = IN.WorldSpaceNormal[0];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float = IN.WorldSpaceNormal[1];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float = IN.WorldSpaceNormal[2];
        float _Split_5ed44bf2eca0868f81eb18100f49d1fa_A_4_Float = 0;
        float2 _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2 = float2(_Split_5ed44bf2eca0868f81eb18100f49d1fa_R_1_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_B_3_Float);
        float2 _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2;
        Unity_Add_float2(_Multiply_31e8db88ee20c985a9850d1a58f3282b_Out_2_Vector2, _Vector2_70e5837843f28b8b9d64cada3697bd5a_Out_0_Vector2, _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2);
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[0];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float = _Add_1145b2f896593d80aa864a34e6702562_Out_2_Vector2[1];
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_B_3_Float = 0;
        float _Split_2bc77ca2d17bd78cb2383770ce50b179_A_4_Float = 0;
        float _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float;
        Unity_Multiply_float_float(_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_B_6_Float, _Split_5ed44bf2eca0868f81eb18100f49d1fa_G_2_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float);
        float3 _Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3 = float3(_Split_2bc77ca2d17bd78cb2383770ce50b179_R_1_Float, _Multiply_ab12aea87465a78eaf7fc66c2598d266_Out_2_Float, _Split_2bc77ca2d17bd78cb2383770ce50b179_G_2_Float);
        float3 _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3;
        {
        float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
        _Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3 = TransformWorldToTangentDir(_Vector3_433840b555db308b97e9b14b6a957195_Out_0_Vector3.xyz, tangentTransform, true);
        }
        float3 _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3;
        Unity_Clamp_float3(_Transform_c7914cc45a011c89b3f53c55afb51673_Out_1_Vector3, float3(-1, -1, -1), float3(1, 1, 1), _Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3);
        float3 _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3;
        Unity_Normalize_float3(_Clamp_3837949a36b5428a82af01e7bcd29952_Out_3_Vector3, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3);
        float3 _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3;
        Unity_Branch_float3(_Property_1ef12cf3201a938993fe6a7951b0e754_Out_0_Boolean, _Normalize_09bf8a2bd0a4d38e8b97d5c674f79b44_Out_1_Vector3, (_SampleTexture2D_35ddc0da4b30e48b83ca2d39af2aba2c_RGBA_0_Vector4.xyz), _Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3);
        XZ_2 = (float4(_Branch_9eadf909a90f2f80880f8c56ecc2a91f_Out_3_Vector3, 1.0));
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_NormalBlend_float(float3 A, float3 B, out float3 Out)
        {
            Out = SafeNormalize(float3(A.rg + B.rg, A.b * B.b));
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            description.Position = IN.ObjectSpacePosition;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
            float AlphaClipThreshold;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4 = _BaseTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean = _BaseUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_f392575634df5b86b63ff6e287282b30;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv0 = IN.uv0;
            _PlanarNM_f392575634df5b86b63ff6e287282b30.uv2 = IN.uv2;
            float4 _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_9c271219f828108f958217e55cd6dc1d_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_f392575634df5b86b63ff6e287282b30, _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4 = _BaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4, _Property_4f676fce92c9378db3c3b92ae77fbff9_Out_0_Vector4, _Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_DetailMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4 = _DetailTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_9fa8573190399e8da2a843a4cab68164_R_1_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[0];
            float _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[1];
            float _Split_9fa8573190399e8da2a843a4cab68164_B_3_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[2];
            float _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float = _Property_15b8119e6611208ab7f63d3d2186e69f_Out_0_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_R_1_Float, _Split_9fa8573190399e8da2a843a4cab68164_G_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2 = float2(_Split_9fa8573190399e8da2a843a4cab68164_B_3_Float, _Split_9fa8573190399e8da2a843a4cab68164_A_4_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_4082931459a3ff87a037eaef2a66aaa4_Out_0_Vector2, _Vector2_c3028c2eeb56de8da402397ea99e167c_Out_0_Vector2, _TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.tex, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.samplerstate, _Property_6bcb6056a149a78f8b1abf38f6263513_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_8a80f78e1d800e88b7419259778fe702_Out_3_Vector2) );
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.r;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.g;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_B_6_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.b;
            float _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float = _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_R_4_Float, 2, _Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float;
            Unity_Add_float(_Multiply_6fa1a20b395b2b8d856f1ab5952a6717_Out_2_Float, float(-1), _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float = _DetailAlbedoScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float;
            Unity_Multiply_float_float(_Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Property_7d68da97cd169d8e8649255aec16158a_Out_0_Float, _Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float;
            Unity_Saturate_float(_Multiply_22973eb34d17258ba942b658037dbac6_Out_2_Float, _Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float;
            Unity_Absolute_float(_Saturate_1a2190fb1d23fd8f8d90fbbf3807c5f6_Out_1_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83;
            float3 _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3;
            SG_BlendOverlayBaseColor_acdb3dfca72bd6b42bbc35f4613331a2_float(_Multiply_e8f124a9d8fb0d81a02cdf2b927e4b9d_Out_2_Vector4, _Add_26a33ee766ff6f81b0a3119948ca39d9_Out_2_Float, _Absolute_37f802d85fcade8c905c4fa9a53fde15_Out_1_Float, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83, _BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverBaseColorMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4 = _CoverTilingOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean = _CoverUsePlanarUV;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_ad1db3524021ac898447cb6f6daa4180;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv0 = IN.uv0;
            _PlanarNM_ad1db3524021ac898447cb6f6daa4180.uv2 = IN.uv2;
            float4 _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_5ca167b35599f78ab3722ec527327841_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_ad1db3524021ac898447cb6f6daa4180, _PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4 = _CoverBaseColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4;
            Unity_Multiply_float4_float4(_PlanarNM_ad1db3524021ac898447cb6f6daa4180_XZ_2_Vector4, _Property_b34e94e0b1171480b3e35ff7f4793d7c_Out_0_Vector4, _Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskA);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4 = IN.uv0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.tex, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.samplerstate, _Property_0889b6f63c850f84a7f74b56d5a867e1_Out_0_Texture2D.GetTransformedUV((_UV_d872d9d5578f118fbf39c79c998654c1_Out_0_Vector4.xy)) );
            float _SampleTexture2D_79111e5af287b084822e60563309a632_R_4_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.r;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_G_5_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.g;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_B_6_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.b;
            float _SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float = _SampleTexture2D_79111e5af287b084822e60563309a632_RGBA_0_Vector4.a;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c022d8255938838aa73170f05c226269_Out_0_Float = _CoverMaskPower;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_79111e5af287b084822e60563309a632_A_7_Float, _Property_c022d8255938838aa73170f05c226269_Out_0_Float, _Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            Unity_Clamp_float(_Multiply_8d55fbadf515e983b2014431bc999240_Out_2_Float, float(0), float(1), _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2 = float2(_SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_A_7_Float, _SampleTexture2D_fe4f14564e06b98ea6d57c793c90c503_G_5_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Vector2_05eaf4ceda4b928e95e7c3340cc0344d_Out_0_Vector2, float2(2, 2), _Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2;
            Unity_Add_float2(_Multiply_7b223ce3c207648b9a10dfae6e45c866_Out_2_Vector2, float2(-1, -1), _Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float = _DetailNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Add_09d4347724b7f38d95e4e08b3be7b367_Out_2_Vector2, (_Property_869b2f5fc76cf9838e2f385a6909872a_Out_0_Float.xx), _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_492de324af96c482b50573c79f9fb6a0_R_1_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[0];
            float _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float = _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2[1];
            float _Split_492de324af96c482b50573c79f9fb6a0_B_3_Float = 0;
            float _Split_492de324af96c482b50573c79f9fb6a0_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float;
            Unity_DotProduct_float2(_Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _Multiply_27bc0e7dc801db8a918eb810f0be3a0b_Out_2_Vector2, _DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float;
            Unity_Saturate_float(_DotProduct_0c581f3b2e7bb184968b11cb5c759fe8_Out_2_Float, _Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float;
            Unity_OneMinus_float(_Saturate_e5fd3306186d8785bd28234db73afeb3_Out_1_Float, _OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float;
            Unity_SquareRoot_float(_OneMinus_4d6394405e9bda87949b2c9c3a4019a3_Out_1_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3 = float3(_Split_492de324af96c482b50573c79f9fb6a0_R_1_Float, _Split_492de324af96c482b50573c79f9fb6a0_G_2_Float, _SquareRoot_e96cea4d91559681aeee958b56866c27_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BaseNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv0 = IN.uv0;
            _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540.uv2 = IN.uv2;
            float4 _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_8a90312e70ed1e8b9b260bd82e32fabc_Out_0_Texture2D, _Property_5dd399d9c32638849a0ec9b8ed107978_Out_0_Vector4, _Property_d8a00a213dd86c8da0f38dbfaef5f462_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540, _PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float = _BaseNormalScale;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_c9d795759e44b68fa07f79d1e8eea540_XZ_2_Vector4.xyz), _Property_bb36a4991d4470879fefd350972302cc_Out_0_Float, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3;
            Unity_NormalBlend_float(_Vector3_ce76b237ae4e9683b8b55c0a907191a6_Out_0_Vector3, _NormalStrength_38970ce5c8d4728f9515af30844360a0_Out_2_Vector3, _NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverNormalMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceNormal = IN.WorldSpaceNormal;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceTangent = IN.WorldSpaceTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.WorldSpaceBiTangent = IN.WorldSpaceBiTangent;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv0 = IN.uv0;
            _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3.uv2 = IN.uv2;
            float4 _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4;
            SG_PlanarNMn_1b93a87456f9d4c419321d0cd92bd6c8_float(_Property_f3761223bb08d480b7f2b03d29a43be7_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3, _PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float = _CoverNormalBlendHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3;
            Unity_NormalStrength_float((_PlanarNMn_e4f2ff32e4576b8289242c9ead282bf3_XZ_2_Vector4.xyz), _Property_a3ee26be457ec08bb39277804e093218_Out_0_Float, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_R_1_Float = IN.WorldSpaceNormal[0];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float = IN.WorldSpaceNormal[1];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_B_3_Float = IN.WorldSpaceNormal[2];
            float _Split_38ef42f5d0d8cf8d8db629ca8987130b_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float = _Cover_Amount;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float = _Cover_Amount_Grow_Speed;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float;
            Unity_Subtract_float(float(4), _Property_edcaf6408fcc6684914fc80e5d6ef526_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float;
            Unity_Divide_float(_Property_c3d13513263d2586927725ad1f1cdddf_Out_0_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float;
            Unity_Absolute_float(_Divide_a44418292c5ea28ab465a4ff03a370e3_Out_2_Float, _Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float;
            Unity_Power_float(_Absolute_a19b3b78284764869efb4ea4da579363_Out_1_Float, _Subtract_9448303ec313538b9e0a15ee279e37ca_Out_2_Float, _Power_c11fc5724f830485a9c4df249a854571_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float;
            Unity_Clamp_float(_Power_c11fc5724f830485a9c4df249a854571_Out_2_Float, float(0), float(2), _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float;
            Unity_Multiply_float_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float;
            Unity_Saturate_float(_Multiply_220683476ffbff888bb145363a8364ad_Out_2_Float, _Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float;
            Unity_Clamp_float(_Split_38ef42f5d0d8cf8d8db629ca8987130b_G_2_Float, float(0), float(0.9999), _Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_89633a46f34e1f8996557a9178d78478_Out_0_Float = _Cover_Max_Angle;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float;
            Unity_Divide_float(_Property_89633a46f34e1f8996557a9178d78478_Out_0_Float, float(45), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float;
            Unity_OneMinus_float(_Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float;
            Unity_Subtract_float(_Clamp_6a96ea5404308383bfc966cbaa20bbe7_Out_3_Float, _OneMinus_464b48740527828e80ad1d0ef7324393_Out_1_Float, _Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float;
            Unity_Clamp_float(_Subtract_e611ace8a3ae9a8a987863c202bd2f40_Out_2_Float, float(0), float(2), _Clamp_67dcc607b6da848097d3412324311616_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float;
            Unity_Divide_float(float(1), _Divide_1573b6a346be178d988d7c16f8a7bd72_Out_2_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_67dcc607b6da848097d3412324311616_Out_3_Float, _Divide_7e924b680020b8839e898e52794f5c99_Out_2_Float, _Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float;
            Unity_Absolute_float(_Multiply_ab6adee1f97e4e84978da832e173c3ff_Out_2_Float, _Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float = _CoverHardness;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float;
            Unity_Power_float(_Absolute_34bababe8152948b86a1aa5843f36830_Out_1_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_f8753bb05d835089bda460d144f93c48_Out_0_Float = _Cover_Min_Height;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float;
            Unity_OneMinus_float(_Property_f8753bb05d835089bda460d144f93c48_Out_0_Float, _OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_c66e04f85a2a7f87884040056599e65d_R_1_Float = IN.AbsoluteWorldSpacePosition[0];
            float _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float = IN.AbsoluteWorldSpacePosition[1];
            float _Split_c66e04f85a2a7f87884040056599e65d_B_3_Float = IN.AbsoluteWorldSpacePosition[2];
            float _Split_c66e04f85a2a7f87884040056599e65d_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float;
            Unity_Add_float(_OneMinus_f00cb30ae8f05a81b2de40d9e504fdd6_Out_1_Float, _Split_c66e04f85a2a7f87884040056599e65d_G_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, float(1), _Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float;
            Unity_Clamp_float(_Add_3723f639f46d838b951924a0c5bf23c0_Out_2_Float, float(0), float(1), _Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float = _Cover_Min_Height_Blending;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float;
            Unity_Add_float(_Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Property_45333ec1e1d1df89ad4ca1b4d2582c7f_Out_0_Float, _Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float;
            Unity_Divide_float(_Add_31891bcc3c3e858da1053de33c432ac4_Out_2_Float, _Add_4a8030434fffd38b802c0768e829faf5_Out_2_Float, _Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float;
            Unity_OneMinus_float(_Divide_c4149bdcbc73d186ba5f205dd37258a3_Out_2_Float, _OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float;
            Unity_Add_float(_OneMinus_9c962cb8fa9b3f81a45a24dba5688f7e_Out_1_Float, float(-0.5), _Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float;
            Unity_Clamp_float(_Add_5909635fb2caf188a8f0da78e2b1ad59_Out_2_Float, float(0), float(1), _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float;
            Unity_Add_float(_Clamp_1a2194bb4d160981b1f98b30c7dcfab8_Out_3_Float, _Clamp_a36bf92e4148fc81abdfa47745edb1b4_Out_3_Float, _Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float;
            Unity_Clamp_float(_Add_270d0a0652e7ce8da5db59c11f3fee84_Out_2_Float, float(0), float(1), _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float;
            Unity_Multiply_float_float(_Power_d9e363a580980f818cba9f7a2e4ae8ee_Out_2_Float, _Clamp_77ddf881ef9bc38d95c9bdb3029d4e9c_Out_3_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float;
            Unity_Multiply_float_float(_Saturate_11318a9a94ab358eb5d245d9d1c938bf_Out_1_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3;
            Unity_Lerp_float3(_NormalBlend_53a2c47df3f58b8382c294e99089234d_Out_2_Vector3, _NormalStrength_2452ddd0fbdf8187b647680981e1870a_Out_2_Vector3, (_Multiply_69153184852a71808f95d69abc8787c1_Out_2_Float.xxx), _Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3;
            {
                float3x3 tangentTransform = float3x3(IN.WorldSpaceTangent, IN.WorldSpaceBiTangent, IN.WorldSpaceNormal);
                _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3 = TransformTangentToWorldDir(_Lerp_54797f23392e7f85b12e6f8ba6f6eed5_Out_3_Vector3.xyz, tangentTransform, true).xyz;
            }
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_R_1_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[0];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[1];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_B_3_Float = _Transform_de548b6fd9ef5f8db95e8ff92d31d9cf_Out_1_Vector3[2];
            float _Split_58b2f6bfc53dc889a7697c4771e9ab27_A_4_Float = 0;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float;
            Unity_Multiply_float_float(_Split_58b2f6bfc53dc889a7697c4771e9ab27_G_2_Float, _Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_dffeaf690ee513849c81022ca2b889c2_Out_3_Float, _Property_54808d8c0b24cb86be1ba22163b0da6c_Out_0_Float, _Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_3e3235c279f23b8998f5afd2abc77e84_Out_2_Float, _Multiply_21b6a5fe5c050187887a06b36c41186b_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_6d1a96815e032982a35d881dc488ec65_Out_2_Float, _Multiply_3c5ada7dc2d5fd88b6988da27768a0e6_Out_2_Float, _Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            UnityTexture2D _Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_CoverMaskMap);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            Bindings_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float _PlanarNM_36e64648ad8a6a849bc794b8693519da;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.AbsoluteWorldSpacePosition = IN.AbsoluteWorldSpacePosition;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv0 = IN.uv0;
            _PlanarNM_36e64648ad8a6a849bc794b8693519da.uv2 = IN.uv2;
            float4 _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4;
            SG_PlanarNM_c0f081da9c567704ea36e7dd38cedcf6_float(_Property_40bdd102b2df36808dc9c2ce4a3e6e40_Out_0_Texture2D, _Property_9e7b9b518354a78885df253506f363e7_Out_0_Vector4, _Property_9c5dec0c054bb087bf49d2b38157e2b7_Out_0_Boolean, UnityBuildSamplerStateStruct(SamplerState_Linear_Repeat_Aniso8), 1, _PlanarNM_36e64648ad8a6a849bc794b8693519da, _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_198ec92f3e753d8a9ad50db7d6527324_R_1_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[0];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_G_2_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[1];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[2];
            float _Split_198ec92f3e753d8a9ad50db7d6527324_A_4_Float = _PlanarNM_36e64648ad8a6a849bc794b8693519da_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float = _CoverHeightMapMin;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float = _CoverHeightMapMax;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2 = float2(_Property_6f8c06f4e98f858c82689a4208853de6_Out_0_Float, _Property_c436a1a494d9768aaf2540b81cd6a00a_Out_0_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_277f22c36084858981418fa95133a562_Out_0_Float = _CoverHeightMapOffset;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float2 _Add_53997153562831859cc7b582f3068877_Out_2_Vector2;
            Unity_Add_float2(_Vector2_7c3530946c82bc88b9ea8dc226615f17_Out_0_Vector2, (_Property_277f22c36084858981418fa95133a562_Out_0_Float.xx), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float;
            Unity_Remap_float(_Split_198ec92f3e753d8a9ad50db7d6527324_B_3_Float, float2 (0, 1), _Add_53997153562831859cc7b582f3068877_Out_2_Vector2, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_a04d47fea55cc083ac1d309be428db0b_Out_2_Float, _Remap_1e6c6b6ebbe6f780bbe21a42b8a3209d_Out_3_Float, _Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float = IN.VertexColor[0];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float = IN.VertexColor[1];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_B_3_Float = IN.VertexColor[2];
            float _Split_52df3b61d8bcb7869eecad2eb62ea8c8_A_4_Float = IN.VertexColor[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float;
            Unity_Multiply_float_float(_Multiply_c05e6e2a89fb5288920dcb35162e554e_Out_2_Float, _Split_52df3b61d8bcb7869eecad2eb62ea8c8_G_2_Float, _Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float;
            Unity_Saturate_float(_Multiply_e1a328e2f7525c8db6c2e73026734428_Out_2_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            Unity_Multiply_float_float(_Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float, _Saturate_c28a36ce3fac388ebbd8aa8d85853d6d_Out_1_Float, _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            #if defined(_USEDYNAMICCOVERTSTATICMASKF_ON)
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Multiply_15279359e14bb78da9519b8088ceefbe_Out_2_Float;
            #else
            float _UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float = _Clamp_55025fe224a63e8e864487907e15ec9b_Out_3_Float;
            #endif
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3;
            Unity_Lerp_float3(_BlendOverlayBaseColor_a7338cc006791f8b850b853ab1ef6a83_OutVector4_1_Vector3, (_Multiply_78cfbe31164b178c9c12dd8c7ded60b4_Out_2_Vector4.xyz), (_UseDynamicCoverTStaticMaskF_2f09f07811a846828a8aa6bb392603f6_Out_0_Float.xxx), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float4 _Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4 = _WetColor;
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3;
            Unity_Multiply_float3_float3((_Property_e687576468764d85b6b46dca96d8a8e3_Out_0_Vector4.xyz), _Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float;
            Unity_OneMinus_float(_Split_52df3b61d8bcb7869eecad2eb62ea8c8_R_1_Float, _OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float3 _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            Unity_Lerp_float3(_Lerp_025015016dabe58f98f723728a7969a1_Out_3_Vector3, _Multiply_d3a88e4e3722288cb2a20a0b14ff85ac_Out_2_Vector3, (_OneMinus_9b3acf530f01a9808c7dfe2999903bb8_Out_1_Float.xxx), _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3);
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_R_1_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[0];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_G_2_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[1];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_B_3_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[2];
            float _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float = _PlanarNM_f392575634df5b86b63ff6e287282b30_XZ_2_Vector4[3];
            #endif
            #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
            float _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float = _AlphaCutoff;
            #endif
            surface.BaseColor = _Lerp_c4f85e60c5af788ebf03d7cf656bb00b_Out_3_Vector3;
            surface.Alpha = _Split_ccf0a3426f1aea83b9e7f8b1c2f7910b_A_4_Float;
            surface.AlphaClipThreshold = _Property_35e1d35e56d12682ac2fecfd3f38259a_Out_0_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceNormal =                          input.normalOS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpaceTangent =                         input.tangentOS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.ObjectSpacePosition =                        input.positionOS;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // must use interpolated tangent, bitangent and normal before they are normalized in the pixel shader.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 unnormalizedNormalWS = input.normalWS;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        const float renormFactor = 1.0 / length(unnormalizedNormalWS);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // use bitangent on the fly like in hdrp
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // IMPORTANT! If we ever support Flip on double sided materials ensure bitangent and tangent are NOT flipped.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float crossSign = (input.tangentWS.w > 0.0 ? 1.0 : -1.0)* GetOddNegativeScale();
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        float3 bitang = crossSign * cross(input.normalWS.xyz, input.tangentWS.xyz);
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceNormal = renormFactor * input.normalWS.xyz;      // we want a unit length Normal Vector node in shader graph
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // to pr               eserve mikktspace compliance we use same scale renormFactor as was used on the normal.
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        // This                is explained in section 2.2 in "surface gradient based bump mapping framework"
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceTangent = renormFactor * input.tangentWS.xyz;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.WorldSpaceBiTangent = renormFactor * bitang;
        #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.AbsoluteWorldSpacePosition = GetAbsolutePositionWS(input.positionWS);
        #endif
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv0 = input.texCoord0;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.uv2 = input.texCoord2;
        #endif
        
        #if defined(KEYWORD_PERMUTATION_0) || defined(KEYWORD_PERMUTATION_1)
        output.VertexColor = input.color;
        #endif
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}