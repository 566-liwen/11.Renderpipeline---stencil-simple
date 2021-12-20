Shader "Unlit/CombineShader"
{
   Properties
    {
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        
        
        Stencil {
            Ref 2          //0-255
            Comp Equal     //default:always
            //Pass keep   //default:keep
            //Fail keep      //default:keep
            //ZFail keep     //default:keep
        }
        

        Pass
        {

            ZTest Off
            ZWrite Off

            //Blend SrcAlpha OneMinusDstAlpha
            //Blend  SrcAlpha OneMinusSrcAlpha
            //ColorMask RBG
            //Blend SrcAlpha One

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma target 4.0

            #include "UnityCG.cginc"

            Texture2D _GBuffer0;
            Texture2D _GBuffer1;
            Texture2D _GBuffer2;
            Texture2D _GBuffer3;

            Texture2D _Depth;

            SamplerState sampler_pointer_clamp;

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

            struct GBufferOutput
            {
                half4 GBuffer4 : SV_Target4;
            };

            v2ff vert (appdata v)
            {
                v2ff o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            bool compareTwoColors(half4 x, half4 y) {
                if (x.r == y.r && x.g == y.g && x.b == y.b && x.a == y.a)  return true;
                return false;
            }

			half4 frag (v2ff i): SV_Target
			{            
                //uint stencil = _GBuffer0.Sample(sampler_pointer_clamp, i.uv).STENCIL_CHANNEL;

                //float depth = _XDepthTexture.Sample(sampler_pointer_clamp,input.uv).x;

                half4 g0 = _GBuffer0.Sample(sampler_pointer_clamp, i.uv);
                half4 g1 = _GBuffer1.Sample(sampler_pointer_clamp, i.uv);
                //half4 g2 = _GBuffer2.Sample(sampler_pointer_clamp, i.uv);
                half4 g3 = _GBuffer3.Sample(sampler_pointer_clamp, i.uv);


               // half4 col = g0 + g1; // color from background (deep blue)
                //col.a = g0.a;
                //return lerp(g2, g1, g0);

                // "masking" background color by checking if the pixel is in same color
                /*
                if (compareTwoColors(g0, g1) && compareTwoColors(g0, g2) && compareTwoColors(g0, g3)) {
                    return g0;
                } else {
                    return g0 + g1 + g2 +g3;
                }
                */
                int xRes = 1024;
                int yRes = 768;

                //uint stencil = _GBuffer0.Load(int3(floor(i.uv.x * xRes), floor(i.uv.y * yRes), 0)).STENCIL_CHANNEL;

                //return g0 + g1 + g2 +g3;
                //int xRes = 1024;
                //int yRes = 768;

                //uint stencil = _GBuffer0.Load(int3(floor(i.uv.x * xRes), floor(i.uv.y * yRes), 0)).STENCIL_CHANNEL;

                //return (g0 + g1) * g0.a;
                //return g0+g1;
                //return g3;

                //if (g3.a == 0) {
                //    discard;
                //} 
                //g0.a = 0;
                //return (0,0,0,g3.a);
                return g0 + g1;
              
			}

            ENDCG
        }
    }
}
