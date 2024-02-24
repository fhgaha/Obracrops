Shader "Custom/my2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Dither("Dither", 2D) = "white" {}
        _ColorRamp("Color Ramp", 2D) = "white" {}
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            sampler2D _Dither;
            float4 _Dither_TexelSize;

            sampler2D _ColorRamp;

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
            
                // just invert the colors
                //col.rgb = 1 - col.rgb;
                float m = 1.6f;
                float notlum = dot(col, float3(0.299f, 0.587f, 0.114f) * m);   //grayscale

                float lum = (notlum <= 0.04045) ? (notlum / 12.92f): pow((notlum + 0.055f) / 1.055f, 2.4f); //gamma correction

                float2 ditherCoords = i.uv * _Dither_TexelSize.xy * _MainTex_TexelSize.zw;
                float ditherLum = tex2D(_Dither, ditherCoords);
                float ramp = (lum <= clamp(ditherLum, 0.1f, 0.9f)) ? 0.1f : 0.9f;
                float3 output = tex2D(_ColorRamp, float2(ramp, 0.5f));
                return float4(output, 1.0f);
            }

            ENDCG
        }
    }
}


