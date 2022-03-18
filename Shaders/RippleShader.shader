Shader "Unlit/RippleShader"
{
    Properties
    {
        _ColorA ("Color A", Color) = (1,1,1,1)
        _ColorB ("Color B", Color) = (1,1,1,1)
        _Bendiness("Bendiness", Range(0,1)) = 1
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
                float2 uv : TEXCOORD2;
            };

            float4 _ColorA;
            float4 _ColorB;
            float _Bendiness;


            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);

                i.uv = v.uv;
                return i;
            }

            fixed4 frag(Interpolators i) : SV_Target
            {
                float2 coords = i.uv;
                float bentValue = coords.x - coords.y * coords.y + coords.y;
                coords.x = lerp(coords.x, bentValue, _Bendiness);
                float4 color = lerp(_ColorA, _ColorB, frac(coords.x*8 +_Time.y));

                return color;

            }
            ENDCG
        }
    }
}
