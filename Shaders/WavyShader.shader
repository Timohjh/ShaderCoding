Shader "Unlit/WavyShader"
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
            Cull Off

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
                float3 worldNormal : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float2 uv : TEXCOORD2;
            };

            float4 _ColorA;
            float4 _ColorB;
            float _WaveHeight;
            float _WaveLength;
            float _WaveSpeed;


            Interpolators vert (MeshData v)
            {
                Interpolators i;
                v.vertex.y = cos(((v.uv.x+_Time.y*_WaveSpeed))*_WaveLength*UNITY_PI*2)*_WaveHeight;

                i.vertex = UnityObjectToClipPos(v.vertex);

                i.worldNormal = UnityObjectToWorldNormal(v.normal);
                i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex.x, v.vertex.y, v.vertex.z, 1));
                i.uv = v.uv;
                return i;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                return float4(i.uv,0,1);
            }
            ENDCG
        }
    }
}
