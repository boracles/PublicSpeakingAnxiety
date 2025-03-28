﻿Shader "NatureManufacture/URP/Foliage/Bark"
{
    Properties
    {
        _TrunkBaseColor("Trunk Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_TrunkBaseColorMap("Trunk Base Map", 2D) = "white" {}
        _TrunkTilingOffset("Trunk Tiling and Offset", Vector) = (1, 1, 0, 0)
        [Normal][NoScaleOffset]_TrunkNormalMap("Trunk Normal Map", 2D) = "bump" {}
        _TrunkNormalScale("Trunk Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_TrunkMaskMap("Trunk Mask Map MT(R) AO(G) SM(A)", 2D) = "white" {}
        _TrunkMetallic("Trunk Metallic", Range(0, 1)) = 1
        _TrunkAORemapMin("Trunk AO Remap Min", Range(0, 1)) = 0
        _TrunkAORemapMax("Trunk AO Remap Max", Range(0, 1)) = 1
        _TrunkSmoothnessRemapMin("Trunk Smoothness Remap Min", Range(0, 1)) = 0
        _TrunkSmoothnessRemapMax("Trunk Smoothness Remap Max", Range(0, 1)) = 1
        [NoScaleOffset]_LayerMask("Bark Blend Mask(A)", 2D) = "black" {}
        _BarkBlendMaskTilingOffset("Bark Blend Mask Tiling Offset", Vector) = (1, 1, 0, 0)
        _BarkBaseColor("Bark Base Color", Color) = (1, 1, 1, 0)
        [NoScaleOffset]_BarkBaseColorMap("Bark Base Map", 2D) = "white" {}
        [ToggleUI]_BarkUseUV3("Bark Use UV3", Float) = 1
        _BarkTilingOffset("Bark Tiling and Offset", Vector) = (1, 1, 0, 0)
        [Normal][NoScaleOffset]_BarkNormalMap("Bark Normal Map", 2D) = "bump" {}
        _BarkNormalScale("Bark Normal Scale", Range(0, 8)) = 1
        [NoScaleOffset]_BarkMaskMap("Bark Mask Map MT(R) AO(G) SM(A)", 2D) = "white" {}
        _BarkMetallic("Bark Metallic", Range(0, 1)) = 1
        _BarkSmoothnessRemapMin("Bark Smoothness Remap Min", Range(0, 1)) = 0
        _BarkSmoothnessRemapMax("Bark Smoothness Remap Max", Range(0, 1)) = 1
        _BarkAORemapMin("Bark AO Remap Min", Range(0, 1)) = 0
        _BarkAORemapMax("Bark AO Remap Max", Range(0, 1)) = 1
        _Stiffness("Wind Stiffness", Float) = 1
        _InitialBend("Wind Initial Bend", Float) = 0
        _Drag("Wind Drag", Float) = 1
        _HeightDrag("Wind Drag Height Offset", Float) = 0
        _NewNormal("Mesh Normal Multiply", Vector) = (0, 0, 0, 0)
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
            "Queue"="Geometry"
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
        Cull Back
        Blend One Zero
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 texCoord3 : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
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
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkBaseColorMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.tex, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.samplerstate, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_R_4_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.r;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_G_5_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.g;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_B_6_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.b;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_A_7_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.a;
            float4 _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4 = _TrunkBaseColor;
            float4 _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4, _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4, _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4);
            UnityTexture2D _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkBaseColorMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.tex, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.samplerstate, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_R_4_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_G_5_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_B_6_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_A_7_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.a;
            float4 _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4 = _BarkBaseColor;
            float4 _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4, _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float4 _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxxx), _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4);
            UnityTexture2D _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkNormalMap);
            float4 _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.tex, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.samplerstate, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4);
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_R_4_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.r;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_G_5_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.g;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_B_6_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.b;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_A_7_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.a;
            float _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float = _TrunkNormalScale;
            float3 _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.xyz), _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float, _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3);
            UnityTexture2D _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkNormalMap);
            float4 _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.tex, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.samplerstate, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4);
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_R_4_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.r;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_G_5_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.g;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_B_6_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.b;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_A_7_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.a;
            float _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float = _BarkNormalScale;
            float3 _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.xyz), _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3);
            float3 _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
            Unity_Lerp_float3(_NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxx), _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3);
            UnityTexture2D _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkMaskMap);
            float4 _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.tex, _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.samplerstate, _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_R_4_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.r;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_G_5_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.g;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_B_6_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.b;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_A_7_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.a;
            float _Property_d1f2831d91baa68fa25a43686b68e209_Out_0_Float = _TrunkMetallic;
            float _Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_R_4_Float, _Property_d1f2831d91baa68fa25a43686b68e209_Out_0_Float, _Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float);
            float _Property_a10a16d5fbc22682919425317aca698d_Out_0_Float = _TrunkAORemapMin;
            float _Property_6b437e51bde09c8a9eaa1cf0315874d3_Out_0_Float = _TrunkAORemapMax;
            float2 _Vector2_65b021cb16cf6083a59157fdfea46327_Out_0_Vector2 = float2(_Property_a10a16d5fbc22682919425317aca698d_Out_0_Float, _Property_6b437e51bde09c8a9eaa1cf0315874d3_Out_0_Float);
            float _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_G_5_Float, float2 (0, 1), _Vector2_65b021cb16cf6083a59157fdfea46327_Out_0_Vector2, _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float);
            float _Property_93db442d827a328c9498fd644c94ec7b_Out_0_Float = _TrunkSmoothnessRemapMin;
            float _Property_4959de9b98581488b91bff2b96859515_Out_0_Float = _TrunkSmoothnessRemapMax;
            float2 _Vector2_2365f5e8b9020a85b6bc1a4204523fdb_Out_0_Vector2 = float2(_Property_93db442d827a328c9498fd644c94ec7b_Out_0_Float, _Property_4959de9b98581488b91bff2b96859515_Out_0_Float);
            float _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_A_7_Float, float2 (0, 1), _Vector2_2365f5e8b9020a85b6bc1a4204523fdb_Out_0_Vector2, _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float);
            float3 _Vector3_2b73cbb46cc09a86817650bdf3f108d5_Out_0_Vector3 = float3(_Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float, _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float, _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float);
            UnityTexture2D _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkMaskMap);
            float4 _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.tex, _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.samplerstate, _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_R_4_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.r;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_G_5_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.g;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_B_6_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.b;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_A_7_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.a;
            float _Property_3e62578c4dd29e8a9e4ea698bfbb55db_Out_0_Float = _BarkMetallic;
            float _Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_R_4_Float, _Property_3e62578c4dd29e8a9e4ea698bfbb55db_Out_0_Float, _Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float);
            float _Property_99747f684fd87f88a2d904eb4243680a_Out_0_Float = _BarkAORemapMin;
            float _Property_f646f9cb90e8fc8b9bf8ba27330df5e8_Out_0_Float = _BarkAORemapMax;
            float2 _Vector2_c4398c0d00344989afa8fec5d963bb6b_Out_0_Vector2 = float2(_Property_99747f684fd87f88a2d904eb4243680a_Out_0_Float, _Property_f646f9cb90e8fc8b9bf8ba27330df5e8_Out_0_Float);
            float _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_G_5_Float, float2 (0, 1), _Vector2_c4398c0d00344989afa8fec5d963bb6b_Out_0_Vector2, _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float);
            float _Property_fd1021b1bf1dba8f9e94da08ddc09062_Out_0_Float = _BarkSmoothnessRemapMin;
            float _Property_942dd17ce976268d80ad0d08bb2a667b_Out_0_Float = _BarkSmoothnessRemapMax;
            float2 _Vector2_e34524416dd31881a1d82856e88c603d_Out_0_Vector2 = float2(_Property_fd1021b1bf1dba8f9e94da08ddc09062_Out_0_Float, _Property_942dd17ce976268d80ad0d08bb2a667b_Out_0_Float);
            float _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_A_7_Float, float2 (0, 1), _Vector2_e34524416dd31881a1d82856e88c603d_Out_0_Vector2, _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float);
            float3 _Vector3_d41ecbf099f0b78ead5f8d44ebb9c1ef_Out_0_Vector3 = float3(_Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float, _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float, _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float);
            float3 _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3;
            Unity_Lerp_float3(_Vector3_2b73cbb46cc09a86817650bdf3f108d5_Out_0_Vector3, _Vector3_d41ecbf099f0b78ead5f8d44ebb9c1ef_Out_0_Vector3, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxx), _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3);
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_R_1_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[0];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_G_2_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[1];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_B_3_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[2];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_A_4_Float = 0;
            surface.BaseColor = (_Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4.xyz);
            surface.NormalTS = _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_d40647f4e6f62d8c840fb4eafb1da584_R_1_Float;
            surface.Smoothness = _Split_d40647f4e6f62d8c840fb4eafb1da584_B_3_Float;
            surface.Occlusion = _Split_d40647f4e6f62d8c840fb4eafb1da584_G_2_Float;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 texCoord3 : INTERP7;
             float4 fogFactorAndVertexLight : INTERP8;
             float3 positionWS : INTERP9;
             float3 normalWS : INTERP10;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
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
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
        {
            Out = lerp(A, B, T);
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
            float Smoothness;
            float Occlusion;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkBaseColorMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.tex, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.samplerstate, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_R_4_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.r;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_G_5_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.g;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_B_6_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.b;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_A_7_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.a;
            float4 _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4 = _TrunkBaseColor;
            float4 _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4, _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4, _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4);
            UnityTexture2D _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkBaseColorMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.tex, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.samplerstate, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_R_4_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_G_5_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_B_6_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_A_7_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.a;
            float4 _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4 = _BarkBaseColor;
            float4 _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4, _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float4 _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxxx), _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4);
            UnityTexture2D _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkNormalMap);
            float4 _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.tex, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.samplerstate, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4);
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_R_4_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.r;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_G_5_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.g;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_B_6_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.b;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_A_7_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.a;
            float _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float = _TrunkNormalScale;
            float3 _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.xyz), _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float, _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3);
            UnityTexture2D _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkNormalMap);
            float4 _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.tex, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.samplerstate, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4);
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_R_4_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.r;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_G_5_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.g;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_B_6_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.b;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_A_7_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.a;
            float _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float = _BarkNormalScale;
            float3 _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.xyz), _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3);
            float3 _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
            Unity_Lerp_float3(_NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxx), _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3);
            UnityTexture2D _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkMaskMap);
            float4 _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.tex, _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.samplerstate, _Property_56844cd5a27a8b8ba71ac22004d286c0_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_R_4_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.r;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_G_5_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.g;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_B_6_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.b;
            float _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_A_7_Float = _SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_RGBA_0_Vector4.a;
            float _Property_d1f2831d91baa68fa25a43686b68e209_Out_0_Float = _TrunkMetallic;
            float _Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_R_4_Float, _Property_d1f2831d91baa68fa25a43686b68e209_Out_0_Float, _Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float);
            float _Property_a10a16d5fbc22682919425317aca698d_Out_0_Float = _TrunkAORemapMin;
            float _Property_6b437e51bde09c8a9eaa1cf0315874d3_Out_0_Float = _TrunkAORemapMax;
            float2 _Vector2_65b021cb16cf6083a59157fdfea46327_Out_0_Vector2 = float2(_Property_a10a16d5fbc22682919425317aca698d_Out_0_Float, _Property_6b437e51bde09c8a9eaa1cf0315874d3_Out_0_Float);
            float _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_G_5_Float, float2 (0, 1), _Vector2_65b021cb16cf6083a59157fdfea46327_Out_0_Vector2, _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float);
            float _Property_93db442d827a328c9498fd644c94ec7b_Out_0_Float = _TrunkSmoothnessRemapMin;
            float _Property_4959de9b98581488b91bff2b96859515_Out_0_Float = _TrunkSmoothnessRemapMax;
            float2 _Vector2_2365f5e8b9020a85b6bc1a4204523fdb_Out_0_Vector2 = float2(_Property_93db442d827a328c9498fd644c94ec7b_Out_0_Float, _Property_4959de9b98581488b91bff2b96859515_Out_0_Float);
            float _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_2b272d60f47c9b88b68dbba296da07d3_A_7_Float, float2 (0, 1), _Vector2_2365f5e8b9020a85b6bc1a4204523fdb_Out_0_Vector2, _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float);
            float3 _Vector3_2b73cbb46cc09a86817650bdf3f108d5_Out_0_Vector3 = float3(_Multiply_9d43c538cd621984a54afc1bb8a822ca_Out_2_Float, _Remap_b335490fdd83b5858f8ffc2d07b8762d_Out_3_Float, _Remap_2a187573dc9ec18ab73eeb8e794202a9_Out_3_Float);
            UnityTexture2D _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkMaskMap);
            float4 _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.tex, _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.samplerstate, _Property_cf0c533e4c842f8eab303dd12828a952_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_R_4_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.r;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_G_5_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.g;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_B_6_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.b;
            float _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_A_7_Float = _SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_RGBA_0_Vector4.a;
            float _Property_3e62578c4dd29e8a9e4ea698bfbb55db_Out_0_Float = _BarkMetallic;
            float _Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float;
            Unity_Multiply_float_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_R_4_Float, _Property_3e62578c4dd29e8a9e4ea698bfbb55db_Out_0_Float, _Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float);
            float _Property_99747f684fd87f88a2d904eb4243680a_Out_0_Float = _BarkAORemapMin;
            float _Property_f646f9cb90e8fc8b9bf8ba27330df5e8_Out_0_Float = _BarkAORemapMax;
            float2 _Vector2_c4398c0d00344989afa8fec5d963bb6b_Out_0_Vector2 = float2(_Property_99747f684fd87f88a2d904eb4243680a_Out_0_Float, _Property_f646f9cb90e8fc8b9bf8ba27330df5e8_Out_0_Float);
            float _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_G_5_Float, float2 (0, 1), _Vector2_c4398c0d00344989afa8fec5d963bb6b_Out_0_Vector2, _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float);
            float _Property_fd1021b1bf1dba8f9e94da08ddc09062_Out_0_Float = _BarkSmoothnessRemapMin;
            float _Property_942dd17ce976268d80ad0d08bb2a667b_Out_0_Float = _BarkSmoothnessRemapMax;
            float2 _Vector2_e34524416dd31881a1d82856e88c603d_Out_0_Vector2 = float2(_Property_fd1021b1bf1dba8f9e94da08ddc09062_Out_0_Float, _Property_942dd17ce976268d80ad0d08bb2a667b_Out_0_Float);
            float _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float;
            Unity_Remap_float(_SampleTexture2D_5e41186a3f77dd8cb52f40bb441a8fe8_A_7_Float, float2 (0, 1), _Vector2_e34524416dd31881a1d82856e88c603d_Out_0_Vector2, _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float);
            float3 _Vector3_d41ecbf099f0b78ead5f8d44ebb9c1ef_Out_0_Vector3 = float3(_Multiply_3ee5826ca5f49f88a98034264fd62503_Out_2_Float, _Remap_6a4a6dd39e6f1081955112d66f480f62_Out_3_Float, _Remap_36505decef60d3858196b2dc5d1c341c_Out_3_Float);
            float3 _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3;
            Unity_Lerp_float3(_Vector3_2b73cbb46cc09a86817650bdf3f108d5_Out_0_Vector3, _Vector3_d41ecbf099f0b78ead5f8d44ebb9c1ef_Out_0_Vector3, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxx), _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3);
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_R_1_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[0];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_G_2_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[1];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_B_3_Float = _Lerp_44874cfb08f04183bddec5ab51abe087_Out_3_Vector3[2];
            float _Split_d40647f4e6f62d8c840fb4eafb1da584_A_4_Float = 0;
            surface.BaseColor = (_Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4.xyz);
            surface.NormalTS = _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = _Split_d40647f4e6f62d8c840fb4eafb1da584_R_1_Float;
            surface.Smoothness = _Split_d40647f4e6f62d8c840fb4eafb1da584_B_3_Float;
            surface.Occlusion = _Split_d40647f4e6f62d8c840fb4eafb1da584_G_2_Float;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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
        Cull Back
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
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
        Cull Back
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 WorldSpaceNormal;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
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
        
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
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
        Cull Back
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
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
        Cull Back
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
        #pragma multi_compile _ LOD_FADE_CROSSFADE
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float4 texCoord3 : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_NormalStrength_float(float3 In, float Strength, out float3 Out)
        {
            Out = float3(In.rg * Strength, lerp(1, In.b, saturate(Strength)));
        }
        
        void Unity_Lerp_float3(float3 A, float3 B, float3 T, out float3 Out)
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkNormalMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.tex, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.samplerstate, _Property_ac96525057b9c781ae18be549551cc36_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4);
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_R_4_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.r;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_G_5_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.g;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_B_6_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.b;
            float _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_A_7_Float = _SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.a;
            float _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float = _TrunkNormalScale;
            float3 _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_54d81ba970bfe989b5748de8f2ca3539_RGBA_0_Vector4.xyz), _Property_276434bcaa4a4480ab798a55ab76ec3f_Out_0_Float, _NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3);
            UnityTexture2D _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkNormalMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.tex, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.samplerstate, _Property_689f72d4a6ac0e8eaa3906fa68593fc7_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4);
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_R_4_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.r;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_G_5_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.g;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_B_6_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.b;
            float _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_A_7_Float = _SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.a;
            float _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float = _BarkNormalScale;
            float3 _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3;
            Unity_NormalStrength_float((_SampleTexture2D_1c4a321efaf5268bae88e51f7288287e_RGBA_0_Vector4.xyz), _Property_672af66b5cf9e48790d3d9a677f53b0f_Out_0_Float, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float3 _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
            Unity_Lerp_float3(_NormalStrength_701ea5c499a55b85b502ac8a25ea9138_Out_2_Vector3, _NormalStrength_81a324dedf3885809fc9a9869cd7e92d_Out_2_Vector3, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxx), _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3);
            surface.NormalTS = _Lerp_5d0113d39b95a9838b4b587ec3988141_Out_3_Vector3;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define VARYINGS_NEED_TEXCOORD3
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float4 texCoord3 : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkBaseColorMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.tex, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.samplerstate, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_R_4_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.r;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_G_5_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.g;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_B_6_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.b;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_A_7_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.a;
            float4 _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4 = _TrunkBaseColor;
            float4 _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4, _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4, _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4);
            UnityTexture2D _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkBaseColorMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.tex, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.samplerstate, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_R_4_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_G_5_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_B_6_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_A_7_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.a;
            float4 _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4 = _BarkBaseColor;
            float4 _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4, _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float4 _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxxx), _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4);
            surface.BaseColor = (_Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
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
        Cull Back
        
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
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkBaseColorMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.tex, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.samplerstate, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_R_4_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.r;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_G_5_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.g;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_B_6_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.b;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_A_7_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.a;
            float4 _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4 = _TrunkBaseColor;
            float4 _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4, _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4, _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4);
            UnityTexture2D _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkBaseColorMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.tex, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.samplerstate, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_R_4_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_G_5_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_B_6_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_A_7_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.a;
            float4 _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4 = _BarkBaseColor;
            float4 _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4, _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float4 _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxxx), _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4);
            surface.BaseColor = (_Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4.xyz);
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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
        Cull Back
        Blend One Zero
        ZTest LEqual
        ZWrite On
        
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
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD3
        #define ATTRIBUTES_NEED_COLOR
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD3
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
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv3 : TEXCOORD3;
             float4 color : COLOR;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0;
             float4 texCoord3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float4 uv0;
             float4 uv3;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 WorldSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 VertexColor;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord3 : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord3.xyzw = input.texCoord3;
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
            output.texCoord3 = input.texCoord3.xyzw;
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
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _TrunkBaseColor;
        float4 _TrunkBaseColorMap_TexelSize;
        float4 _TrunkTilingOffset;
        float4 _TrunkNormalMap_TexelSize;
        float _TrunkNormalScale;
        float4 _TrunkMaskMap_TexelSize;
        float _TrunkMetallic;
        float _TrunkAORemapMin;
        float _TrunkAORemapMax;
        float _TrunkSmoothnessRemapMin;
        float _TrunkSmoothnessRemapMax;
        float4 _LayerMask_TexelSize;
        float4 _BarkBlendMaskTilingOffset;
        float4 _BarkBaseColor;
        float4 _BarkBaseColorMap_TexelSize;
        float _BarkUseUV3;
        float4 _BarkTilingOffset;
        float4 _BarkNormalMap_TexelSize;
        float _BarkNormalScale;
        float4 _BarkMaskMap_TexelSize;
        float _BarkMetallic;
        float _BarkSmoothnessRemapMin;
        float _BarkSmoothnessRemapMax;
        float _BarkAORemapMin;
        float _BarkAORemapMax;
        float _Stiffness;
        float _InitialBend;
        float _Drag;
        float _HeightDrag;
        float4 _NewNormal;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_TrunkBaseColorMap);
        SAMPLER(sampler_TrunkBaseColorMap);
        TEXTURE2D(_TrunkNormalMap);
        SAMPLER(sampler_TrunkNormalMap);
        TEXTURE2D(_TrunkMaskMap);
        SAMPLER(sampler_TrunkMaskMap);
        TEXTURE2D(_LayerMask);
        SAMPLER(sampler_LayerMask);
        TEXTURE2D(_BarkBaseColorMap);
        SAMPLER(sampler_BarkBaseColorMap);
        TEXTURE2D(_BarkNormalMap);
        SAMPLER(sampler_BarkNormalMap);
        TEXTURE2D(_BarkMaskMap);
        SAMPLER(sampler_BarkMaskMap);
        float WIND_SETTINGS_GustWorldScale;
        float WIND_SETTINGS_GustScale;
        float WIND_SETTINGS_GustSpeed;
        float WIND_SETTINGS_Turbulence;
        float WIND_SETTINGS_ShiverNoiseScale;
        float WIND_SETTINGS_FlexNoiseScale;
        float4 WIND_SETTINGS_WorldDirectionAndSpeed;
        TEXTURE2D(WIND_SETTINGS_TexGust);
        SAMPLER(samplerWIND_SETTINGS_TexGust);
        float4 WIND_SETTINGS_TexGust_TexelSize;
        TEXTURE2D(WIND_SETTINGS_TexNoise);
        SAMPLER(samplerWIND_SETTINGS_TexNoise);
        float4 WIND_SETTINGS_TexNoise_TexelSize;
        float4x4 WIND_SETTINGS_Points;
        float4 WIND_SETTINGS_Points_Radius;
        
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
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Distance_float3(float3 A, float3 B, out float Out)
        {
            Out = distance(A, B);
        }
        
        void Unity_Comparison_Less_float(float A, float B, out float Out)
        {
            Out = A < B ? 1 : 0;
        }
        
        void Unity_Branch_float3(float Predicate, float3 True, float3 False, out float3 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Comparison_Greater_float(float A, float B, out float Out)
        {
            Out = A > B ? 1 : 0;
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_And_float(float A, float B, out float Out)
        {
            Out = A && B;
        }
        
        void Unity_Branch_float(float Predicate, float True, float False, out float Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
        Out = A * B;
        }
        
        void Unity_Length_float4(float4 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Branch_float4(float Predicate, float4 True, float4 False, out float4 Out)
        {
            Out = Predicate ? True : False;
        }
        
        void Unity_Subtract_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A - B;
        }
        
        void Unity_Normalize_float3(float3 In, out float3 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Length_float3(float3 In, out float Out)
        {
            Out = length(In);
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Clamp_float(float In, float Min, float Max, out float Out)
        {
            Out = clamp(In, Min, Max);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
        Out = A * B;
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float
        {
        };
        
        void SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(float4x4 Matrix4_cb72bb33b7a84dfda97778a514f9b60f, float3 Vector3_90379ebf40aa468b8362f8d265f4f234, float4 Vector4_159bb4232f82428893101734a03e2a1e, Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float IN, out float4 WindPoint_1)
        {
        float3 _Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3 = Vector3_90379ebf40aa468b8362f8d265f4f234;
        float4x4 _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4 = Matrix4_cb72bb33b7a84dfda97778a514f9b60f;
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].r, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].r);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].g, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].g);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].b, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].b);
        float4 _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4 = float4(_Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[0].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[1].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[2].a, _Property_0ccfce542b5a45ac9b2982fe9b0a6f94_Out_0_Matrix4[3].a);
        float3 _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4.xyz), _Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3);
        float3 _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3);
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[0];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[1];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[2];
        float _Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M0_1_Vector4[3];
        float _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float;
        Unity_Length_float3(_Subtract_95daedfd69f34cb1bdd7e1efcdaa8440_Out_2_Vector3, _Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float);
        float4 _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4 = Vector4_159bb4232f82428893101734a03e2a1e;
        float _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[0];
        float _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[1];
        float _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[2];
        float _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float = _Property_95860f949fd1491fa36d8d177961e858_Out_0_Vector4[3];
        float _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float;
        Unity_Divide_float(_Length_dbcd47a2d3574d29bd8b12b1cdb0745a_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_R_1_Float, _Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float);
        float _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float;
        Unity_Clamp_float(_Divide_19f232d35a834d09895353590c5a8b5a_Out_2_Float, float(0), float(1), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float);
        float _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float;
        Unity_Lerp_float(_Split_d6e088f9ab90466583adc22ea79eb8cc_A_4_Float, float(0), _Clamp_de1c41c0ba3341a2911a314981cf7a7a_Out_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float);
        float3 _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_bb19d5a0fb6544769cde736c8f2bcf83_Out_1_Vector3, (_Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float.xxx), _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3);
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[0];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[1];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float = _Multiply_d943bd948d9a4a6caab75f7761fc1c8d_Out_2_Vector3[2];
        float _Split_ef99a48850fe4f8f8e30e870c5e2ee09_A_4_Float = 0;
        float4 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4;
        float3 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3;
        float2 _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2;
        Unity_Combine_float(_Split_ef99a48850fe4f8f8e30e870c5e2ee09_R_1_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_G_2_Float, _Split_ef99a48850fe4f8f8e30e870c5e2ee09_B_3_Float, _Lerp_c895c7b6e0e94a65924bfc68c604c69e_Out_3_Float, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGB_5_Vector3, _Combine_d5dcc6adcb9e470599060ef2ff7859e6_RG_6_Vector2);
        float3 _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4.xyz), _Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3);
        float3 _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3);
        float _Split_8bbd5052350846968bf312362efd9f01_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[0];
        float _Split_8bbd5052350846968bf312362efd9f01_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[1];
        float _Split_8bbd5052350846968bf312362efd9f01_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[2];
        float _Split_8bbd5052350846968bf312362efd9f01_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M1_2_Vector4[3];
        float _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float;
        Unity_Length_float3(_Subtract_7197b65dd3b4425fb005b453c221c47d_Out_2_Vector3, _Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float);
        float _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float;
        Unity_Divide_float(_Length_25176aaf1e3847cb98d4410ff636b560_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_G_2_Float, _Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float);
        float _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float;
        Unity_Clamp_float(_Divide_d22ef2f383f94e6cbb0ec05ab2af98d0_Out_2_Float, float(0), float(1), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float);
        float _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float;
        Unity_Lerp_float(_Split_8bbd5052350846968bf312362efd9f01_A_4_Float, float(0), _Clamp_ec5be35d1db54279a9e0dcdc65ab5420_Out_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float);
        float3 _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_c1cb58821e4547dcbdff92ca338be8b9_Out_1_Vector3, (_Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float.xxx), _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3);
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[0];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[1];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float = _Multiply_7bd4a79d1b37484996b73b3702618628_Out_2_Vector3[2];
        float _Split_ab8841795f594d3a90b87ac9fcc98d38_A_4_Float = 0;
        float4 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4;
        float3 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3;
        float2 _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2;
        Unity_Combine_float(_Split_ab8841795f594d3a90b87ac9fcc98d38_R_1_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_G_2_Float, _Split_ab8841795f594d3a90b87ac9fcc98d38_B_3_Float, _Lerp_8e9751e8ad6842b3a85b84b5b568aa94_Out_3_Float, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGB_5_Vector3, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RG_6_Vector2);
        float4 _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4;
        Unity_Add_float4(_Combine_d5dcc6adcb9e470599060ef2ff7859e6_RGBA_4_Vector4, _Combine_2c29d82626064a91a7c4bd08cce14cc9_RGBA_4_Vector4, _Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4);
        float3 _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4.xyz), _Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3);
        float3 _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3);
        float _Split_fa21a8022f944854903e06c07c6f079c_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[0];
        float _Split_fa21a8022f944854903e06c07c6f079c_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[1];
        float _Split_fa21a8022f944854903e06c07c6f079c_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[2];
        float _Split_fa21a8022f944854903e06c07c6f079c_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M2_3_Vector4[3];
        float _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float;
        Unity_Length_float3(_Subtract_f38c175f40644157a8c113a8fd7c038c_Out_2_Vector3, _Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float);
        float _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float;
        Unity_Divide_float(_Length_882dfabd3bce4dbebba98f988f897026_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_B_3_Float, _Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float);
        float _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float;
        Unity_Clamp_float(_Divide_997deb354f774bf5b27a9320f16d1a2f_Out_2_Float, float(0), float(1), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float);
        float _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float;
        Unity_Lerp_float(_Split_fa21a8022f944854903e06c07c6f079c_A_4_Float, float(0), _Clamp_616aa25ccc4b4508957dfe01132d62f5_Out_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float);
        float3 _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_3e728f603e4844f0ada691bd863000b2_Out_1_Vector3, (_Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float.xxx), _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3);
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[0];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[1];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float = _Multiply_0399d775d57741a6b1308fce50cf7216_Out_2_Vector3[2];
        float _Split_6b9b5ad9f14a49b9bc49c718430617a8_A_4_Float = 0;
        float4 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4;
        float3 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3;
        float2 _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2;
        Unity_Combine_float(_Split_6b9b5ad9f14a49b9bc49c718430617a8_R_1_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_G_2_Float, _Split_6b9b5ad9f14a49b9bc49c718430617a8_B_3_Float, _Lerp_5d383299b2154039a2583aeed4883a88_Out_3_Float, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGB_5_Vector3, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RG_6_Vector2);
        float4 _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4;
        Unity_Add_float4(_Add_d1b72dc7a2294f8a86c0f5ae8ed9831b_Out_2_Vector4, _Combine_ef684d29a4b74f918ca38fa0cf6bea4d_RGBA_4_Vector4, _Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4);
        float3 _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3;
        Unity_Subtract_float3(_Property_8921fe8497db4536a36227f7cadb23db_Out_0_Vector3, (_MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4.xyz), _Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3);
        float3 _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3;
        Unity_Normalize_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3);
        float _Split_1bfec6763d4b458398e36937b4114c29_R_1_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[0];
        float _Split_1bfec6763d4b458398e36937b4114c29_G_2_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[1];
        float _Split_1bfec6763d4b458398e36937b4114c29_B_3_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[2];
        float _Split_1bfec6763d4b458398e36937b4114c29_A_4_Float = _MatrixSplit_09b25987ae114376bd1deca21c911b24_M3_4_Vector4[3];
        float _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float;
        Unity_Length_float3(_Subtract_59668fc0d64640d3926a84feeb6cc7d1_Out_2_Vector3, _Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float);
        float _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float;
        Unity_Divide_float(_Length_8a37c2eaad554eeb885a33813fcb99c7_Out_1_Float, _Split_3d7febba13614fefa50d13642a1d3f97_A_4_Float, _Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float);
        float _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float;
        Unity_Clamp_float(_Divide_1c33f266d32a43d69818e21acd21cc3f_Out_2_Float, float(0), float(1), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float);
        float _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float;
        Unity_Lerp_float(_Split_1bfec6763d4b458398e36937b4114c29_A_4_Float, float(0), _Clamp_5ea5d4daacbb48b8a052eb0b94a0a46e_Out_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float);
        float3 _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_fb80659c0b1d4ba2b93a9c269e0cc737_Out_1_Vector3, (_Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float.xxx), _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3);
        float _Split_e22879e6c4574322ab21f6261a21bced_R_1_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[0];
        float _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[1];
        float _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float = _Multiply_67f2ec6d64334332906d5c564d5bb7c5_Out_2_Vector3[2];
        float _Split_e22879e6c4574322ab21f6261a21bced_A_4_Float = 0;
        float4 _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4;
        float3 _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3;
        float2 _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2;
        Unity_Combine_float(_Split_e22879e6c4574322ab21f6261a21bced_R_1_Float, _Split_e22879e6c4574322ab21f6261a21bced_G_2_Float, _Split_e22879e6c4574322ab21f6261a21bced_B_3_Float, _Lerp_b26221cb41884c75acf850b4f66b414b_Out_3_Float, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGB_5_Vector3, _Combine_872906644fc84c8c8286733edba75045_RG_6_Vector2);
        float4 _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        Unity_Add_float4(_Add_e88334a2c6bf40e197a79d333645fdb2_Out_2_Vector4, _Combine_872906644fc84c8c8286733edba75045_RGBA_4_Vector4, _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4);
        WindPoint_1 = _Add_710af6873aa744f6838904f22ad657e2_Out_2_Vector4;
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Or_float(float A, float B, out float Out)
        {
            Out = A || B;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        struct Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float
        {
        };
        
        void SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(float3 Vector3_604F121F, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7F78DDD2, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float Vector1_5EFF6B1A, Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float IN, out float3 direction_1, out float strength_2)
        {
        float4 _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[0];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[1];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[2];
        float _Split_f4f701329abd45808bbd6b61ce26dcc8_A_4_Float = _Property_8eece987bcee5a8681353e05121e2390_Out_0_Vector4[3];
        float4 _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4;
        float3 _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3;
        float2 _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2;
        Unity_Combine_float(_Split_f4f701329abd45808bbd6b61ce26dcc8_R_1_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_G_2_Float, _Split_f4f701329abd45808bbd6b61ce26dcc8_B_3_Float, float(0), _Combine_39060d5de038a58eb7462ba953e69739_RGBA_4_Vector4, _Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Combine_39060d5de038a58eb7462ba953e69739_RG_6_Vector2);
        float3 _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3;
        Unity_Normalize_float3(_Combine_39060d5de038a58eb7462ba953e69739_RGB_5_Vector3, _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3);
        float4 _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_R_1_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[0];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_G_2_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[1];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_B_3_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[2];
        float _Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float = _Property_2c43c4b554974085ab95cddc7214c1e2_Out_0_Vector4[3];
        float3 _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, (_Split_aeb4c57f09db718e9e14c3afd38465ae_A_4_Float.xxx), _Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3);
        float _Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float = Vector1_9365F438;
        float _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_72aef364136bb683b08145ce7a1b59a1_Out_0_Float, float(0), _Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean);
        UnityTexture2D _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D = Texture2D_A3874DB9;
        float3 _Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3 = float3(float(1), float(0), float(0));
        float _Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Property_e53ae21dcf87e286b67de750a59275e7_Out_0_Float.xxx), _Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3);
        float _Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float = Vector1_5EFF6B1A;
        float3 _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_ea451e1902009f82a8b8044a4344575e_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3);
        float3 _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3;
        Unity_Subtract_float3(_Property_f0ff7954720d018395b7da89e2e2d761_Out_0_Vector3, _Multiply_ae858d83e1cea885a9aa0a01a1eef954_Out_2_Vector3, _Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3);
        float _Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float = Vector1_6803B355;
        float3 _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b8786cc4ca501c8ba745007b3c25c479_Out_2_Vector3, (_Property_7f2599afa6fc5b8394c8fb0389031122_Out_0_Float.xxx), _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3);
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[0];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_G_2_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[1];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float = _Multiply_4cc0cd205c36b88aa0411aa274ed6066_Out_2_Vector3[2];
        float _Split_f4466ebe24e7fa838f5735fb1210a3dd_A_4_Float = 0;
        float4 _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4;
        float3 _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3;
        float2 _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2;
        Unity_Combine_float(_Split_f4466ebe24e7fa838f5735fb1210a3dd_R_1_Float, _Split_f4466ebe24e7fa838f5735fb1210a3dd_B_3_Float, float(0), float(0), _Combine_0ac20ec517f076829f01b70d67c5af02_RGBA_4_Vector4, _Combine_0ac20ec517f076829f01b70d67c5af02_RGB_5_Vector3, _Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2);
          float4 _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.tex, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.samplerstate, _Property_acc8b35c6330408c905387353b2a48e7_Out_0_Texture2D.GetTransformedUV(_Combine_0ac20ec517f076829f01b70d67c5af02_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_G_6_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_B_7_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_A_8_Float = _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_RGBA_0_Vector4.a;
        float _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float;
        Unity_Branch_float(_Comparison_30e6d1ed5d13ea88ac1c717b4cf7f8b6_Out_2_Boolean, _SampleTexture2DLOD_230c200055ef6a87bc7e6561e4cc94a8_R_5_Float, float(0), _Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float);
        float _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float;
        Unity_Power_float(_Branch_710124ae92f9d88bbca57ab4e6ca8632_Out_3_Float, float(2), _Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float);
        float _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float = Vector1_F53C4B89;
        float _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float;
        Unity_Multiply_float_float(_Power_62722ebbb5d5b18cb4e41bb5612b4f78_Out_2_Float, _Property_9592cd5ab3f8628d995c1b79e8b0e51d_Out_0_Float, _Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float);
        float3 _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3;
        Unity_Multiply_float3_float3((_Multiply_a0cee471fa6b3f81a23110085b9f7901_Out_2_Float.xxx), _Normalize_a38510e5fae5478f897b4be58ae18930_Out_1_Vector3, _Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3);
        float _Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float = Vector1_9365F438;
        float3 _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_dbea21b5e949338ba29fe217546785bd_Out_2_Vector3, (_Property_7be270a4cb312f8ebbfba142f454b30d_Out_0_Float.xxx), _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3);
        float3 _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3;
        Unity_Add_float3(_Multiply_43c9dfe8713d4584b24b33530801a1b9_Out_2_Vector3, _Multiply_57f8f9285ea3698a9db9febf3bb09729_Out_2_Vector3, _Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3);
        float4 _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Split_e719665c40324e89a536d165d0427a68_R_1_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[0];
        float _Split_e719665c40324e89a536d165d0427a68_G_2_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[1];
        float _Split_e719665c40324e89a536d165d0427a68_B_3_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[2];
        float _Split_e719665c40324e89a536d165d0427a68_A_4_Float = _Property_d76b4059b7077987b51af415dfa9bf4a_Out_0_Vector4[3];
        float _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Split_e719665c40324e89a536d165d0427a68_A_4_Float, float(0), _Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean);
        float _Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float = Vector1_2EC6D670;
        float _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_295a45d224dd35829c1fc35a5ac74847_Out_0_Float, float(0), _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean);
        float _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean;
        Unity_Or_float(_Comparison_0e3f11398ddedf898ab9dfc4afb01674_Out_2_Boolean, _Comparison_d11455e909bf08898f06c88542bc8c3c_Out_2_Boolean, _Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean);
        UnityTexture2D _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D = Texture2D_5BAC276D;
        float3 _Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Vector3_a72856f64732461f9c308d03c9df6e06_Out_0_Vector3, (_Split_e719665c40324e89a536d165d0427a68_A_4_Float.xxx), _Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3);
        float3 _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Multiply_aabee1c217095b809f71af0c1a159e17_Out_2_Vector3, (_Property_bad047c8692ad38e91118ad73dfde8a1_Out_0_Float.xxx), _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3);
        float3 _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3;
        Unity_Subtract_float3(_Property_c82f40aba4b7f08db9a97aaccbe0e096_Out_0_Vector3, _Multiply_dc69447dd485178f8993dfedd03528df_Out_2_Vector3, _Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3);
        float _Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float = Vector1_B4470F9B;
        float3 _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_994d0a10f1b53f89a06319a456a703cb_Out_2_Vector3, (_Property_1ab0df57959c6986a0602bb0abfeaf58_Out_0_Float.xxx), _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3);
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[0];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_G_2_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[1];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float = _Multiply_9653c173603c7f88bb186f1bf4699302_Out_2_Vector3[2];
        float _Split_5ff678fef0fb61889da2a8288f7e7d15_A_4_Float = 0;
        float4 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4;
        float3 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3;
        float2 _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2;
        Unity_Combine_float(_Split_5ff678fef0fb61889da2a8288f7e7d15_R_1_Float, _Split_5ff678fef0fb61889da2a8288f7e7d15_B_3_Float, float(0), float(0), _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGBA_4_Vector4, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RGB_5_Vector3, _Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2);
          float4 _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4 = SAMPLE_TEXTURE2D_LOD(_Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.tex, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.samplerstate, _Property_0c5a125604df6a8c882ffd08d9ab1eb1_Out_0_Texture2D.GetTransformedUV(_Combine_c6371d3dd2e6e588b17d15becfd9f41f_RG_6_Vector2), float(3));
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.r;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.g;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.b;
        float _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_A_8_Float = _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_RGBA_0_Vector4.a;
        float4 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4;
        float3 _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3;
        float2 _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2;
        Unity_Combine_float(_SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_R_5_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_G_6_Float, _SampleTexture2DLOD_f9da942482343b84b60697d06f23721c_B_7_Float, float(0), _Combine_3136fa3d24c46087969f5a3828ccbb98_RGBA_4_Vector4, _Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, _Combine_3136fa3d24c46087969f5a3828ccbb98_RG_6_Vector2);
        float3 _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3;
        Unity_Add_float3(_Combine_3136fa3d24c46087969f5a3828ccbb98_RGB_5_Vector3, float3(-0.5, -0.5, -0.5), _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3);
        float3 _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3;
        Unity_Branch_float3(_Or_4341a0900c08ad87bd6a2225f3fa0566_Out_2_Boolean, _Add_ef7a0ab366477c878fbb735a918f7344_Out_2_Vector3, float3(0, 0, 0), _Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3);
        float _Property_9946d066804cc584a96830f8d35269cc_Out_0_Float = Vector1_2EC6D670;
        float3 _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Branch_740c68545077da8f8307f27b8c42ae4a_Out_3_Vector3, (_Property_9946d066804cc584a96830f8d35269cc_Out_0_Float.xxx), _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3);
        float3 _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3;
        Unity_Add_float3(_Add_02d5dc0d629dcd8f97caf80b6afb884c_Out_2_Vector3, _Multiply_96523fbe5cf67789a958918945aae4af_Out_2_Vector3, _Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3);
        float _Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float = Vector1_A2C4B4F4;
        float3 _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Add_36ab0a2baacbf685bfc47193bdd9ede0_Out_2_Vector3, (_Property_4ffb3356bdb9c78c815a6e7da47e7a34_Out_0_Float.xxx), _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3);
        float _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float;
        Unity_Length_float3(_Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3, _Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float);
        float _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float = Vector1_7F78DDD2;
        float _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float;
        Unity_Add_float(_Length_5a5f71c3d2510f898359c583d75db21b_Out_1_Float, _Property_51d6736452f5938caf6f83cdfc7df682_Out_0_Float, _Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float);
        float _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        Unity_Multiply_float_float(_Add_8b1ff99f4209848e94b032b984c39e3d_Out_2_Float, 0.001, _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float);
        direction_1 = _Multiply_5c06c9a8640ee88fa0516a7a341a0ea9_Out_2_Vector3;
        strength_2 = _Multiply_5a6d4212aae61b828d149e491e799600_Out_2_Float;
        }
        
        void Unity_CrossProduct_float(float3 A, float3 B, out float3 Out)
        {
            Out = cross(A, B);
        }
        
        void Unity_Comparison_Equal_float(float A, float B, out float Out)
        {
            Out = A == B ? 1 : 0;
        }
        
        void Unity_DotProduct_float3(float3 A, float3 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Cosine_float(float In, out float Out)
        {
            Out = cos(In);
        }
        
        void Unity_Sine_float(float In, out float Out)
        {
            Out = sin(In);
        }
        
        void Unity_Comparison_NotEqual_float(float A, float B, out float Out)
        {
            Out = A != B ? 1 : 0;
        }
        
        struct Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float
        {
        float3 WorldSpaceNormal;
        float4 VertexColor;
        };
        
        void SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(float Vector1_BCB03E1A, float3 Vector3_C30D997B, float Vector1_A2C4B4F4, float Vector1_7EE0F94A, float Boolean_527CB26E, float Vector1_DE1BF63A, float Vector1_7F78DDD2, float3 Vector3_DE8CC74D, UnityTexture2D Texture2D_5BAC276D, UnityTexture2D Texture2D_A3874DB9, float4 Vector4_EBFF8CDE, float Vector1_B4470F9B, float Vector1_2EC6D670, float Vector1_9365F438, float Vector1_F53C4B89, float Vector1_6803B355, float4x4 Matrix4_0617b0bd42fc46ff90b1d55303a5477f, float4 Vector4_b44806ec67ca461fbcdf009dc6092cc3, Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float IN, out float3 vertex_1, out float3 normal_2)
        {
        float4 _Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3;
        _Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3 = TransformObjectToWorld((_Vector4_c313b0597c39438bb9a6bb83c46531a3_Out_0_Vector4.xyz).xyz);
        float _Distance_63631313b11e497cab6af82887a71903_Out_2_Float;
        Unity_Distance_float3(_Transform_75daaac96b6847df8f9cc10319e80ab2_Out_1_Vector3, float3(0, 0, 0), _Distance_63631313b11e497cab6af82887a71903_Out_2_Float);
        float _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_63631313b11e497cab6af82887a71903_Out_2_Float, float(0.001), _Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean);
        float3 _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3 = Vector3_C30D997B;
        float4 _Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4 = float4(float(0), float(0), float(0), float(1));
        float3 _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3;
        _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3 = TransformObjectToWorld((_Vector4_d213eb2790b34988809a251ff9c74c6b_Out_0_Vector4.xyz).xyz);
        float _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float;
        Unity_Distance_float3(_Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, float3(0, 0, 0), _Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float);
        float _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean;
        Unity_Comparison_Less_float(_Distance_1c61c2848b134e8a89dc80c4a957783f_Out_2_Float, float(1), _Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean);
        float3 _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_f303132939384d919c59d7e0a2a9482a_Out_2_Boolean, float3(5, 5, 5), _Transform_4acbe76287b06c88a7e8fd7bf234e885_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3);
        float3 _Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3 = Vector3_C30D997B;
        float3 _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3;
        _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3 = TransformObjectToWorld(_Property_4a88ff8e6e6b2b84bb2818cf73a0af30_Out_0_Vector3.xyz);
        float _Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean = Boolean_527CB26E;
        float _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float = Vector1_7EE0F94A;
        float _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, float(0), _Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean);
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_R_1_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[0];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[1];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_B_3_Float = _Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3[2];
        float _Split_05e55a8c1b8cf88f93cbafc67103b677_A_4_Float = 0;
        float _Split_7a634ef857769683b2100876a36535a2_R_1_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[0];
        float _Split_7a634ef857769683b2100876a36535a2_G_2_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[1];
        float _Split_7a634ef857769683b2100876a36535a2_B_3_Float = _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3[2];
        float _Split_7a634ef857769683b2100876a36535a2_A_4_Float = 0;
        float _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float;
        Unity_Subtract_float(_Split_05e55a8c1b8cf88f93cbafc67103b677_G_2_Float, _Split_7a634ef857769683b2100876a36535a2_G_2_Float, _Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float);
        float _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean;
        Unity_Comparison_Less_float(_Subtract_1a45a2cfb2029a85a28951578a3fde32_Out_2_Float, _Property_d2b118dbe85e878e9fec6b0b9baa39c4_Out_0_Float, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean);
        float _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean;
        Unity_And_float(_Comparison_5cee8efb01c62783a5e7b747d356c826_Out_2_Boolean, _Comparison_010cc8a451c9dc83967dac44b371c4df_Out_2_Boolean, _And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean);
        float _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float = Vector1_A2C4B4F4;
        float _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float;
        Unity_Branch_float(_And_555aa962b30d6f8fa39e7b48a39aed28_Out_2_Boolean, float(1E-05), _Property_e5e59fcc565a8b80ac239ba87d1bcf74_Out_0_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float);
        float _Split_43013162a81fc4889a1944f2a2b75f66_R_1_Float = IN.VertexColor[0];
        float _Split_43013162a81fc4889a1944f2a2b75f66_G_2_Float = IN.VertexColor[1];
        float _Split_43013162a81fc4889a1944f2a2b75f66_B_3_Float = IN.VertexColor[2];
        float _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float = IN.VertexColor[3];
        float _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float;
        Unity_Multiply_float_float(_Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Split_43013162a81fc4889a1944f2a2b75f66_A_4_Float, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float);
        float _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float;
        Unity_Branch_float(_Property_dfda12e25f42bd808e65c99db447e176_Out_0_Boolean, _Multiply_9c96a1fd35427788a3d19f08eaffffef_Out_2_Float, _Branch_24dc0e5d7442ff84b33e0e63f143d905_Out_3_Float, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float);
        float _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float = Vector1_7F78DDD2;
        UnityTexture2D _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D = Texture2D_5BAC276D;
        UnityTexture2D _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D = Texture2D_A3874DB9;
        float4 _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4 = Vector4_EBFF8CDE;
        float _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float;
        Unity_Length_float4(_Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, _Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float);
        float _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean;
        Unity_Comparison_Greater_float(_Length_2deb60e58108481bbea09c2abd4f6360_Out_1_Float, float(0), _Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean);
        float4 _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4;
        Unity_Branch_float4(_Comparison_e709f727d2ea465cb4118f3949b53fe3_Out_2_Boolean, _Property_deadd39786d94cb381d4d15213801177_Out_0_Vector4, float4(0, 0, 1, 1), _Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4);
        float4x4 _Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4 = Matrix4_0617b0bd42fc46ff90b1d55303a5477f;
        float4 _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4 = Vector4_b44806ec67ca461fbcdf009dc6092cc3;
        Bindings_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float _WindNMPoints_a2cb25cd23df4791acc49df936a795bc;
        float4 _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4;
        SG_WindNMPoints_920a3602244f68a4599f846c02f0a9c5_float(_Property_cb03cb298f0a47d4ae24d85f3c47db75_Out_0_Matrix4, SHADERGRAPH_OBJECT_POSITION, _Property_844e35a56a864617b521872c1cee398d_Out_0_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4);
        float4 _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4;
        Unity_Add_float4(_Branch_2e6bb4148fd446a993140d85024ed2fd_Out_3_Vector4, _WindNMPoints_a2cb25cd23df4791acc49df936a795bc_WindPoint_1_Vector4, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4);
        float _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float = Vector1_B4470F9B;
        float _Property_6b508d48a081548385021b27896c0622_Out_0_Float = Vector1_2EC6D670;
        float _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float = Vector1_9365F438;
        float _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float = Vector1_F53C4B89;
        float _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float = Vector1_6803B355;
        float _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float = Vector1_BCB03E1A;
        Bindings_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba;
        float3 _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3;
        float _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float;
        SG_WindNMCalculateNoShiver_eb6e21ce3f0928341b88e73dd9c62c10_float(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Branch_61b7d28e5f7d2981b63f0054ac12d71a_Out_3_Float, _Property_eaab26f57a13988a8a813ad0813c8570_Out_0_Float, _Property_0f02225ebee993849ea6be48328c0958_Out_0_Texture2D, _Property_fce16cc7b4fcf48097b94eb2d5f1b596_Out_0_Texture2D, _Add_a113107313614631a97405d9184f98a3_Out_2_Vector4, _Property_02c51f4c8a859f8f88433b435d4452f6_Out_0_Float, _Property_6b508d48a081548385021b27896c0622_Out_0_Float, _Property_d73fed4fb3c7b58d892364765a30498b_Out_0_Float, _Property_c3101a1b656cac858bfa11dbe7ebd268_Out_0_Float, _Property_c82c2ac458938d86bcc1aae3a58cc1dc_Out_0_Float, _Property_3f5330d8bec7c681ab9563aad03c7b89_Out_0_Float, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float);
        float3 _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3;
        Unity_CrossProduct_float(float3 (0, 1, 0), _WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_direction_1_Vector3, _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3);
        float _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean;
        Unity_Comparison_Equal_float((_CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3).x, float(0), _Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean);
        float3 _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_5d396e98300c4552830ea915069fed2c_Out_2_Boolean, float3(1E-06, 1E-06, 1E-06), _CrossProduct_968274de232ac28180b15962e0cd7d4b_Out_2_Vector3, _Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3);
        float3 _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3;
        Unity_Normalize_float3(_Branch_0c9fa566a12947f2933cfaf6c994c646_Out_3_Vector3, _Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3);
        float3 _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3);
        float _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float;
        Unity_DotProduct_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_669f1473ae7e6e8595e30c93528623a2_Out_2_Vector3, _DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float);
        float3 _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, (_DotProduct_4ef6847a2d36df8cac2bf956cc3d32e0_Out_2_Float.xxx), _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3);
        float3 _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3;
        Unity_Add_float3(_Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Multiply_cde444a0de597b8282b544296776bd35_Out_2_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3);
        float3 _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3;
        Unity_Subtract_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3);
        float _Distance_702b068f612c7289a99272879da274ed_Out_2_Float;
        Unity_Distance_float3(_Transform_d324a56361d94f80935dd05df051490e_Out_1_Vector3, _Branch_5a1f8cde43c349699ace94eaebd101a4_Out_3_Vector3, _Distance_702b068f612c7289a99272879da274ed_Out_2_Float);
        float _Property_f5c255b0f666358291012b78132d6593_Out_0_Float = Vector1_DE1BF63A;
        float _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float;
        Unity_Divide_float(_Distance_702b068f612c7289a99272879da274ed_Out_2_Float, _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float);
        float _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float;
        Unity_Absolute_float(_Divide_86ba32ec2efb64888f1b432782289403_Out_2_Float, _Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float);
        float _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float = float(1E-07);
        float _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float;
        Unity_Maximum_float(_Absolute_b490a8463d40078e9f49eb1f255aba57_Out_1_Float, _Float_96534b09fc72da8da7bad6ebdb2b01ab_Out_0_Float, _Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float);
        float _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float;
        Unity_Divide_float(float(1), _Property_f5c255b0f666358291012b78132d6593_Out_0_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float);
        float _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float;
        Unity_Power_float(_Maximum_433c7134dae10d83ad9da03f0d30c4a0_Out_2_Float, _Divide_c45d79d6b2beea8293614db9809045fa_Out_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float);
        float _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float;
        Unity_Multiply_float_float(_WindNMCalculateNoShiver_ed5866aa196e188893da1307437132ba_strength_2_Float, _Power_aae331b5fcc0168da1590dbbc62504a4_Out_2_Float, _Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float);
        float _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float;
        Unity_Cosine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float);
        float3 _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3;
        Unity_Multiply_float3_float3(_Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, (_Cosine_210f67c5c8fb6c8aa417007f6255e22d_Out_1_Float.xxx), _Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3);
        float3 _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3;
        Unity_CrossProduct_float(_Normalize_9fd167d60aa1d1809fce8233690a3c5c_Out_1_Vector3, _Subtract_b285d42464e22a80adba2a34d1e89a02_Out_2_Vector3, _CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3);
        float _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float;
        Unity_Sine_float(_Multiply_13e65c7c3e1e8282bd06a4e2746f709f_Out_2_Float, _Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float);
        float3 _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3;
        Unity_Multiply_float3_float3(_CrossProduct_f5f50ca0805f7080b7fd20844a78afc1_Out_2_Vector3, (_Sine_419aece79cb6a485a9c3dec0b5b09f8c_Out_1_Float.xxx), _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3);
        float3 _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3;
        Unity_Add_float3(_Multiply_2f6dc881c414ee89a8fbbf0a5e0014eb_Out_2_Vector3, _Multiply_df4686bd34ab88839180248e49a9f266_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3);
        float3 _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3;
        Unity_Add_float3(_Add_148ed50f060f2a859e921addaad435fd_Out_2_Vector3, _Add_c14d4bcfa1ccf486a133715f088d8cf7_Out_2_Vector3, _Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3);
        float3 _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3;
        _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3 = TransformWorldToObject(_Add_d48375b91f961f89b468b522221fb6ee_Out_2_Vector3.xyz);
        float3 _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_33904aafc3c14044ae1f2e36a4314ede_Out_2_Boolean, _Property_81eb9f94925849acbb5edc41609b1281_Out_0_Vector3, _Transform_224c24cf5953f18a87e2088380250252_Out_1_Vector3, _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3);
        float3 _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3 = Vector3_DE8CC74D;
        float _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float;
        Unity_Length_float3(_Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float);
        float _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean;
        Unity_Comparison_NotEqual_float(_Length_8fac716cbfa5b983ba3cf14312642ac5_Out_1_Float, float(0), _Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean);
        float3 _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3;
        Unity_Multiply_float3_float3(IN.WorldSpaceNormal, _Property_c5f622c3918154808caa04a0cff875eb_Out_0_Vector3, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3);
        float3 _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        Unity_Branch_float3(_Comparison_17ad34828cc8b986ac7beaf8f6f2b799_Out_2_Boolean, _Multiply_d5e536621795b68bbc95bb5cc341dfcf_Out_2_Vector3, IN.WorldSpaceNormal, _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3);
        vertex_1 = _Branch_743061b5be8e40a2a6a4a883383944ff_Out_3_Vector3;
        normal_2 = _Branch_e504c7d39baa3084852f5cd5fd3d9d94_Out_3_Vector3;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
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
            float3 _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, float3(1E-07, 1E-07, 1E-07), _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3);
            float _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float = _Drag;
            float _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float = _HeightDrag;
            float _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float = _Stiffness;
            float _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float = _InitialBend;
            float4 _Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4 = _NewNormal;
            UnityTexture2D _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexNoise);
            UnityTexture2D _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(WIND_SETTINGS_TexGust);
            float4 _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4 = WIND_SETTINGS_WorldDirectionAndSpeed;
            float _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float = WIND_SETTINGS_FlexNoiseScale;
            float _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float = WIND_SETTINGS_Turbulence;
            float _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float = WIND_SETTINGS_GustSpeed;
            float _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float = WIND_SETTINGS_GustScale;
            float _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float = WIND_SETTINGS_GustWorldScale;
            float4x4 _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4 = WIND_SETTINGS_Points;
            float4 _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4 = WIND_SETTINGS_Points_Radius;
            Bindings_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float _WindNMNoShiver_b359abef47ec45809b991323244cdb1c;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.WorldSpaceNormal = IN.WorldSpaceNormal;
            _WindNMNoShiver_b359abef47ec45809b991323244cdb1c.VertexColor = IN.VertexColor;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
            float3 _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3;
            SG_WindNMNoShiver_76b4d01171ac5564a83e72b2b046c0cf_float(IN.TimeParameters.x, _Add_2372d0ef51e245a69dd85e1d2edc5a11_Out_2_Vector3, _Property_d0aed353fc0d6087ba3c134799889809_Out_0_Float, _Property_8698aa98d732508cb16465acc97a3e86_Out_0_Float, 0, _Property_dd1135aac4d9ca898ec8843523c6fce6_Out_0_Float, _Property_3b8efec7a317c48db4117a1c15dd378d_Out_0_Float, (_Property_80c400d1da7fd382a8d664e2feb9323a_Out_0_Vector4.xyz), _Property_816257881178ca879466cee4a29318cf_Out_0_Texture2D, _Property_459256a932e4318a8183cf471cd425dc_Out_0_Texture2D, _Property_97f6b51572efce84b654b0775d03b84c_Out_0_Vector4, _Property_163404c60fb6718e8d4332f7ed0dab02_Out_0_Float, _Property_27973d3e31abd0878d2a7d2771be7104_Out_0_Float, _Property_24e4685ff6e47186b970b8d558b4c498_Out_0_Float, _Property_9f63bfb91b3f248697df5be4b34017d8_Out_0_Float, _Property_132d2d9a456cd8829b326cb5ad899508_Out_0_Float, _Property_2a23accb44ca4ab79a0006b0d61614c0_Out_0_Matrix4, _Property_be93483de44148608352a8e16af9811e_Out_0_Vector4, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3, _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_normal_2_Vector3);
            description.Position = _WindNMNoShiver_b359abef47ec45809b991323244cdb1c_vertex_1_Vector3;
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
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            UnityTexture2D _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_TrunkBaseColorMap);
            float4 _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4 = _TrunkTilingOffset;
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[0];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[1];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[2];
            float _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float = _Property_48c1c6a2f33b3784ac40094b47329c27_Out_0_Vector4[3];
            float2 _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_R_1_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_G_2_Float);
            float2 _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2 = float2(_Split_7ec5bf01c018b78499cb09dfe0c85a07_B_3_Float, _Split_7ec5bf01c018b78499cb09dfe0c85a07_A_4_Float);
            float2 _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_058647e8fee3b98ab21fa192075f97da_Out_0_Vector2, _Vector2_743d6a3034d21d8a81e6a39570dfb653_Out_0_Vector2, _TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2);
            float4 _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.tex, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.samplerstate, _Property_d0a71c2ad7b90583a21f06d2ab5b07e2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_5257aafcb80b4886ad8796b618586544_Out_3_Vector2) );
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_R_4_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.r;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_G_5_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.g;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_B_6_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.b;
            float _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_A_7_Float = _SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4.a;
            float4 _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4 = _TrunkBaseColor;
            float4 _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_4e56ffa3a53d378698371a0a0f4b7545_RGBA_0_Vector4, _Property_6c80cfc2ce3bae86a1e24e04191662a7_Out_0_Vector4, _Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4);
            UnityTexture2D _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_BarkBaseColorMap);
            float _Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean = _BarkUseUV3;
            float4 _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4 = IN.uv3;
            float4 _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4 = IN.uv0;
            float4 _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4;
            Unity_Branch_float4(_Property_ebff9413c8e8488890fcdca9fc9ca515_Out_0_Boolean, _UV_d512b403868e998b81ba8e50fc0aef56_Out_0_Vector4, _UV_65dc0aa6dbce5a859a792840f4a3ab6d_Out_0_Vector4, _Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4);
            float4 _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4 = _BarkTilingOffset;
            float _Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[0];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[1];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[2];
            float _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float = _Property_00fd67825d90d48fae1c7d02c5f5191f_Out_0_Vector4[3];
            float2 _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_R_1_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_G_2_Float);
            float2 _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2 = float2(_Split_984d23228d957e8a8ffa9a38b9efc457_B_3_Float, _Split_984d23228d957e8a8ffa9a38b9efc457_A_4_Float);
            float2 _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2;
            Unity_TilingAndOffset_float((_Branch_54882a9d8ae3378792467a0f698aa970_Out_3_Vector4.xy), _Vector2_43c3046e533e4d8da736d112fab24a6b_Out_0_Vector2, _Vector2_a6e940c952a9fe8e8707e64c1d767664_Out_0_Vector2, _TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2);
            float4 _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.tex, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.samplerstate, _Property_88df74c470464489aa98847614f386a2_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_d35566bfe3ddf083a228e03813657066_Out_3_Vector2) );
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_R_4_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.r;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_G_5_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.g;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_B_6_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.b;
            float _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_A_7_Float = _SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4.a;
            float4 _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4 = _BarkBaseColor;
            float4 _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4;
            Unity_Multiply_float4_float4(_SampleTexture2D_de82c6e60e4e4283a0987a5b7b5060d4_RGBA_0_Vector4, _Property_7b3429139819628f85b839fbc09d9bc6_Out_0_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4);
            UnityTexture2D _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D = UnityBuildTexture2DStructNoScale(_LayerMask);
            float4 _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4 = _BarkBlendMaskTilingOffset;
            float _Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[0];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[1];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[2];
            float _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float = _Property_b5f6bcebb8b32e89b52c3f85783ded0a_Out_0_Vector4[3];
            float2 _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_R_1_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_G_2_Float);
            float2 _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2 = float2(_Split_a3e74b96191a4b80839bea612f38bcbe_B_3_Float, _Split_a3e74b96191a4b80839bea612f38bcbe_A_4_Float);
            float2 _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2;
            Unity_TilingAndOffset_float(IN.uv0.xy, _Vector2_859a54707b3664838b6a520989d7bfd2_Out_0_Vector2, _Vector2_16901e853dda948ab43853d9368f8779_Out_0_Vector2, _TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2);
            float4 _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(_Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.tex, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.samplerstate, _Property_86b923800d89ec8181e3e75d5efd8638_Out_0_Texture2D.GetTransformedUV(_TilingAndOffset_f833fa635f96ba808068c46bda4db69e_Out_3_Vector2) );
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_R_4_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.r;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_G_5_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.g;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_B_6_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.b;
            float _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float = _SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_RGBA_0_Vector4.a;
            float4 _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4;
            Unity_Lerp_float4(_Multiply_aae3cf539d61eb8b8895bf354f11ecd7_Out_2_Vector4, _Multiply_9b2771977cc40c83a6e8b9c3c1f8bdc6_Out_2_Vector4, (_SampleTexture2D_184a6002a351e680a96d2c1da5a068b3_A_7_Float.xxxx), _Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4);
            surface.BaseColor = (_Lerp_eb87b86a4ad34c89b5802ebc1d0ca8e6_Out_3_Vector4.xyz);
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
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.WorldSpaceNormal =                           TransformObjectToWorldNormal(input.normalOS);
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.VertexColor =                                input.color;
            output.TimeParameters =                             _TimeParameters.xyz;
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
        
            
        
        
        
        
        
        
            #if UNITY_UV_STARTS_AT_TOP
            #else
            #endif
        
        
            output.uv0 = input.texCoord0;
            output.uv3 = input.texCoord3;
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