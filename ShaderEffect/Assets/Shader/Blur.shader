Shader "Custom/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Blur("Blur",Range(0,10)) = 3
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Transparent"
            "Queue" = "Transparent"
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
            float _Blur;

            #define  N 16
            #define  HalfN 8
            #define  PixelSize 0.003

            float BlurFactor(float x, float s)
            {
                return exp(-(x * x) / (2.0 * s * s));
            }

            float4 DoBlur(float2 uv, sampler2D tex, float _Blur)
            {
                float sigma = 0.1 + _Blur * 0.5;
                float4 ret = 0.0;
                float sum = 0.0;
                for (int y = 0; y < N; ++y)
                {
                    float fy = BlurFactor(float(y) - HalfN, sigma);
                    float offsetY = float(y - HalfN) * PixelSize;
                    for (int x = 0; x < N; ++x)
                    {
                        float fx = BlurFactor(float(x) - HalfN, sigma);
                        float offsetX = float(x - HalfN) * PixelSize;
                        ret += tex2D(tex, uv + float2(offsetX, offsetY)) * fx * fy;
                        sum += fx * fy;
                    }
                }
                return ret / sum;
            }

            fixed4 frag(VertexOutput i) : SV_Target
            {
                return DoBlur(i.uv, _MainTex, _Blur);
            }
            ENDCG
        }
    }
}