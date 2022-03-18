Shader "Unlit/Lighting"
{
    Properties
    {
        _MainTex("Main Texture", 2D) = "white" {}
        _NormalMap("Normal", 2D) = "bump" {}
        _Color("Color", Color) = (0,0,0,1)
        _Gloss("Gloss", Range(0,1)) = 0.5
    }
        SubShader
        {
            Tags { "RenderType" = "Opaque" }
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
                    float4 tangent : TANGENT;
                };

                struct Interpolators
                {
                    float4 vertex : SV_POSITION;
                    float2 uv : TEXCOORD0;
                    float3 worldPos : TEXCOORD1;
                    float3 localPos : TEXCOORD2;
                    float3 normal : TEXCOORD3;
                    float3 tangent : TEXCOORD4;
                    float3 bitangent : TEXCOORD5;
                };

                float4 _Color;
                sampler2D _MainTex;
                sampler2D _NormalMap;
                float _Gloss;

                Interpolators vert(MeshData v)
                {
                    Interpolators i;
                    UNITY_INITIALIZE_OUTPUT(Interpolators, i);
                    i.vertex = UnityObjectToClipPos(v.vertex);
                    i.uv = v.uv0;
                    //i.localPos = v.vertex;
                    i.worldPos = mul(UNITY_MATRIX_M, float4(v.vertex, 1));
                    i.normal = UnityObjectToWorldNormal(v.normal);
                    i.tangent = UnityObjectToWorldDir(v.tangent.xyz);
                    float flipSign = v.tangent.w * unity_WorldTransformParams.w;
                    i.bitangent = cross(i.normal, i.tangent) * flipSign;
                    return i;
                }

                float4 frag(Interpolators i) : SV_Target
                {
                    float3 surfaceColor = tex2D(_MainTex, i.uv);
                    //Normal
                    float3 vertexNormal = normalize(i.normal);
                    float3 tsNormal = UnpackNormal(tex2D(_NormalMap, i.uv));
                    float3x3 mtxWorToTan = float3x3(i.tangent, i.bitangent, i.normal);
                    float3x3 mtxTanToWor = transpose(mtxWorToTan);
                    float3 N = mul(mtxTanToWor, tsNormal);

                    //diffuse (Lambert)
                    float3 lightDir = UnityWorldSpaceLightDir(i.worldPos);
                    float lighting = saturate(dot(N, lightDir));
                    float3 lightColor = _LightColor0;
                    float3 diffuse = lighting * lightColor;

                    //specular (Blinn-Phong)
                    float3 V = normalize(_WorldSpaceCameraPos - i.worldPos);
                    float3 H = normalize(lightDir + V);
                    float specExp = exp2(1 + _Gloss * 12);
                    float specular = pow(max(0, dot(H,N)), specExp) * lightColor;

                    return float4(surfaceColor * diffuse + specular,1);
                }
                ENDCG
            }
        }
}
