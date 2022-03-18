Shader "Unlit/MainShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "black" {}
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _WaveHeight("Wave height", float) = 1
        _WaveLength("Wave length", float) = 1
        _WaveSpeed("Wave speed", float) = 1
    }
    SubShader
    {
        Tags { 
            "RenderType"="Opaque"
            "Queue"="Geometry"
        }

        Pass
        {
            //ZTest On
            //ZWrite On
            //Blend x y

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

            sampler2D _MainTex;
            //float4 _MainTex_ST;
            float4 _ColorA;
            float4 _ColorB;
            //float _Bendiness;
            float _WaveHeight;
            float _WaveLength;
            float _WaveSpeed;


            Interpolators vert (MeshData v)
            {
                Interpolators i;
                //v.vertex.y = cos(((v.uv.x+_Time.y*_WaveSpeed))*_WaveLength*UNITY_PI*2)*_WaveHeight;

                i.vertex = UnityObjectToClipPos(v.vertex);

                i.worldNormal = UnityObjectToWorldNormal(v.normal);
                i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex.x, v.vertex.y, v.vertex.z, 1));
                i.uv = v.uv;

                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return i;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                float4 texColor = tex2D(_MainTex, i.uv)*_ColorB;
                float t = saturate(i.worldPos.y);
                return lerp(_ColorA, texColor, t);
            }
            ENDCG
        }
    }
}
