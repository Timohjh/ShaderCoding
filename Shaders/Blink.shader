Shader "Unlit/Blink"
{
    Properties
    {
        _ColorA("Color A", Color) = (0,0,0,1)
        _ColorB("Color B", Color) = (1,1,1,1)
        _Frequency ("Blink speed", Float) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #define TAU 6.2831853

            struct MeshData
            {
                float3 vertex : POSITION;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _ColorA;
            float4 _ColorB;
            float _Frequency;


            Interpolators vert (MeshData v)
            {
                Interpolators i;
                i.vertex = UnityObjectToClipPos(v.vertex);
                return i;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                float t = sin(_Frequency*_Time.y*TAU)*0.5+0.5; // harmonic oscillation
                //float t = round(frac(_Time.y)); // blink
                return lerp(_ColorA, _ColorB, t);
            }
            ENDCG
        }
    }
}
