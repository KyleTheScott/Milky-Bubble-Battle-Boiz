Shader "Custom/TeaShader2"
{
    Properties
    {
        Color_F60AF011("TeaColor", Color) = (0.6698113, 0.4917013, 0.3380651, 0)
        Vector1_65AB24F7("TeaAlpha", Range(0, 1)) = 1
        Color_E3EE7E87("DepthColor", Color) = (0.4622642, 0.2817195, 0.128649, 1)
        Vector1_E28BDDBB("DeepWater", Float) = 2
        Color_52823E97("FoamColor", Color) = (0.7830189, 0.6730796, 0.631586, 0)
        Vector1_2316E3C6("FoamCutoff", Float) = 14
        Vector1_2ED59376("FoamAlpha", Range(0, 1)) = 1
        Vector1_66FC436C("FoamSpeed", Float) = 2
        Vector1_CC883DEC("FoamAmount", Float) = 1
        Vector1_AE5B059E("FoamScale", Float) = 65
        Vector1_6BF8592E("RippleCutoff", Range(0, 1)) = 0.65
        Vector1_1AFFAEB7("RippleAlpha", Range(0, 1)) = 1
        Vector1_F0382C7B("WaveStrength", Float) = 0.15
        Vector1_D6291039("WaveSpeed", Float) = 0.2
        Vector1_99C62EE8("WaveScale", Float) = 3
        Vector1_DBFE50E5("Smoothness", Float) = 0.5
        [NonModifiableTextureData][NoScaleOffset]_SampleTexture2D_27B068CA_Texture_1("Texture2D", 2D) = "white" {}
    }
        SubShader
    {
        Tags
        {
            "RenderPipeline" = "UniversalPipeline"
            "RenderType" = "Transparent"
            "Queue" = "Transparent+0"
        }

        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }

        // Render State
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        Cull Off
        ZTest LEqual
        ZWrite On
        // ColorMask: <None>


        HLSLPROGRAM
        #pragma vertex vert
        #pragma fragment frag

        // Debug
        // <None>

        // --------------------------------------------------
        // Pass

        // Pragmas
        #pragma prefer_hlslcc gles
        #pragma exclude_renderers d3d11_9x
        #pragma target 2.0
        #pragma multi_compile_fog
        #pragma multi_compile_instancing

        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
        #pragma multi_compile _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS _ADDITIONAL_OFF
        #pragma multi_compile _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile _ _SHADOWS_SOFT
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        // GraphKeywords: <None>

        // Defines
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _AlphaClip 1
        #define _SPECULAR_SETUP
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define VARYINGS_NEED_POSITION_WS 
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_VIEWDIRECTION_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define FEATURES_GRAPH_VERTEX
        #pragma multi_compile_instancing
        #define SHADERPASS_FORWARD
        #define REQUIRE_DEPTH_TEXTURE


        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

        // --------------------------------------------------
        // Graph

        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 Color_F60AF011;
        float Vector1_65AB24F7;
        float4 Color_E3EE7E87;
        float Vector1_E28BDDBB;
        float4 Color_52823E97;
        float Vector1_2316E3C6;
        float Vector1_2ED59376;
        float Vector1_66FC436C;
        float Vector1_CC883DEC;
        float Vector1_AE5B059E;
        float Vector1_6BF8592E;
        float Vector1_1AFFAEB7;
        float Vector1_F0382C7B;
        float Vector1_D6291039;
        float Vector1_99C62EE8;
        float Vector1_DBFE50E5;
        CBUFFER_END
        float3 _Position;
        float _OrthographicCamSize;
        TEXTURE2D(_GlobalEffectRT); SAMPLER(sampler_GlobalEffectRT); float4 _GlobalEffectRT_TexelSize;
        TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture); float4 _CameraOpaqueTexture_TexelSize;
        TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1); SAMPLER(sampler_SampleTexture2D_27B068CA_Texture_1); float4 _SampleTexture2D_27B068CA_Texture_1_TexelSize;
        SAMPLER(_SampleTexture2D_27B068CA_Sampler_3_Linear_Repeat);
        SAMPLER(_SampleTexture2D_9AA6F11C_Sampler_3_Linear_Repeat);

        // Graph Functions

        void Unity_Multiply_float(float A, float B, out float Out)
        {
            Out = A * B;
        }

        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }


        float2 Unity_GradientNoise_Dir_float(float2 p)
        {
            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
            p = p % 289;
            float x = (34 * p.x + 1) * p.x % 289 + p.y;
            x = (34 * x + 1) * x % 289;
            x = frac(x / 41) * 2 - 1;
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }

        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
        {
            float2 p = UV * Scale;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }

        void Unity_Preview_float3(float3 In, out float3 Out)
        {
            Out = In;
        }

        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
        }

        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }

        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }

        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }

        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }

        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }


        inline float2 Unity_Voronoi_RandomVector_float(float2 UV, float offset)
        {
            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            UV = frac(sin(mul(UV, m)) * 46839.32);
            return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
        }

        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
        {
            float2 g = floor(UV * CellDensity);
            float2 f = frac(UV * CellDensity);
            float t = 8.0;
            float3 res = float3(8.0, 0.0, 0.0);

            for (int y = -1; y <= 1; y++)
            {
                for (int x = -1; x <= 1; x++)
                {
                    float2 lattice = float2(x,y);
                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                    float d = distance(lattice + offset, f);

                    if (d < res.x)
                    {
                        res = float3(d, offset.x, offset.y);
                        Out = res.x;
                        Cells = res.y;
                    }
                }
            }
        }

        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }

        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }

        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A - B;
        }

        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A / B;
        }

        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }

        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }

        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }

        // Graph Vertex
        struct VertexDescriptionInputs
        {
            float3 ObjectSpaceNormal;
            float3 ObjectSpaceTangent;
            float3 ObjectSpacePosition;
            float4 uv0;
            float3 TimeParameters;
        };

        struct VertexDescription
        {
            float3 VertexPosition;
            float3 VertexNormal;
            float3 VertexTangent;
        };

        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Split_37EBA153_R_1 = IN.ObjectSpacePosition[0];
            float _Split_37EBA153_G_2 = IN.ObjectSpacePosition[1];
            float _Split_37EBA153_B_3 = IN.ObjectSpacePosition[2];
            float _Split_37EBA153_A_4 = 0;
            float _Property_477CE477_Out_0 = Vector1_D6291039;
            float _Multiply_D063421F_Out_2;
            Unity_Multiply_float(IN.TimeParameters.y, _Property_477CE477_Out_0, _Multiply_D063421F_Out_2);
            float _Multiply_E6FCA4B1_Out_2;
            Unity_Multiply_float(IN.TimeParameters.z, _Property_477CE477_Out_0, _Multiply_E6FCA4B1_Out_2);
            float2 _Vector2_67DD110D_Out_0 = float2(_Multiply_D063421F_Out_2, _Multiply_E6FCA4B1_Out_2);
            float2 _TilingAndOffset_2D63B711_Out_3;
            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_67DD110D_Out_0, _TilingAndOffset_2D63B711_Out_3);
            float _Property_8043A745_Out_0 = Vector1_99C62EE8;
            float _GradientNoise_26E5F82D_Out_2;
            Unity_GradientNoise_float(_TilingAndOffset_2D63B711_Out_3, _Property_8043A745_Out_0, _GradientNoise_26E5F82D_Out_2);
            float _Property_F78F82CD_Out_0 = Vector1_F0382C7B;
            float _Multiply_93625254_Out_2;
            Unity_Multiply_float(_GradientNoise_26E5F82D_Out_2, _Property_F78F82CD_Out_0, _Multiply_93625254_Out_2);
            float3 _Vector3_40DDF711_Out_0 = float3(_Split_37EBA153_R_1, _Multiply_93625254_Out_2, _Split_37EBA153_B_3);
            float3 _Preview_DA5DD73_Out_1;
            Unity_Preview_float3(_Vector3_40DDF711_Out_0, _Preview_DA5DD73_Out_1);
            description.VertexPosition = _Preview_DA5DD73_Out_1;
            description.VertexNormal = IN.ObjectSpaceNormal;
            description.VertexTangent = IN.ObjectSpaceTangent;
            return description;
        }

        // Graph Pixel
        struct SurfaceDescriptionInputs
        {
            float3 TangentSpaceNormal;
            float3 WorldSpacePosition;
            float4 ScreenPosition;
            float4 uv0;
            float3 TimeParameters;
        };

        struct SurfaceDescription
        {
            float3 Albedo;
            float3 Normal;
            float3 Emission;
            float3 Specular;
            float Smoothness;
            float Occlusion;
            float Alpha;
            float AlphaClipThreshold;
        };

        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _SampleTexture2D_27B068CA_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1, sampler_SampleTexture2D_27B068CA_Texture_1, IN.uv0.xy);
            float _SampleTexture2D_27B068CA_R_4 = _SampleTexture2D_27B068CA_RGBA_0.r;
            float _SampleTexture2D_27B068CA_G_5 = _SampleTexture2D_27B068CA_RGBA_0.g;
            float _SampleTexture2D_27B068CA_B_6 = _SampleTexture2D_27B068CA_RGBA_0.b;
            float _SampleTexture2D_27B068CA_A_7 = _SampleTexture2D_27B068CA_RGBA_0.a;
            float4 _Property_6702D913_Out_0 = Color_F60AF011;
            float4 _Property_CEFC8B5B_Out_0 = Color_E3EE7E87;
            float _SceneDepth_7EDDEF17_Out_1;
            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_7EDDEF17_Out_1);
            float4 _ScreenPosition_872442DA_Out_0 = IN.ScreenPosition;
            float _Split_EA314B79_R_1 = _ScreenPosition_872442DA_Out_0[0];
            float _Split_EA314B79_G_2 = _ScreenPosition_872442DA_Out_0[1];
            float _Split_EA314B79_B_3 = _ScreenPosition_872442DA_Out_0[2];
            float _Split_EA314B79_A_4 = _ScreenPosition_872442DA_Out_0[3];
            float _Subtract_59F8F149_Out_2;
            Unity_Subtract_float(_SceneDepth_7EDDEF17_Out_1, _Split_EA314B79_A_4, _Subtract_59F8F149_Out_2);
            float _Property_F28D0DED_Out_0 = Vector1_CC883DEC;
            float _Property_A9460267_Out_0 = Vector1_E28BDDBB;
            float _Add_260D7919_Out_2;
            Unity_Add_float(_Property_F28D0DED_Out_0, _Property_A9460267_Out_0, _Add_260D7919_Out_2);
            float _Divide_4142754B_Out_2;
            Unity_Divide_float(_Subtract_59F8F149_Out_2, _Add_260D7919_Out_2, _Divide_4142754B_Out_2);
            float _Saturate_12CF4DC6_Out_1;
            Unity_Saturate_float(_Divide_4142754B_Out_2, _Saturate_12CF4DC6_Out_1);
            float4 _Lerp_FA7AD557_Out_3;
            Unity_Lerp_float4(_Property_6702D913_Out_0, _Property_CEFC8B5B_Out_0, (_Saturate_12CF4DC6_Out_1.xxxx), _Lerp_FA7AD557_Out_3);
            float4 _Property_F1522DD3_Out_0 = Color_52823E97;
            float _Property_70259FA0_Out_0 = Vector1_2316E3C6;
            float _Multiply_5AEF6903_Out_2;
            Unity_Multiply_float(_Saturate_12CF4DC6_Out_1, _Property_70259FA0_Out_0, _Multiply_5AEF6903_Out_2);
            float _Property_5F725E07_Out_0 = Vector1_66FC436C;
            float _Multiply_A91F9DCF_Out_2;
            Unity_Multiply_float(IN.TimeParameters.x, _Property_5F725E07_Out_0, _Multiply_A91F9DCF_Out_2);
            float _Property_4A5A0F8D_Out_0 = Vector1_AE5B059E;
            float _Voronoi_2E9EB71C_Out_3;
            float _Voronoi_2E9EB71C_Cells_4;
            Unity_Voronoi_float(IN.uv0.xy, _Multiply_A91F9DCF_Out_2, _Property_4A5A0F8D_Out_0, _Voronoi_2E9EB71C_Out_3, _Voronoi_2E9EB71C_Cells_4);
            float _Step_7D59C98C_Out_2;
            Unity_Step_float(_Multiply_5AEF6903_Out_2, _Voronoi_2E9EB71C_Out_3, _Step_7D59C98C_Out_2);
            float4 _Property_E90698F0_Out_0 = Color_52823E97;
            float _Split_3D34AA68_R_1 = _Property_E90698F0_Out_0[0];
            float _Split_3D34AA68_G_2 = _Property_E90698F0_Out_0[1];
            float _Split_3D34AA68_B_3 = _Property_E90698F0_Out_0[2];
            float _Split_3D34AA68_A_4 = _Property_E90698F0_Out_0[3];
            float _Multiply_2270B01B_Out_2;
            Unity_Multiply_float(_Step_7D59C98C_Out_2, _Split_3D34AA68_R_1, _Multiply_2270B01B_Out_2);
            float4 _Lerp_4FB1C64B_Out_3;
            Unity_Lerp_float4(_Lerp_FA7AD557_Out_3, _Property_F1522DD3_Out_0, (_Multiply_2270B01B_Out_2.xxxx), _Lerp_4FB1C64B_Out_3);
            float _Split_9C8A7112_R_1 = _Lerp_4FB1C64B_Out_3[0];
            float _Split_9C8A7112_G_2 = _Lerp_4FB1C64B_Out_3[1];
            float _Split_9C8A7112_B_3 = _Lerp_4FB1C64B_Out_3[2];
            float _Split_9C8A7112_A_4 = _Lerp_4FB1C64B_Out_3[3];
            float4 _Lerp_3C9253_Out_3;
            Unity_Lerp_float4(float4(0, 0, 0, 0), _Lerp_4FB1C64B_Out_3, (_Split_9C8A7112_R_1.xxxx), _Lerp_3C9253_Out_3);
            float _Property_B614F02A_Out_0 = Vector1_2ED59376;
            float4 _Multiply_FB74F68D_Out_2;
            Unity_Multiply_float(_Lerp_3C9253_Out_3, (_Property_B614F02A_Out_0.xxxx), _Multiply_FB74F68D_Out_2);
            float4 _Property_E1004808_Out_0 = Color_F60AF011;
            float _Property_66B8C6D2_Out_0 = Vector1_1AFFAEB7;
            float _Property_8A60AF8B_Out_0 = Vector1_6BF8592E;
            float _Add_2971794_Out_2;
            Unity_Add_float(_Property_8A60AF8B_Out_0, 0.05, _Add_2971794_Out_2);
            float _Split_6DB6236C_R_1 = IN.WorldSpacePosition[0];
            float _Split_6DB6236C_G_2 = IN.WorldSpacePosition[1];
            float _Split_6DB6236C_B_3 = IN.WorldSpacePosition[2];
            float _Split_6DB6236C_A_4 = 0;
            float2 _Vector2_4BFCE0C4_Out_0 = float2(_Split_6DB6236C_R_1, _Split_6DB6236C_B_3);
            float3 _Property_F7034583_Out_0 = _Position;
            float _Split_672751AE_R_1 = _Property_F7034583_Out_0[0];
            float _Split_672751AE_G_2 = _Property_F7034583_Out_0[1];
            float _Split_672751AE_B_3 = _Property_F7034583_Out_0[2];
            float _Split_672751AE_A_4 = 0;
            float2 _Vector2_1063291D_Out_0 = float2(_Split_672751AE_R_1, _Split_672751AE_B_3);
            float2 _Subtract_AC24825A_Out_2;
            Unity_Subtract_float2(_Vector2_4BFCE0C4_Out_0, _Vector2_1063291D_Out_0, _Subtract_AC24825A_Out_2);
            float _Property_EF6B0F9F_Out_0 = _OrthographicCamSize;
            float _Multiply_1B6615E9_Out_2;
            Unity_Multiply_float(_Property_EF6B0F9F_Out_0, 2, _Multiply_1B6615E9_Out_2);
            float2 _Divide_AEF8CF71_Out_2;
            Unity_Divide_float2(_Subtract_AC24825A_Out_2, (_Multiply_1B6615E9_Out_2.xx), _Divide_AEF8CF71_Out_2);
            float2 _Add_26BEDED0_Out_2;
            Unity_Add_float2(_Divide_AEF8CF71_Out_2, float2(0.5, 0.5), _Add_26BEDED0_Out_2);
            float4 _SampleTexture2D_9AA6F11C_RGBA_0 = SAMPLE_TEXTURE2D(_GlobalEffectRT, sampler_GlobalEffectRT, _Add_26BEDED0_Out_2);
            float _SampleTexture2D_9AA6F11C_R_4 = _SampleTexture2D_9AA6F11C_RGBA_0.r;
            float _SampleTexture2D_9AA6F11C_G_5 = _SampleTexture2D_9AA6F11C_RGBA_0.g;
            float _SampleTexture2D_9AA6F11C_B_6 = _SampleTexture2D_9AA6F11C_RGBA_0.b;
            float _SampleTexture2D_9AA6F11C_A_7 = _SampleTexture2D_9AA6F11C_RGBA_0.a;
            float _Smoothstep_558DAB99_Out_3;
            Unity_Smoothstep_float(_Property_8A60AF8B_Out_0, _Add_2971794_Out_2, _SampleTexture2D_9AA6F11C_B_6, _Smoothstep_558DAB99_Out_3);
            float _Saturate_C43EA012_Out_1;
            Unity_Saturate_float(_Smoothstep_558DAB99_Out_3, _Saturate_C43EA012_Out_1);
            float4 _Property_88B70072_Out_0 = Color_52823E97;
            float4 _Multiply_1F24AC84_Out_2;
            Unity_Multiply_float((_Saturate_C43EA012_Out_1.xxxx), _Property_88B70072_Out_0, _Multiply_1F24AC84_Out_2);
            float4 _Multiply_D81E7E9E_Out_2;
            Unity_Multiply_float((_Property_66B8C6D2_Out_0.xxxx), _Multiply_1F24AC84_Out_2, _Multiply_D81E7E9E_Out_2);
            float4 _Add_3ADB8553_Out_2;
            Unity_Add_float4(_Property_E1004808_Out_0, _Multiply_D81E7E9E_Out_2, _Add_3ADB8553_Out_2);
            float4 _Add_3F48AADE_Out_2;
            Unity_Add_float4(_Multiply_FB74F68D_Out_2, _Add_3ADB8553_Out_2, _Add_3F48AADE_Out_2);
            float4 _Multiply_C78C0F0E_Out_2;
            Unity_Multiply_float(_SampleTexture2D_27B068CA_RGBA_0, _Add_3F48AADE_Out_2, _Multiply_C78C0F0E_Out_2);
            float _Property_DCC89B67_Out_0 = Vector1_DBFE50E5;
            surface.Albedo = (_Multiply_C78C0F0E_Out_2.xyz);
            surface.Normal = IN.TangentSpaceNormal;
            surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
            surface.Specular = IsGammaSpace() ? float3(0.3207547, 0.3207547, 0.3207547) : SRGBToLinear(float3(0.3207547, 0.3207547, 0.3207547));
            surface.Smoothness = _Property_DCC89B67_Out_0;
            surface.Occlusion = 1;
            surface.Alpha = (_SampleTexture2D_27B068CA_RGBA_0).x;
            surface.AlphaClipThreshold = 0.5;
            return surface;
        }

        // --------------------------------------------------
        // Structs and Packing

        // Generated Type: Attributes
        struct Attributes
        {
            float3 positionOS : POSITION;
            float3 normalOS : NORMAL;
            float4 tangentOS : TANGENT;
            float4 uv0 : TEXCOORD0;
            float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };

        // Generated Type: Varyings
        struct Varyings
        {
            float4 positionCS : SV_POSITION;
            float3 positionWS;
            float3 normalWS;
            float4 tangentWS;
            float4 texCoord0;
            float3 viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            float2 lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            float3 sh;
            #endif
            float4 fogFactorAndVertexLight;
            float4 shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

        // Generated Type: PackedVaryings
        struct PackedVaryings
        {
            float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
            #endif
            #if !defined(LIGHTMAP_ON)
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED
            uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            float3 interp00 : TEXCOORD0;
            float3 interp01 : TEXCOORD1;
            float4 interp02 : TEXCOORD2;
            float4 interp03 : TEXCOORD3;
            float3 interp04 : TEXCOORD4;
            float2 interp05 : TEXCOORD5;
            float3 interp06 : TEXCOORD6;
            float4 interp07 : TEXCOORD7;
            float4 interp08 : TEXCOORD8;
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };

        // Packed Type: Varyings
        PackedVaryings PackVaryings(Varyings input)
        {
            PackedVaryings output = (PackedVaryings)0;
            output.positionCS = input.positionCS;
            output.interp00.xyz = input.positionWS;
            output.interp01.xyz = input.normalWS;
            output.interp02.xyzw = input.tangentWS;
            output.interp03.xyzw = input.texCoord0;
            output.interp04.xyz = input.viewDirectionWS;
            #if defined(LIGHTMAP_ON)
            output.interp05.xy = input.lightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.interp06.xyz = input.sh;
            #endif
            output.interp07.xyzw = input.fogFactorAndVertexLight;
            output.interp08.xyzw = input.shadowCoord;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

        // Unpacked Type: Varyings
        Varyings UnpackVaryings(PackedVaryings input)
        {
            Varyings output = (Varyings)0;
            output.positionCS = input.positionCS;
            output.positionWS = input.interp00.xyz;
            output.normalWS = input.interp01.xyz;
            output.tangentWS = input.interp02.xyzw;
            output.texCoord0 = input.interp03.xyzw;
            output.viewDirectionWS = input.interp04.xyz;
            #if defined(LIGHTMAP_ON)
            output.lightmapUV = input.interp05.xy;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.interp06.xyz;
            #endif
            output.fogFactorAndVertexLight = input.interp07.xyzw;
            output.shadowCoord = input.interp08.xyzw;
            #if UNITY_ANY_INSTANCING_ENABLED
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }

        // --------------------------------------------------
        // Build Graph Inputs

        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);

            output.ObjectSpaceNormal = input.normalOS;
            output.ObjectSpaceTangent = input.tangentOS;
            output.ObjectSpacePosition = input.positionOS;
            output.uv0 = input.uv0;
            output.TimeParameters = _TimeParameters.xyz;

            return output;
        }

        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
            output.uv0 = input.texCoord0;
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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
            Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
            Cull Off
            ZTest LEqual
            ZWrite On
            // ColorMask: <None>


            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            // Debug
            // <None>

            // --------------------------------------------------
            // Pass

            // Pragmas
            #pragma prefer_hlslcc gles
            #pragma exclude_renderers d3d11_9x
            #pragma target 2.0
            #pragma multi_compile_instancing

            // Keywords
            // PassKeywords: <None>
            // GraphKeywords: <None>

            // Defines
            #define _SURFACE_TYPE_TRANSPARENT 1
            #define _AlphaClip 1
            #define _SPECULAR_SETUP
            #define _NORMAL_DROPOFF_TS 1
            #define ATTRIBUTES_NEED_NORMAL
            #define ATTRIBUTES_NEED_TANGENT
            #define ATTRIBUTES_NEED_TEXCOORD0
            #define VARYINGS_NEED_TEXCOORD0
            #define FEATURES_GRAPH_VERTEX
            #pragma multi_compile_instancing
            #define SHADERPASS_SHADOWCASTER


            // Includes
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
            #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

            // --------------------------------------------------
            // Graph

            // Graph Properties
            CBUFFER_START(UnityPerMaterial)
            float4 Color_F60AF011;
            float Vector1_65AB24F7;
            float4 Color_E3EE7E87;
            float Vector1_E28BDDBB;
            float4 Color_52823E97;
            float Vector1_2316E3C6;
            float Vector1_2ED59376;
            float Vector1_66FC436C;
            float Vector1_CC883DEC;
            float Vector1_AE5B059E;
            float Vector1_6BF8592E;
            float Vector1_1AFFAEB7;
            float Vector1_F0382C7B;
            float Vector1_D6291039;
            float Vector1_99C62EE8;
            float Vector1_DBFE50E5;
            CBUFFER_END
            float3 _Position;
            float _OrthographicCamSize;
            TEXTURE2D(_GlobalEffectRT); SAMPLER(sampler_GlobalEffectRT); float4 _GlobalEffectRT_TexelSize;
            TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture); float4 _CameraOpaqueTexture_TexelSize;
            TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1); SAMPLER(sampler_SampleTexture2D_27B068CA_Texture_1); float4 _SampleTexture2D_27B068CA_Texture_1_TexelSize;
            SAMPLER(_SampleTexture2D_27B068CA_Sampler_3_Linear_Repeat);

            // Graph Functions

            void Unity_Multiply_float(float A, float B, out float Out)
            {
                Out = A * B;
            }

            void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
            {
                Out = UV * Tiling + Offset;
            }


            float2 Unity_GradientNoise_Dir_float(float2 p)
            {
                // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                p = p % 289;
                float x = (34 * p.x + 1) * p.x % 289 + p.y;
                x = (34 * x + 1) * x % 289;
                x = frac(x / 41) * 2 - 1;
                return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
            }

            void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
            {
                float2 p = UV * Scale;
                float2 ip = floor(p);
                float2 fp = frac(p);
                float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
            }

            void Unity_Preview_float3(float3 In, out float3 Out)
            {
                Out = In;
            }

            // Graph Vertex
            struct VertexDescriptionInputs
            {
                float3 ObjectSpaceNormal;
                float3 ObjectSpaceTangent;
                float3 ObjectSpacePosition;
                float4 uv0;
                float3 TimeParameters;
            };

            struct VertexDescription
            {
                float3 VertexPosition;
                float3 VertexNormal;
                float3 VertexTangent;
            };

            VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
            {
                VertexDescription description = (VertexDescription)0;
                float _Split_37EBA153_R_1 = IN.ObjectSpacePosition[0];
                float _Split_37EBA153_G_2 = IN.ObjectSpacePosition[1];
                float _Split_37EBA153_B_3 = IN.ObjectSpacePosition[2];
                float _Split_37EBA153_A_4 = 0;
                float _Property_477CE477_Out_0 = Vector1_D6291039;
                float _Multiply_D063421F_Out_2;
                Unity_Multiply_float(IN.TimeParameters.y, _Property_477CE477_Out_0, _Multiply_D063421F_Out_2);
                float _Multiply_E6FCA4B1_Out_2;
                Unity_Multiply_float(IN.TimeParameters.z, _Property_477CE477_Out_0, _Multiply_E6FCA4B1_Out_2);
                float2 _Vector2_67DD110D_Out_0 = float2(_Multiply_D063421F_Out_2, _Multiply_E6FCA4B1_Out_2);
                float2 _TilingAndOffset_2D63B711_Out_3;
                Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_67DD110D_Out_0, _TilingAndOffset_2D63B711_Out_3);
                float _Property_8043A745_Out_0 = Vector1_99C62EE8;
                float _GradientNoise_26E5F82D_Out_2;
                Unity_GradientNoise_float(_TilingAndOffset_2D63B711_Out_3, _Property_8043A745_Out_0, _GradientNoise_26E5F82D_Out_2);
                float _Property_F78F82CD_Out_0 = Vector1_F0382C7B;
                float _Multiply_93625254_Out_2;
                Unity_Multiply_float(_GradientNoise_26E5F82D_Out_2, _Property_F78F82CD_Out_0, _Multiply_93625254_Out_2);
                float3 _Vector3_40DDF711_Out_0 = float3(_Split_37EBA153_R_1, _Multiply_93625254_Out_2, _Split_37EBA153_B_3);
                float3 _Preview_DA5DD73_Out_1;
                Unity_Preview_float3(_Vector3_40DDF711_Out_0, _Preview_DA5DD73_Out_1);
                description.VertexPosition = _Preview_DA5DD73_Out_1;
                description.VertexNormal = IN.ObjectSpaceNormal;
                description.VertexTangent = IN.ObjectSpaceTangent;
                return description;
            }

            // Graph Pixel
            struct SurfaceDescriptionInputs
            {
                float3 TangentSpaceNormal;
                float4 uv0;
            };

            struct SurfaceDescription
            {
                float Alpha;
                float AlphaClipThreshold;
            };

            SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
            {
                SurfaceDescription surface = (SurfaceDescription)0;
                float4 _SampleTexture2D_27B068CA_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1, sampler_SampleTexture2D_27B068CA_Texture_1, IN.uv0.xy);
                float _SampleTexture2D_27B068CA_R_4 = _SampleTexture2D_27B068CA_RGBA_0.r;
                float _SampleTexture2D_27B068CA_G_5 = _SampleTexture2D_27B068CA_RGBA_0.g;
                float _SampleTexture2D_27B068CA_B_6 = _SampleTexture2D_27B068CA_RGBA_0.b;
                float _SampleTexture2D_27B068CA_A_7 = _SampleTexture2D_27B068CA_RGBA_0.a;
                surface.Alpha = (_SampleTexture2D_27B068CA_RGBA_0).x;
                surface.AlphaClipThreshold = 0.5;
                return surface;
            }

            // --------------------------------------------------
            // Structs and Packing

            // Generated Type: Attributes
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS : NORMAL;
                float4 tangentOS : TANGENT;
                float4 uv0 : TEXCOORD0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : INSTANCEID_SEMANTIC;
                #endif
            };

            // Generated Type: Varyings
            struct Varyings
            {
                float4 positionCS : SV_POSITION;
                float4 texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Generated Type: PackedVaryings
            struct PackedVaryings
            {
                float4 positionCS : SV_POSITION;
                #if UNITY_ANY_INSTANCING_ENABLED
                uint instanceID : CUSTOM_INSTANCE_ID;
                #endif
                float4 interp00 : TEXCOORD0;
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                #endif
            };

            // Packed Type: Varyings
            PackedVaryings PackVaryings(Varyings input)
            {
                PackedVaryings output = (PackedVaryings)0;
                output.positionCS = input.positionCS;
                output.interp00.xyzw = input.texCoord0;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // Unpacked Type: Varyings
            Varyings UnpackVaryings(PackedVaryings input)
            {
                Varyings output = (Varyings)0;
                output.positionCS = input.positionCS;
                output.texCoord0 = input.interp00.xyzw;
                #if UNITY_ANY_INSTANCING_ENABLED
                output.instanceID = input.instanceID;
                #endif
                #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                #endif
                #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                #endif
                #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                output.cullFace = input.cullFace;
                #endif
                return output;
            }

            // --------------------------------------------------
            // Build Graph Inputs

            VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
            {
                VertexDescriptionInputs output;
                ZERO_INITIALIZE(VertexDescriptionInputs, output);

                output.ObjectSpaceNormal = input.normalOS;
                output.ObjectSpaceTangent = input.tangentOS;
                output.ObjectSpacePosition = input.positionOS;
                output.uv0 = input.uv0;
                output.TimeParameters = _TimeParameters.xyz;

                return output;
            }

            SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
            {
                SurfaceDescriptionInputs output;
                ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



                output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                output.uv0 = input.texCoord0;
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
                Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                Cull Off
                ZTest LEqual
                ZWrite On
                ColorMask 0


                HLSLPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                // Debug
                // <None>

                // --------------------------------------------------
                // Pass

                // Pragmas
                #pragma prefer_hlslcc gles
                #pragma exclude_renderers d3d11_9x
                #pragma target 2.0
                #pragma multi_compile_instancing

                // Keywords
                // PassKeywords: <None>
                // GraphKeywords: <None>

                // Defines
                #define _SURFACE_TYPE_TRANSPARENT 1
                #define _AlphaClip 1
                #define _SPECULAR_SETUP
                #define _NORMAL_DROPOFF_TS 1
                #define ATTRIBUTES_NEED_NORMAL
                #define ATTRIBUTES_NEED_TANGENT
                #define ATTRIBUTES_NEED_TEXCOORD0
                #define VARYINGS_NEED_TEXCOORD0
                #define FEATURES_GRAPH_VERTEX
                #pragma multi_compile_instancing
                #define SHADERPASS_DEPTHONLY


                // Includes
                #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                // --------------------------------------------------
                // Graph

                // Graph Properties
                CBUFFER_START(UnityPerMaterial)
                float4 Color_F60AF011;
                float Vector1_65AB24F7;
                float4 Color_E3EE7E87;
                float Vector1_E28BDDBB;
                float4 Color_52823E97;
                float Vector1_2316E3C6;
                float Vector1_2ED59376;
                float Vector1_66FC436C;
                float Vector1_CC883DEC;
                float Vector1_AE5B059E;
                float Vector1_6BF8592E;
                float Vector1_1AFFAEB7;
                float Vector1_F0382C7B;
                float Vector1_D6291039;
                float Vector1_99C62EE8;
                float Vector1_DBFE50E5;
                CBUFFER_END
                float3 _Position;
                float _OrthographicCamSize;
                TEXTURE2D(_GlobalEffectRT); SAMPLER(sampler_GlobalEffectRT); float4 _GlobalEffectRT_TexelSize;
                TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture); float4 _CameraOpaqueTexture_TexelSize;
                TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1); SAMPLER(sampler_SampleTexture2D_27B068CA_Texture_1); float4 _SampleTexture2D_27B068CA_Texture_1_TexelSize;
                SAMPLER(_SampleTexture2D_27B068CA_Sampler_3_Linear_Repeat);

                // Graph Functions

                void Unity_Multiply_float(float A, float B, out float Out)
                {
                    Out = A * B;
                }

                void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                {
                    Out = UV * Tiling + Offset;
                }


                float2 Unity_GradientNoise_Dir_float(float2 p)
                {
                    // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                    p = p % 289;
                    float x = (34 * p.x + 1) * p.x % 289 + p.y;
                    x = (34 * x + 1) * x % 289;
                    x = frac(x / 41) * 2 - 1;
                    return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                }

                void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                {
                    float2 p = UV * Scale;
                    float2 ip = floor(p);
                    float2 fp = frac(p);
                    float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                    float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                    float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                    float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                    fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                    Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                }

                void Unity_Preview_float3(float3 In, out float3 Out)
                {
                    Out = In;
                }

                // Graph Vertex
                struct VertexDescriptionInputs
                {
                    float3 ObjectSpaceNormal;
                    float3 ObjectSpaceTangent;
                    float3 ObjectSpacePosition;
                    float4 uv0;
                    float3 TimeParameters;
                };

                struct VertexDescription
                {
                    float3 VertexPosition;
                    float3 VertexNormal;
                    float3 VertexTangent;
                };

                VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                {
                    VertexDescription description = (VertexDescription)0;
                    float _Split_37EBA153_R_1 = IN.ObjectSpacePosition[0];
                    float _Split_37EBA153_G_2 = IN.ObjectSpacePosition[1];
                    float _Split_37EBA153_B_3 = IN.ObjectSpacePosition[2];
                    float _Split_37EBA153_A_4 = 0;
                    float _Property_477CE477_Out_0 = Vector1_D6291039;
                    float _Multiply_D063421F_Out_2;
                    Unity_Multiply_float(IN.TimeParameters.y, _Property_477CE477_Out_0, _Multiply_D063421F_Out_2);
                    float _Multiply_E6FCA4B1_Out_2;
                    Unity_Multiply_float(IN.TimeParameters.z, _Property_477CE477_Out_0, _Multiply_E6FCA4B1_Out_2);
                    float2 _Vector2_67DD110D_Out_0 = float2(_Multiply_D063421F_Out_2, _Multiply_E6FCA4B1_Out_2);
                    float2 _TilingAndOffset_2D63B711_Out_3;
                    Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_67DD110D_Out_0, _TilingAndOffset_2D63B711_Out_3);
                    float _Property_8043A745_Out_0 = Vector1_99C62EE8;
                    float _GradientNoise_26E5F82D_Out_2;
                    Unity_GradientNoise_float(_TilingAndOffset_2D63B711_Out_3, _Property_8043A745_Out_0, _GradientNoise_26E5F82D_Out_2);
                    float _Property_F78F82CD_Out_0 = Vector1_F0382C7B;
                    float _Multiply_93625254_Out_2;
                    Unity_Multiply_float(_GradientNoise_26E5F82D_Out_2, _Property_F78F82CD_Out_0, _Multiply_93625254_Out_2);
                    float3 _Vector3_40DDF711_Out_0 = float3(_Split_37EBA153_R_1, _Multiply_93625254_Out_2, _Split_37EBA153_B_3);
                    float3 _Preview_DA5DD73_Out_1;
                    Unity_Preview_float3(_Vector3_40DDF711_Out_0, _Preview_DA5DD73_Out_1);
                    description.VertexPosition = _Preview_DA5DD73_Out_1;
                    description.VertexNormal = IN.ObjectSpaceNormal;
                    description.VertexTangent = IN.ObjectSpaceTangent;
                    return description;
                }

                // Graph Pixel
                struct SurfaceDescriptionInputs
                {
                    float3 TangentSpaceNormal;
                    float4 uv0;
                };

                struct SurfaceDescription
                {
                    float Alpha;
                    float AlphaClipThreshold;
                };

                SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                {
                    SurfaceDescription surface = (SurfaceDescription)0;
                    float4 _SampleTexture2D_27B068CA_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1, sampler_SampleTexture2D_27B068CA_Texture_1, IN.uv0.xy);
                    float _SampleTexture2D_27B068CA_R_4 = _SampleTexture2D_27B068CA_RGBA_0.r;
                    float _SampleTexture2D_27B068CA_G_5 = _SampleTexture2D_27B068CA_RGBA_0.g;
                    float _SampleTexture2D_27B068CA_B_6 = _SampleTexture2D_27B068CA_RGBA_0.b;
                    float _SampleTexture2D_27B068CA_A_7 = _SampleTexture2D_27B068CA_RGBA_0.a;
                    surface.Alpha = (_SampleTexture2D_27B068CA_RGBA_0).x;
                    surface.AlphaClipThreshold = 0.5;
                    return surface;
                }

                // --------------------------------------------------
                // Structs and Packing

                // Generated Type: Attributes
                struct Attributes
                {
                    float3 positionOS : POSITION;
                    float3 normalOS : NORMAL;
                    float4 tangentOS : TANGENT;
                    float4 uv0 : TEXCOORD0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : INSTANCEID_SEMANTIC;
                    #endif
                };

                // Generated Type: Varyings
                struct Varyings
                {
                    float4 positionCS : SV_POSITION;
                    float4 texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Generated Type: PackedVaryings
                struct PackedVaryings
                {
                    float4 positionCS : SV_POSITION;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    uint instanceID : CUSTOM_INSTANCE_ID;
                    #endif
                    float4 interp00 : TEXCOORD0;
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                    #endif
                };

                // Packed Type: Varyings
                PackedVaryings PackVaryings(Varyings input)
                {
                    PackedVaryings output = (PackedVaryings)0;
                    output.positionCS = input.positionCS;
                    output.interp00.xyzw = input.texCoord0;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // Unpacked Type: Varyings
                Varyings UnpackVaryings(PackedVaryings input)
                {
                    Varyings output = (Varyings)0;
                    output.positionCS = input.positionCS;
                    output.texCoord0 = input.interp00.xyzw;
                    #if UNITY_ANY_INSTANCING_ENABLED
                    output.instanceID = input.instanceID;
                    #endif
                    #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                    output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                    #endif
                    #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                    output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                    #endif
                    #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                    output.cullFace = input.cullFace;
                    #endif
                    return output;
                }

                // --------------------------------------------------
                // Build Graph Inputs

                VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                {
                    VertexDescriptionInputs output;
                    ZERO_INITIALIZE(VertexDescriptionInputs, output);

                    output.ObjectSpaceNormal = input.normalOS;
                    output.ObjectSpaceTangent = input.tangentOS;
                    output.ObjectSpacePosition = input.positionOS;
                    output.uv0 = input.uv0;
                    output.TimeParameters = _TimeParameters.xyz;

                    return output;
                }

                SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                {
                    SurfaceDescriptionInputs output;
                    ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



                    output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                    output.uv0 = input.texCoord0;
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
                    Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                    Cull Off
                    ZTest LEqual
                    ZWrite On
                    // ColorMask: <None>


                    HLSLPROGRAM
                    #pragma vertex vert
                    #pragma fragment frag

                    // Debug
                    // <None>

                    // --------------------------------------------------
                    // Pass

                    // Pragmas
                    #pragma prefer_hlslcc gles
                    #pragma exclude_renderers d3d11_9x
                    #pragma target 2.0

                    // Keywords
                    #pragma shader_feature _ _SMOOTHNESS_TEXTURE_ALBEDO_CHANNEL_A
                    // GraphKeywords: <None>

                    // Defines
                    #define _SURFACE_TYPE_TRANSPARENT 1
                    #define _AlphaClip 1
                    #define _SPECULAR_SETUP
                    #define _NORMAL_DROPOFF_TS 1
                    #define ATTRIBUTES_NEED_NORMAL
                    #define ATTRIBUTES_NEED_TANGENT
                    #define ATTRIBUTES_NEED_TEXCOORD0
                    #define ATTRIBUTES_NEED_TEXCOORD1
                    #define ATTRIBUTES_NEED_TEXCOORD2
                    #define VARYINGS_NEED_POSITION_WS 
                    #define VARYINGS_NEED_TEXCOORD0
                    #define FEATURES_GRAPH_VERTEX
                    #pragma multi_compile_instancing
                    #define SHADERPASS_META
                    #define REQUIRE_DEPTH_TEXTURE


                    // Includes
                    #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                    #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
                    #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                    // --------------------------------------------------
                    // Graph

                    // Graph Properties
                    CBUFFER_START(UnityPerMaterial)
                    float4 Color_F60AF011;
                    float Vector1_65AB24F7;
                    float4 Color_E3EE7E87;
                    float Vector1_E28BDDBB;
                    float4 Color_52823E97;
                    float Vector1_2316E3C6;
                    float Vector1_2ED59376;
                    float Vector1_66FC436C;
                    float Vector1_CC883DEC;
                    float Vector1_AE5B059E;
                    float Vector1_6BF8592E;
                    float Vector1_1AFFAEB7;
                    float Vector1_F0382C7B;
                    float Vector1_D6291039;
                    float Vector1_99C62EE8;
                    float Vector1_DBFE50E5;
                    CBUFFER_END
                    float3 _Position;
                    float _OrthographicCamSize;
                    TEXTURE2D(_GlobalEffectRT); SAMPLER(sampler_GlobalEffectRT); float4 _GlobalEffectRT_TexelSize;
                    TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture); float4 _CameraOpaqueTexture_TexelSize;
                    TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1); SAMPLER(sampler_SampleTexture2D_27B068CA_Texture_1); float4 _SampleTexture2D_27B068CA_Texture_1_TexelSize;
                    SAMPLER(_SampleTexture2D_27B068CA_Sampler_3_Linear_Repeat);
                    SAMPLER(_SampleTexture2D_9AA6F11C_Sampler_3_Linear_Repeat);

                    // Graph Functions

                    void Unity_Multiply_float(float A, float B, out float Out)
                    {
                        Out = A * B;
                    }

                    void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                    {
                        Out = UV * Tiling + Offset;
                    }


                    float2 Unity_GradientNoise_Dir_float(float2 p)
                    {
                        // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                        p = p % 289;
                        float x = (34 * p.x + 1) * p.x % 289 + p.y;
                        x = (34 * x + 1) * x % 289;
                        x = frac(x / 41) * 2 - 1;
                        return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                    }

                    void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                    {
                        float2 p = UV * Scale;
                        float2 ip = floor(p);
                        float2 fp = frac(p);
                        float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                        float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                        float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                        float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                        fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                        Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                    }

                    void Unity_Preview_float3(float3 In, out float3 Out)
                    {
                        Out = In;
                    }

                    void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                    {
                        Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                    }

                    void Unity_Subtract_float(float A, float B, out float Out)
                    {
                        Out = A - B;
                    }

                    void Unity_Add_float(float A, float B, out float Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Divide_float(float A, float B, out float Out)
                    {
                        Out = A / B;
                    }

                    void Unity_Saturate_float(float In, out float Out)
                    {
                        Out = saturate(In);
                    }

                    void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                    {
                        Out = lerp(A, B, T);
                    }


                    inline float2 Unity_Voronoi_RandomVector_float(float2 UV, float offset)
                    {
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
                        UV = frac(sin(mul(UV, m)) * 46839.32);
                        return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
                    }

                    void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
                    {
                        float2 g = floor(UV * CellDensity);
                        float2 f = frac(UV * CellDensity);
                        float t = 8.0;
                        float3 res = float3(8.0, 0.0, 0.0);

                        for (int y = -1; y <= 1; y++)
                        {
                            for (int x = -1; x <= 1; x++)
                            {
                                float2 lattice = float2(x,y);
                                float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                                float d = distance(lattice + offset, f);

                                if (d < res.x)
                                {
                                    res = float3(d, offset.x, offset.y);
                                    Out = res.x;
                                    Cells = res.y;
                                }
                            }
                        }
                    }

                    void Unity_Step_float(float Edge, float In, out float Out)
                    {
                        Out = step(Edge, In);
                    }

                    void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                    {
                        Out = A * B;
                    }

                    void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A - B;
                    }

                    void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A / B;
                    }

                    void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                    {
                        Out = A + B;
                    }

                    void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                    {
                        Out = smoothstep(Edge1, Edge2, In);
                    }

                    void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                    {
                        Out = A + B;
                    }

                    // Graph Vertex
                    struct VertexDescriptionInputs
                    {
                        float3 ObjectSpaceNormal;
                        float3 ObjectSpaceTangent;
                        float3 ObjectSpacePosition;
                        float4 uv0;
                        float3 TimeParameters;
                    };

                    struct VertexDescription
                    {
                        float3 VertexPosition;
                        float3 VertexNormal;
                        float3 VertexTangent;
                    };

                    VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                    {
                        VertexDescription description = (VertexDescription)0;
                        float _Split_37EBA153_R_1 = IN.ObjectSpacePosition[0];
                        float _Split_37EBA153_G_2 = IN.ObjectSpacePosition[1];
                        float _Split_37EBA153_B_3 = IN.ObjectSpacePosition[2];
                        float _Split_37EBA153_A_4 = 0;
                        float _Property_477CE477_Out_0 = Vector1_D6291039;
                        float _Multiply_D063421F_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.y, _Property_477CE477_Out_0, _Multiply_D063421F_Out_2);
                        float _Multiply_E6FCA4B1_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.z, _Property_477CE477_Out_0, _Multiply_E6FCA4B1_Out_2);
                        float2 _Vector2_67DD110D_Out_0 = float2(_Multiply_D063421F_Out_2, _Multiply_E6FCA4B1_Out_2);
                        float2 _TilingAndOffset_2D63B711_Out_3;
                        Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_67DD110D_Out_0, _TilingAndOffset_2D63B711_Out_3);
                        float _Property_8043A745_Out_0 = Vector1_99C62EE8;
                        float _GradientNoise_26E5F82D_Out_2;
                        Unity_GradientNoise_float(_TilingAndOffset_2D63B711_Out_3, _Property_8043A745_Out_0, _GradientNoise_26E5F82D_Out_2);
                        float _Property_F78F82CD_Out_0 = Vector1_F0382C7B;
                        float _Multiply_93625254_Out_2;
                        Unity_Multiply_float(_GradientNoise_26E5F82D_Out_2, _Property_F78F82CD_Out_0, _Multiply_93625254_Out_2);
                        float3 _Vector3_40DDF711_Out_0 = float3(_Split_37EBA153_R_1, _Multiply_93625254_Out_2, _Split_37EBA153_B_3);
                        float3 _Preview_DA5DD73_Out_1;
                        Unity_Preview_float3(_Vector3_40DDF711_Out_0, _Preview_DA5DD73_Out_1);
                        description.VertexPosition = _Preview_DA5DD73_Out_1;
                        description.VertexNormal = IN.ObjectSpaceNormal;
                        description.VertexTangent = IN.ObjectSpaceTangent;
                        return description;
                    }

                    // Graph Pixel
                    struct SurfaceDescriptionInputs
                    {
                        float3 TangentSpaceNormal;
                        float3 WorldSpacePosition;
                        float4 ScreenPosition;
                        float4 uv0;
                        float3 TimeParameters;
                    };

                    struct SurfaceDescription
                    {
                        float3 Albedo;
                        float3 Emission;
                        float Alpha;
                        float AlphaClipThreshold;
                    };

                    SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                    {
                        SurfaceDescription surface = (SurfaceDescription)0;
                        float4 _SampleTexture2D_27B068CA_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1, sampler_SampleTexture2D_27B068CA_Texture_1, IN.uv0.xy);
                        float _SampleTexture2D_27B068CA_R_4 = _SampleTexture2D_27B068CA_RGBA_0.r;
                        float _SampleTexture2D_27B068CA_G_5 = _SampleTexture2D_27B068CA_RGBA_0.g;
                        float _SampleTexture2D_27B068CA_B_6 = _SampleTexture2D_27B068CA_RGBA_0.b;
                        float _SampleTexture2D_27B068CA_A_7 = _SampleTexture2D_27B068CA_RGBA_0.a;
                        float4 _Property_6702D913_Out_0 = Color_F60AF011;
                        float4 _Property_CEFC8B5B_Out_0 = Color_E3EE7E87;
                        float _SceneDepth_7EDDEF17_Out_1;
                        Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_7EDDEF17_Out_1);
                        float4 _ScreenPosition_872442DA_Out_0 = IN.ScreenPosition;
                        float _Split_EA314B79_R_1 = _ScreenPosition_872442DA_Out_0[0];
                        float _Split_EA314B79_G_2 = _ScreenPosition_872442DA_Out_0[1];
                        float _Split_EA314B79_B_3 = _ScreenPosition_872442DA_Out_0[2];
                        float _Split_EA314B79_A_4 = _ScreenPosition_872442DA_Out_0[3];
                        float _Subtract_59F8F149_Out_2;
                        Unity_Subtract_float(_SceneDepth_7EDDEF17_Out_1, _Split_EA314B79_A_4, _Subtract_59F8F149_Out_2);
                        float _Property_F28D0DED_Out_0 = Vector1_CC883DEC;
                        float _Property_A9460267_Out_0 = Vector1_E28BDDBB;
                        float _Add_260D7919_Out_2;
                        Unity_Add_float(_Property_F28D0DED_Out_0, _Property_A9460267_Out_0, _Add_260D7919_Out_2);
                        float _Divide_4142754B_Out_2;
                        Unity_Divide_float(_Subtract_59F8F149_Out_2, _Add_260D7919_Out_2, _Divide_4142754B_Out_2);
                        float _Saturate_12CF4DC6_Out_1;
                        Unity_Saturate_float(_Divide_4142754B_Out_2, _Saturate_12CF4DC6_Out_1);
                        float4 _Lerp_FA7AD557_Out_3;
                        Unity_Lerp_float4(_Property_6702D913_Out_0, _Property_CEFC8B5B_Out_0, (_Saturate_12CF4DC6_Out_1.xxxx), _Lerp_FA7AD557_Out_3);
                        float4 _Property_F1522DD3_Out_0 = Color_52823E97;
                        float _Property_70259FA0_Out_0 = Vector1_2316E3C6;
                        float _Multiply_5AEF6903_Out_2;
                        Unity_Multiply_float(_Saturate_12CF4DC6_Out_1, _Property_70259FA0_Out_0, _Multiply_5AEF6903_Out_2);
                        float _Property_5F725E07_Out_0 = Vector1_66FC436C;
                        float _Multiply_A91F9DCF_Out_2;
                        Unity_Multiply_float(IN.TimeParameters.x, _Property_5F725E07_Out_0, _Multiply_A91F9DCF_Out_2);
                        float _Property_4A5A0F8D_Out_0 = Vector1_AE5B059E;
                        float _Voronoi_2E9EB71C_Out_3;
                        float _Voronoi_2E9EB71C_Cells_4;
                        Unity_Voronoi_float(IN.uv0.xy, _Multiply_A91F9DCF_Out_2, _Property_4A5A0F8D_Out_0, _Voronoi_2E9EB71C_Out_3, _Voronoi_2E9EB71C_Cells_4);
                        float _Step_7D59C98C_Out_2;
                        Unity_Step_float(_Multiply_5AEF6903_Out_2, _Voronoi_2E9EB71C_Out_3, _Step_7D59C98C_Out_2);
                        float4 _Property_E90698F0_Out_0 = Color_52823E97;
                        float _Split_3D34AA68_R_1 = _Property_E90698F0_Out_0[0];
                        float _Split_3D34AA68_G_2 = _Property_E90698F0_Out_0[1];
                        float _Split_3D34AA68_B_3 = _Property_E90698F0_Out_0[2];
                        float _Split_3D34AA68_A_4 = _Property_E90698F0_Out_0[3];
                        float _Multiply_2270B01B_Out_2;
                        Unity_Multiply_float(_Step_7D59C98C_Out_2, _Split_3D34AA68_R_1, _Multiply_2270B01B_Out_2);
                        float4 _Lerp_4FB1C64B_Out_3;
                        Unity_Lerp_float4(_Lerp_FA7AD557_Out_3, _Property_F1522DD3_Out_0, (_Multiply_2270B01B_Out_2.xxxx), _Lerp_4FB1C64B_Out_3);
                        float _Split_9C8A7112_R_1 = _Lerp_4FB1C64B_Out_3[0];
                        float _Split_9C8A7112_G_2 = _Lerp_4FB1C64B_Out_3[1];
                        float _Split_9C8A7112_B_3 = _Lerp_4FB1C64B_Out_3[2];
                        float _Split_9C8A7112_A_4 = _Lerp_4FB1C64B_Out_3[3];
                        float4 _Lerp_3C9253_Out_3;
                        Unity_Lerp_float4(float4(0, 0, 0, 0), _Lerp_4FB1C64B_Out_3, (_Split_9C8A7112_R_1.xxxx), _Lerp_3C9253_Out_3);
                        float _Property_B614F02A_Out_0 = Vector1_2ED59376;
                        float4 _Multiply_FB74F68D_Out_2;
                        Unity_Multiply_float(_Lerp_3C9253_Out_3, (_Property_B614F02A_Out_0.xxxx), _Multiply_FB74F68D_Out_2);
                        float4 _Property_E1004808_Out_0 = Color_F60AF011;
                        float _Property_66B8C6D2_Out_0 = Vector1_1AFFAEB7;
                        float _Property_8A60AF8B_Out_0 = Vector1_6BF8592E;
                        float _Add_2971794_Out_2;
                        Unity_Add_float(_Property_8A60AF8B_Out_0, 0.05, _Add_2971794_Out_2);
                        float _Split_6DB6236C_R_1 = IN.WorldSpacePosition[0];
                        float _Split_6DB6236C_G_2 = IN.WorldSpacePosition[1];
                        float _Split_6DB6236C_B_3 = IN.WorldSpacePosition[2];
                        float _Split_6DB6236C_A_4 = 0;
                        float2 _Vector2_4BFCE0C4_Out_0 = float2(_Split_6DB6236C_R_1, _Split_6DB6236C_B_3);
                        float3 _Property_F7034583_Out_0 = _Position;
                        float _Split_672751AE_R_1 = _Property_F7034583_Out_0[0];
                        float _Split_672751AE_G_2 = _Property_F7034583_Out_0[1];
                        float _Split_672751AE_B_3 = _Property_F7034583_Out_0[2];
                        float _Split_672751AE_A_4 = 0;
                        float2 _Vector2_1063291D_Out_0 = float2(_Split_672751AE_R_1, _Split_672751AE_B_3);
                        float2 _Subtract_AC24825A_Out_2;
                        Unity_Subtract_float2(_Vector2_4BFCE0C4_Out_0, _Vector2_1063291D_Out_0, _Subtract_AC24825A_Out_2);
                        float _Property_EF6B0F9F_Out_0 = _OrthographicCamSize;
                        float _Multiply_1B6615E9_Out_2;
                        Unity_Multiply_float(_Property_EF6B0F9F_Out_0, 2, _Multiply_1B6615E9_Out_2);
                        float2 _Divide_AEF8CF71_Out_2;
                        Unity_Divide_float2(_Subtract_AC24825A_Out_2, (_Multiply_1B6615E9_Out_2.xx), _Divide_AEF8CF71_Out_2);
                        float2 _Add_26BEDED0_Out_2;
                        Unity_Add_float2(_Divide_AEF8CF71_Out_2, float2(0.5, 0.5), _Add_26BEDED0_Out_2);
                        float4 _SampleTexture2D_9AA6F11C_RGBA_0 = SAMPLE_TEXTURE2D(_GlobalEffectRT, sampler_GlobalEffectRT, _Add_26BEDED0_Out_2);
                        float _SampleTexture2D_9AA6F11C_R_4 = _SampleTexture2D_9AA6F11C_RGBA_0.r;
                        float _SampleTexture2D_9AA6F11C_G_5 = _SampleTexture2D_9AA6F11C_RGBA_0.g;
                        float _SampleTexture2D_9AA6F11C_B_6 = _SampleTexture2D_9AA6F11C_RGBA_0.b;
                        float _SampleTexture2D_9AA6F11C_A_7 = _SampleTexture2D_9AA6F11C_RGBA_0.a;
                        float _Smoothstep_558DAB99_Out_3;
                        Unity_Smoothstep_float(_Property_8A60AF8B_Out_0, _Add_2971794_Out_2, _SampleTexture2D_9AA6F11C_B_6, _Smoothstep_558DAB99_Out_3);
                        float _Saturate_C43EA012_Out_1;
                        Unity_Saturate_float(_Smoothstep_558DAB99_Out_3, _Saturate_C43EA012_Out_1);
                        float4 _Property_88B70072_Out_0 = Color_52823E97;
                        float4 _Multiply_1F24AC84_Out_2;
                        Unity_Multiply_float((_Saturate_C43EA012_Out_1.xxxx), _Property_88B70072_Out_0, _Multiply_1F24AC84_Out_2);
                        float4 _Multiply_D81E7E9E_Out_2;
                        Unity_Multiply_float((_Property_66B8C6D2_Out_0.xxxx), _Multiply_1F24AC84_Out_2, _Multiply_D81E7E9E_Out_2);
                        float4 _Add_3ADB8553_Out_2;
                        Unity_Add_float4(_Property_E1004808_Out_0, _Multiply_D81E7E9E_Out_2, _Add_3ADB8553_Out_2);
                        float4 _Add_3F48AADE_Out_2;
                        Unity_Add_float4(_Multiply_FB74F68D_Out_2, _Add_3ADB8553_Out_2, _Add_3F48AADE_Out_2);
                        float4 _Multiply_C78C0F0E_Out_2;
                        Unity_Multiply_float(_SampleTexture2D_27B068CA_RGBA_0, _Add_3F48AADE_Out_2, _Multiply_C78C0F0E_Out_2);
                        surface.Albedo = (_Multiply_C78C0F0E_Out_2.xyz);
                        surface.Emission = IsGammaSpace() ? float3(0, 0, 0) : SRGBToLinear(float3(0, 0, 0));
                        surface.Alpha = (_SampleTexture2D_27B068CA_RGBA_0).x;
                        surface.AlphaClipThreshold = 0.5;
                        return surface;
                    }

                    // --------------------------------------------------
                    // Structs and Packing

                    // Generated Type: Attributes
                    struct Attributes
                    {
                        float3 positionOS : POSITION;
                        float3 normalOS : NORMAL;
                        float4 tangentOS : TANGENT;
                        float4 uv0 : TEXCOORD0;
                        float4 uv1 : TEXCOORD1;
                        float4 uv2 : TEXCOORD2;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : INSTANCEID_SEMANTIC;
                        #endif
                    };

                    // Generated Type: Varyings
                    struct Varyings
                    {
                        float4 positionCS : SV_POSITION;
                        float3 positionWS;
                        float4 texCoord0;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Generated Type: PackedVaryings
                    struct PackedVaryings
                    {
                        float4 positionCS : SV_POSITION;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        uint instanceID : CUSTOM_INSTANCE_ID;
                        #endif
                        float3 interp00 : TEXCOORD0;
                        float4 interp01 : TEXCOORD1;
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                        #endif
                    };

                    // Packed Type: Varyings
                    PackedVaryings PackVaryings(Varyings input)
                    {
                        PackedVaryings output = (PackedVaryings)0;
                        output.positionCS = input.positionCS;
                        output.interp00.xyz = input.positionWS;
                        output.interp01.xyzw = input.texCoord0;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // Unpacked Type: Varyings
                    Varyings UnpackVaryings(PackedVaryings input)
                    {
                        Varyings output = (Varyings)0;
                        output.positionCS = input.positionCS;
                        output.positionWS = input.interp00.xyz;
                        output.texCoord0 = input.interp01.xyzw;
                        #if UNITY_ANY_INSTANCING_ENABLED
                        output.instanceID = input.instanceID;
                        #endif
                        #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                        output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                        #endif
                        #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                        output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                        #endif
                        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                        output.cullFace = input.cullFace;
                        #endif
                        return output;
                    }

                    // --------------------------------------------------
                    // Build Graph Inputs

                    VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                    {
                        VertexDescriptionInputs output;
                        ZERO_INITIALIZE(VertexDescriptionInputs, output);

                        output.ObjectSpaceNormal = input.normalOS;
                        output.ObjectSpaceTangent = input.tangentOS;
                        output.ObjectSpacePosition = input.positionOS;
                        output.uv0 = input.uv0;
                        output.TimeParameters = _TimeParameters.xyz;

                        return output;
                    }

                    SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                    {
                        SurfaceDescriptionInputs output;
                        ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



                        output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                        output.WorldSpacePosition = input.positionWS;
                        output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                        output.uv0 = input.texCoord0;
                        output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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

                    ENDHLSL
                }

                Pass
                {
                        // Name: <None>
                        Tags
                        {
                            "LightMode" = "Universal2D"
                        }

                        // Render State
                        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
                        Cull Off
                        ZTest LEqual
                        ZWrite Off
                        // ColorMask: <None>


                        HLSLPROGRAM
                        #pragma vertex vert
                        #pragma fragment frag

                        // Debug
                        // <None>

                        // --------------------------------------------------
                        // Pass

                        // Pragmas
                        #pragma prefer_hlslcc gles
                        #pragma exclude_renderers d3d11_9x
                        #pragma target 2.0
                        #pragma multi_compile_instancing

                        // Keywords
                        // PassKeywords: <None>
                        // GraphKeywords: <None>

                        // Defines
                        #define _SURFACE_TYPE_TRANSPARENT 1
                        #define _AlphaClip 1
                        #define _SPECULAR_SETUP
                        #define _NORMAL_DROPOFF_TS 1
                        #define ATTRIBUTES_NEED_NORMAL
                        #define ATTRIBUTES_NEED_TANGENT
                        #define ATTRIBUTES_NEED_TEXCOORD0
                        #define VARYINGS_NEED_POSITION_WS 
                        #define VARYINGS_NEED_TEXCOORD0
                        #define FEATURES_GRAPH_VERTEX
                        #pragma multi_compile_instancing
                        #define SHADERPASS_2D
                        #define REQUIRE_DEPTH_TEXTURE


                        // Includes
                        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
                        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
                        #include "Packages/com.unity.shadergraph/ShaderGraphLibrary/ShaderVariablesFunctions.hlsl"

                        // --------------------------------------------------
                        // Graph

                        // Graph Properties
                        CBUFFER_START(UnityPerMaterial)
                        float4 Color_F60AF011;
                        float Vector1_65AB24F7;
                        float4 Color_E3EE7E87;
                        float Vector1_E28BDDBB;
                        float4 Color_52823E97;
                        float Vector1_2316E3C6;
                        float Vector1_2ED59376;
                        float Vector1_66FC436C;
                        float Vector1_CC883DEC;
                        float Vector1_AE5B059E;
                        float Vector1_6BF8592E;
                        float Vector1_1AFFAEB7;
                        float Vector1_F0382C7B;
                        float Vector1_D6291039;
                        float Vector1_99C62EE8;
                        float Vector1_DBFE50E5;
                        CBUFFER_END
                        float3 _Position;
                        float _OrthographicCamSize;
                        TEXTURE2D(_GlobalEffectRT); SAMPLER(sampler_GlobalEffectRT); float4 _GlobalEffectRT_TexelSize;
                        TEXTURE2D(_CameraOpaqueTexture); SAMPLER(sampler_CameraOpaqueTexture); float4 _CameraOpaqueTexture_TexelSize;
                        TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1); SAMPLER(sampler_SampleTexture2D_27B068CA_Texture_1); float4 _SampleTexture2D_27B068CA_Texture_1_TexelSize;
                        SAMPLER(_SampleTexture2D_27B068CA_Sampler_3_Linear_Repeat);
                        SAMPLER(_SampleTexture2D_9AA6F11C_Sampler_3_Linear_Repeat);

                        // Graph Functions

                        void Unity_Multiply_float(float A, float B, out float Out)
                        {
                            Out = A * B;
                        }

                        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
                        {
                            Out = UV * Tiling + Offset;
                        }


                        float2 Unity_GradientNoise_Dir_float(float2 p)
                        {
                            // Permutation and hashing used in webgl-nosie goo.gl/pX7HtC
                            p = p % 289;
                            float x = (34 * p.x + 1) * p.x % 289 + p.y;
                            x = (34 * x + 1) * x % 289;
                            x = frac(x / 41) * 2 - 1;
                            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
                        }

                        void Unity_GradientNoise_float(float2 UV, float Scale, out float Out)
                        {
                            float2 p = UV * Scale;
                            float2 ip = floor(p);
                            float2 fp = frac(p);
                            float d00 = dot(Unity_GradientNoise_Dir_float(ip), fp);
                            float d01 = dot(Unity_GradientNoise_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
                            float d10 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
                            float d11 = dot(Unity_GradientNoise_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
                            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
                            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
                        }

                        void Unity_Preview_float3(float3 In, out float3 Out)
                        {
                            Out = In;
                        }

                        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
                        {
                            Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
                        }

                        void Unity_Subtract_float(float A, float B, out float Out)
                        {
                            Out = A - B;
                        }

                        void Unity_Add_float(float A, float B, out float Out)
                        {
                            Out = A + B;
                        }

                        void Unity_Divide_float(float A, float B, out float Out)
                        {
                            Out = A / B;
                        }

                        void Unity_Saturate_float(float In, out float Out)
                        {
                            Out = saturate(In);
                        }

                        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
                        {
                            Out = lerp(A, B, T);
                        }


                        inline float2 Unity_Voronoi_RandomVector_float(float2 UV, float offset)
                        {
                            float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
                            UV = frac(sin(mul(UV, m)) * 46839.32);
                            return float2(sin(UV.y * +offset) * 0.5 + 0.5, cos(UV.x * offset) * 0.5 + 0.5);
                        }

                        void Unity_Voronoi_float(float2 UV, float AngleOffset, float CellDensity, out float Out, out float Cells)
                        {
                            float2 g = floor(UV * CellDensity);
                            float2 f = frac(UV * CellDensity);
                            float t = 8.0;
                            float3 res = float3(8.0, 0.0, 0.0);

                            for (int y = -1; y <= 1; y++)
                            {
                                for (int x = -1; x <= 1; x++)
                                {
                                    float2 lattice = float2(x,y);
                                    float2 offset = Unity_Voronoi_RandomVector_float(lattice + g, AngleOffset);
                                    float d = distance(lattice + offset, f);

                                    if (d < res.x)
                                    {
                                        res = float3(d, offset.x, offset.y);
                                        Out = res.x;
                                        Cells = res.y;
                                    }
                                }
                            }
                        }

                        void Unity_Step_float(float Edge, float In, out float Out)
                        {
                            Out = step(Edge, In);
                        }

                        void Unity_Multiply_float(float4 A, float4 B, out float4 Out)
                        {
                            Out = A * B;
                        }

                        void Unity_Subtract_float2(float2 A, float2 B, out float2 Out)
                        {
                            Out = A - B;
                        }

                        void Unity_Divide_float2(float2 A, float2 B, out float2 Out)
                        {
                            Out = A / B;
                        }

                        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
                        {
                            Out = A + B;
                        }

                        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
                        {
                            Out = smoothstep(Edge1, Edge2, In);
                        }

                        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
                        {
                            Out = A + B;
                        }

                        // Graph Vertex
                        struct VertexDescriptionInputs
                        {
                            float3 ObjectSpaceNormal;
                            float3 ObjectSpaceTangent;
                            float3 ObjectSpacePosition;
                            float4 uv0;
                            float3 TimeParameters;
                        };

                        struct VertexDescription
                        {
                            float3 VertexPosition;
                            float3 VertexNormal;
                            float3 VertexTangent;
                        };

                        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
                        {
                            VertexDescription description = (VertexDescription)0;
                            float _Split_37EBA153_R_1 = IN.ObjectSpacePosition[0];
                            float _Split_37EBA153_G_2 = IN.ObjectSpacePosition[1];
                            float _Split_37EBA153_B_3 = IN.ObjectSpacePosition[2];
                            float _Split_37EBA153_A_4 = 0;
                            float _Property_477CE477_Out_0 = Vector1_D6291039;
                            float _Multiply_D063421F_Out_2;
                            Unity_Multiply_float(IN.TimeParameters.y, _Property_477CE477_Out_0, _Multiply_D063421F_Out_2);
                            float _Multiply_E6FCA4B1_Out_2;
                            Unity_Multiply_float(IN.TimeParameters.z, _Property_477CE477_Out_0, _Multiply_E6FCA4B1_Out_2);
                            float2 _Vector2_67DD110D_Out_0 = float2(_Multiply_D063421F_Out_2, _Multiply_E6FCA4B1_Out_2);
                            float2 _TilingAndOffset_2D63B711_Out_3;
                            Unity_TilingAndOffset_float(IN.uv0.xy, float2 (1, 1), _Vector2_67DD110D_Out_0, _TilingAndOffset_2D63B711_Out_3);
                            float _Property_8043A745_Out_0 = Vector1_99C62EE8;
                            float _GradientNoise_26E5F82D_Out_2;
                            Unity_GradientNoise_float(_TilingAndOffset_2D63B711_Out_3, _Property_8043A745_Out_0, _GradientNoise_26E5F82D_Out_2);
                            float _Property_F78F82CD_Out_0 = Vector1_F0382C7B;
                            float _Multiply_93625254_Out_2;
                            Unity_Multiply_float(_GradientNoise_26E5F82D_Out_2, _Property_F78F82CD_Out_0, _Multiply_93625254_Out_2);
                            float3 _Vector3_40DDF711_Out_0 = float3(_Split_37EBA153_R_1, _Multiply_93625254_Out_2, _Split_37EBA153_B_3);
                            float3 _Preview_DA5DD73_Out_1;
                            Unity_Preview_float3(_Vector3_40DDF711_Out_0, _Preview_DA5DD73_Out_1);
                            description.VertexPosition = _Preview_DA5DD73_Out_1;
                            description.VertexNormal = IN.ObjectSpaceNormal;
                            description.VertexTangent = IN.ObjectSpaceTangent;
                            return description;
                        }

                        // Graph Pixel
                        struct SurfaceDescriptionInputs
                        {
                            float3 TangentSpaceNormal;
                            float3 WorldSpacePosition;
                            float4 ScreenPosition;
                            float4 uv0;
                            float3 TimeParameters;
                        };

                        struct SurfaceDescription
                        {
                            float3 Albedo;
                            float Alpha;
                            float AlphaClipThreshold;
                        };

                        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
                        {
                            SurfaceDescription surface = (SurfaceDescription)0;
                            float4 _SampleTexture2D_27B068CA_RGBA_0 = SAMPLE_TEXTURE2D(_SampleTexture2D_27B068CA_Texture_1, sampler_SampleTexture2D_27B068CA_Texture_1, IN.uv0.xy);
                            float _SampleTexture2D_27B068CA_R_4 = _SampleTexture2D_27B068CA_RGBA_0.r;
                            float _SampleTexture2D_27B068CA_G_5 = _SampleTexture2D_27B068CA_RGBA_0.g;
                            float _SampleTexture2D_27B068CA_B_6 = _SampleTexture2D_27B068CA_RGBA_0.b;
                            float _SampleTexture2D_27B068CA_A_7 = _SampleTexture2D_27B068CA_RGBA_0.a;
                            float4 _Property_6702D913_Out_0 = Color_F60AF011;
                            float4 _Property_CEFC8B5B_Out_0 = Color_E3EE7E87;
                            float _SceneDepth_7EDDEF17_Out_1;
                            Unity_SceneDepth_Eye_float(float4(IN.ScreenPosition.xy / IN.ScreenPosition.w, 0, 0), _SceneDepth_7EDDEF17_Out_1);
                            float4 _ScreenPosition_872442DA_Out_0 = IN.ScreenPosition;
                            float _Split_EA314B79_R_1 = _ScreenPosition_872442DA_Out_0[0];
                            float _Split_EA314B79_G_2 = _ScreenPosition_872442DA_Out_0[1];
                            float _Split_EA314B79_B_3 = _ScreenPosition_872442DA_Out_0[2];
                            float _Split_EA314B79_A_4 = _ScreenPosition_872442DA_Out_0[3];
                            float _Subtract_59F8F149_Out_2;
                            Unity_Subtract_float(_SceneDepth_7EDDEF17_Out_1, _Split_EA314B79_A_4, _Subtract_59F8F149_Out_2);
                            float _Property_F28D0DED_Out_0 = Vector1_CC883DEC;
                            float _Property_A9460267_Out_0 = Vector1_E28BDDBB;
                            float _Add_260D7919_Out_2;
                            Unity_Add_float(_Property_F28D0DED_Out_0, _Property_A9460267_Out_0, _Add_260D7919_Out_2);
                            float _Divide_4142754B_Out_2;
                            Unity_Divide_float(_Subtract_59F8F149_Out_2, _Add_260D7919_Out_2, _Divide_4142754B_Out_2);
                            float _Saturate_12CF4DC6_Out_1;
                            Unity_Saturate_float(_Divide_4142754B_Out_2, _Saturate_12CF4DC6_Out_1);
                            float4 _Lerp_FA7AD557_Out_3;
                            Unity_Lerp_float4(_Property_6702D913_Out_0, _Property_CEFC8B5B_Out_0, (_Saturate_12CF4DC6_Out_1.xxxx), _Lerp_FA7AD557_Out_3);
                            float4 _Property_F1522DD3_Out_0 = Color_52823E97;
                            float _Property_70259FA0_Out_0 = Vector1_2316E3C6;
                            float _Multiply_5AEF6903_Out_2;
                            Unity_Multiply_float(_Saturate_12CF4DC6_Out_1, _Property_70259FA0_Out_0, _Multiply_5AEF6903_Out_2);
                            float _Property_5F725E07_Out_0 = Vector1_66FC436C;
                            float _Multiply_A91F9DCF_Out_2;
                            Unity_Multiply_float(IN.TimeParameters.x, _Property_5F725E07_Out_0, _Multiply_A91F9DCF_Out_2);
                            float _Property_4A5A0F8D_Out_0 = Vector1_AE5B059E;
                            float _Voronoi_2E9EB71C_Out_3;
                            float _Voronoi_2E9EB71C_Cells_4;
                            Unity_Voronoi_float(IN.uv0.xy, _Multiply_A91F9DCF_Out_2, _Property_4A5A0F8D_Out_0, _Voronoi_2E9EB71C_Out_3, _Voronoi_2E9EB71C_Cells_4);
                            float _Step_7D59C98C_Out_2;
                            Unity_Step_float(_Multiply_5AEF6903_Out_2, _Voronoi_2E9EB71C_Out_3, _Step_7D59C98C_Out_2);
                            float4 _Property_E90698F0_Out_0 = Color_52823E97;
                            float _Split_3D34AA68_R_1 = _Property_E90698F0_Out_0[0];
                            float _Split_3D34AA68_G_2 = _Property_E90698F0_Out_0[1];
                            float _Split_3D34AA68_B_3 = _Property_E90698F0_Out_0[2];
                            float _Split_3D34AA68_A_4 = _Property_E90698F0_Out_0[3];
                            float _Multiply_2270B01B_Out_2;
                            Unity_Multiply_float(_Step_7D59C98C_Out_2, _Split_3D34AA68_R_1, _Multiply_2270B01B_Out_2);
                            float4 _Lerp_4FB1C64B_Out_3;
                            Unity_Lerp_float4(_Lerp_FA7AD557_Out_3, _Property_F1522DD3_Out_0, (_Multiply_2270B01B_Out_2.xxxx), _Lerp_4FB1C64B_Out_3);
                            float _Split_9C8A7112_R_1 = _Lerp_4FB1C64B_Out_3[0];
                            float _Split_9C8A7112_G_2 = _Lerp_4FB1C64B_Out_3[1];
                            float _Split_9C8A7112_B_3 = _Lerp_4FB1C64B_Out_3[2];
                            float _Split_9C8A7112_A_4 = _Lerp_4FB1C64B_Out_3[3];
                            float4 _Lerp_3C9253_Out_3;
                            Unity_Lerp_float4(float4(0, 0, 0, 0), _Lerp_4FB1C64B_Out_3, (_Split_9C8A7112_R_1.xxxx), _Lerp_3C9253_Out_3);
                            float _Property_B614F02A_Out_0 = Vector1_2ED59376;
                            float4 _Multiply_FB74F68D_Out_2;
                            Unity_Multiply_float(_Lerp_3C9253_Out_3, (_Property_B614F02A_Out_0.xxxx), _Multiply_FB74F68D_Out_2);
                            float4 _Property_E1004808_Out_0 = Color_F60AF011;
                            float _Property_66B8C6D2_Out_0 = Vector1_1AFFAEB7;
                            float _Property_8A60AF8B_Out_0 = Vector1_6BF8592E;
                            float _Add_2971794_Out_2;
                            Unity_Add_float(_Property_8A60AF8B_Out_0, 0.05, _Add_2971794_Out_2);
                            float _Split_6DB6236C_R_1 = IN.WorldSpacePosition[0];
                            float _Split_6DB6236C_G_2 = IN.WorldSpacePosition[1];
                            float _Split_6DB6236C_B_3 = IN.WorldSpacePosition[2];
                            float _Split_6DB6236C_A_4 = 0;
                            float2 _Vector2_4BFCE0C4_Out_0 = float2(_Split_6DB6236C_R_1, _Split_6DB6236C_B_3);
                            float3 _Property_F7034583_Out_0 = _Position;
                            float _Split_672751AE_R_1 = _Property_F7034583_Out_0[0];
                            float _Split_672751AE_G_2 = _Property_F7034583_Out_0[1];
                            float _Split_672751AE_B_3 = _Property_F7034583_Out_0[2];
                            float _Split_672751AE_A_4 = 0;
                            float2 _Vector2_1063291D_Out_0 = float2(_Split_672751AE_R_1, _Split_672751AE_B_3);
                            float2 _Subtract_AC24825A_Out_2;
                            Unity_Subtract_float2(_Vector2_4BFCE0C4_Out_0, _Vector2_1063291D_Out_0, _Subtract_AC24825A_Out_2);
                            float _Property_EF6B0F9F_Out_0 = _OrthographicCamSize;
                            float _Multiply_1B6615E9_Out_2;
                            Unity_Multiply_float(_Property_EF6B0F9F_Out_0, 2, _Multiply_1B6615E9_Out_2);
                            float2 _Divide_AEF8CF71_Out_2;
                            Unity_Divide_float2(_Subtract_AC24825A_Out_2, (_Multiply_1B6615E9_Out_2.xx), _Divide_AEF8CF71_Out_2);
                            float2 _Add_26BEDED0_Out_2;
                            Unity_Add_float2(_Divide_AEF8CF71_Out_2, float2(0.5, 0.5), _Add_26BEDED0_Out_2);
                            float4 _SampleTexture2D_9AA6F11C_RGBA_0 = SAMPLE_TEXTURE2D(_GlobalEffectRT, sampler_GlobalEffectRT, _Add_26BEDED0_Out_2);
                            float _SampleTexture2D_9AA6F11C_R_4 = _SampleTexture2D_9AA6F11C_RGBA_0.r;
                            float _SampleTexture2D_9AA6F11C_G_5 = _SampleTexture2D_9AA6F11C_RGBA_0.g;
                            float _SampleTexture2D_9AA6F11C_B_6 = _SampleTexture2D_9AA6F11C_RGBA_0.b;
                            float _SampleTexture2D_9AA6F11C_A_7 = _SampleTexture2D_9AA6F11C_RGBA_0.a;
                            float _Smoothstep_558DAB99_Out_3;
                            Unity_Smoothstep_float(_Property_8A60AF8B_Out_0, _Add_2971794_Out_2, _SampleTexture2D_9AA6F11C_B_6, _Smoothstep_558DAB99_Out_3);
                            float _Saturate_C43EA012_Out_1;
                            Unity_Saturate_float(_Smoothstep_558DAB99_Out_3, _Saturate_C43EA012_Out_1);
                            float4 _Property_88B70072_Out_0 = Color_52823E97;
                            float4 _Multiply_1F24AC84_Out_2;
                            Unity_Multiply_float((_Saturate_C43EA012_Out_1.xxxx), _Property_88B70072_Out_0, _Multiply_1F24AC84_Out_2);
                            float4 _Multiply_D81E7E9E_Out_2;
                            Unity_Multiply_float((_Property_66B8C6D2_Out_0.xxxx), _Multiply_1F24AC84_Out_2, _Multiply_D81E7E9E_Out_2);
                            float4 _Add_3ADB8553_Out_2;
                            Unity_Add_float4(_Property_E1004808_Out_0, _Multiply_D81E7E9E_Out_2, _Add_3ADB8553_Out_2);
                            float4 _Add_3F48AADE_Out_2;
                            Unity_Add_float4(_Multiply_FB74F68D_Out_2, _Add_3ADB8553_Out_2, _Add_3F48AADE_Out_2);
                            float4 _Multiply_C78C0F0E_Out_2;
                            Unity_Multiply_float(_SampleTexture2D_27B068CA_RGBA_0, _Add_3F48AADE_Out_2, _Multiply_C78C0F0E_Out_2);
                            surface.Albedo = (_Multiply_C78C0F0E_Out_2.xyz);
                            surface.Alpha = (_SampleTexture2D_27B068CA_RGBA_0).x;
                            surface.AlphaClipThreshold = 0.5;
                            return surface;
                        }

                        // --------------------------------------------------
                        // Structs and Packing

                        // Generated Type: Attributes
                        struct Attributes
                        {
                            float3 positionOS : POSITION;
                            float3 normalOS : NORMAL;
                            float4 tangentOS : TANGENT;
                            float4 uv0 : TEXCOORD0;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : INSTANCEID_SEMANTIC;
                            #endif
                        };

                        // Generated Type: Varyings
                        struct Varyings
                        {
                            float4 positionCS : SV_POSITION;
                            float3 positionWS;
                            float4 texCoord0;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Generated Type: PackedVaryings
                        struct PackedVaryings
                        {
                            float4 positionCS : SV_POSITION;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            uint instanceID : CUSTOM_INSTANCE_ID;
                            #endif
                            float3 interp00 : TEXCOORD0;
                            float4 interp01 : TEXCOORD1;
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
                            #endif
                        };

                        // Packed Type: Varyings
                        PackedVaryings PackVaryings(Varyings input)
                        {
                            PackedVaryings output = (PackedVaryings)0;
                            output.positionCS = input.positionCS;
                            output.interp00.xyz = input.positionWS;
                            output.interp01.xyzw = input.texCoord0;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // Unpacked Type: Varyings
                        Varyings UnpackVaryings(PackedVaryings input)
                        {
                            Varyings output = (Varyings)0;
                            output.positionCS = input.positionCS;
                            output.positionWS = input.interp00.xyz;
                            output.texCoord0 = input.interp01.xyzw;
                            #if UNITY_ANY_INSTANCING_ENABLED
                            output.instanceID = input.instanceID;
                            #endif
                            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
                            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
                            #endif
                            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
                            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
                            #endif
                            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
                            output.cullFace = input.cullFace;
                            #endif
                            return output;
                        }

                        // --------------------------------------------------
                        // Build Graph Inputs

                        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
                        {
                            VertexDescriptionInputs output;
                            ZERO_INITIALIZE(VertexDescriptionInputs, output);

                            output.ObjectSpaceNormal = input.normalOS;
                            output.ObjectSpaceTangent = input.tangentOS;
                            output.ObjectSpacePosition = input.positionOS;
                            output.uv0 = input.uv0;
                            output.TimeParameters = _TimeParameters.xyz;

                            return output;
                        }

                        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
                        {
                            SurfaceDescriptionInputs output;
                            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);



                            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);


                            output.WorldSpacePosition = input.positionWS;
                            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
                            output.uv0 = input.texCoord0;
                            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
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

                        ENDHLSL
                    }

    }
        CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
                            FallBack "Hidden/Shader Graph/FallbackError"
}
