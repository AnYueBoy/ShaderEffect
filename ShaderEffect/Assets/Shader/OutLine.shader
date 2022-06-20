Shader "Custom/OutLine"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutlineColor("OutlineColor",Color) = (1,1,1,1)
        _OutlineWidth("OutlineWidth",Range(0,5))=1
        [Toggle] _OutlineOnly("Outline Only",Range(0,1)) =0
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
            "IgnoreProjector" = "True"
        }
        ZWrite Off
        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include  "Common.cginc"

            float4 _MainTex_ST;
            fixed4 _OutlineColor;
            fixed _OutlineWidth;
            fixed _OutlineOnly;

            fixed4 frag(VertexOutput i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                if (_OutlineWidth == 0)
                {
                    return col;
                }
                fixed2 left_uv = i.uv + fixed2(-_MainTex_TexelSize.x * _OutlineWidth, 0);
                fixed2 right_uv = i.uv + fixed2(_MainTex_TexelSize.x * _OutlineWidth, 0);
                fixed2 up_uv = i.uv + fixed2(0, _MainTex_TexelSize.y * _OutlineWidth);
                fixed2 down_uv = i.uv + fixed2(0, -_MainTex_TexelSize.y * _OutlineWidth);
                fixed alpha = tex2D(_MainTex, left_uv).a * tex2D(_MainTex, right_uv).a * tex2D(_MainTex, up_uv).a *
                    tex2D(_MainTex, down_uv).a;

                col.rgb = lerp(_OutlineColor, col.rgb, alpha);
                if (_OutlineOnly == 1 && alpha != 0)
                {
                    col.a = 0;
                }
                return col;
            }
            ENDCG
        }
    }
}