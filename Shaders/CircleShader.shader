Shader "Unlit/CircleShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _WaveHeight("Wave height", Float) = 1
        _WaveLength("Wave length", Float) = 1
        _WaveSpeed("Wave speed", Float) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        Pass
        {

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct MeshData
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
                float2 uv : TEXCOORD0;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            float4 _ColorA;
            float4 _ColorB;

            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);

                i.uv = v.uv;
                return i;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                float2 coords = i.uv*2-float2(1,1);
                float time = -_Time.y;
                float distToCenter = frac(length(coords) + time);
                float4 color = lerp(_ColorA, _ColorB, distToCenter);

                return color;
            }
            ENDCG
        }
    }
}
