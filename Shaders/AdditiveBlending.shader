Shader "Unlit/AdditiveBlending"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex("Base Color", 2D) = "black" {}
        _ClipTreshold("Clip treshold", Range(0.0001,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Transparent"
                "RenderQueue"="Transparent"
        }
        Pass
        {
            Cull Off
            ZWrite Off
            Blend One One // additive blending

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"

            struct MeshData
            {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float _ClipTreshold;
            float4 _Color;


            Interpolators vert(MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv0;
                return i;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float4 baseColor = tex2D(_MainTex, i.uv);
                //clip(baseColor.a-_ClipTreshold);
                return baseColor * _Color;
            }
            ENDCG
        }
    }
}
