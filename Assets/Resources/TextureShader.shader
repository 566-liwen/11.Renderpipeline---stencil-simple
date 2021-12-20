Shader "Unlit/TextureShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        
        Pass
        {
            //Name "ObjectB"
            Tags { "LightMode"="ObjectB" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2ff
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST; // what's this? oh contains scale (xy), offset(zw)...

            v2ff vert (appdata v)
            {
                v2ff o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			void frag (v2ff i,
            out half4 GRT2:SV_Target2
            )
			{                
                fixed4 col = tex2D(_MainTex, i.uv);
                GRT2 = col;
			}
            ENDCG
        }
    }
}
