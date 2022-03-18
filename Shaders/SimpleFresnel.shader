Shader "Unlit/SimpleFresnel"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _Color("Color", Color) = (0,0,0,1)
        _Gloss("Gloss", Range(0,1)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Pass
        {
            Tags{"LightMode" = "ForwardBase"}

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "UnityLightingCommon.cginc"
            #define TAU 6.2831853

            struct MeshData
            {
                float3 vertex : POSITION;
                float2 uv0 : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct Interpolators
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                float3 worldPos : TEXCOORD1;
                float3 localPos : TEXCOORD2;
                float3 normal : TEXCOORD3;
            };

            float4 _Color;
            sampler2D _MainTex;
            float _Gloss;

            Interpolators vert(MeshData v)
            {
                Interpolators i;
                UNITY_INITIALIZE_OUTPUT(Interpolators, i);
                i.vertex = UnityObjectToClipPos(v.vertex);
                i.uv = v.uv0;
                //i.localPos = v.vertex;
                i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex, 1));
                i.normal = UnityObjectToWorldNormal( v.normal );
                return i;
            }

            float4 frag(Interpolators i) : SV_Target
            {
                i.normal = normalize(i.normal);
                float3 V = normalize(_WorldSpaceCameraPos - i.worldPos);
                float specExp = exp2(1 + _Gloss * 12);
                return pow(1-dot(i.normal,V),specExp);
            }
            ENDCG
        }
    }
}
