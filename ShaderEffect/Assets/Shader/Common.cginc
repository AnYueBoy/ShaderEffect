#ifndef COMMON_INCLUDED
#define COMMON_INCLUDED

#include "UnityCG.cginc"

half4 _Color;
sampler2D _MainTex;
half4 _MainTex_TexelSize;

struct VertexInput
{
    float4 vertex : POSITION;
    float2 uv : TEXCOORD0;
};

struct VertexOutput
{
    float4 pos : SV_POSITION;
    float2 uv : TEXCOORD0;
};

VertexOutput vert(VertexInput v)
{
    VertexOutput o;
    o.pos = UnityObjectToClipPos(v.vertex);
    o.uv = v.uv;
    return o;
}

#endif

