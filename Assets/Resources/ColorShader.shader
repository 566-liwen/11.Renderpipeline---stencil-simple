Shader "Unlit/ColorShader"
{
    Properties
    {
    }
    SubShader
    {   
        

        //Name "DEFERRED"
        
        Stencil {
            Ref 2          //0-255
            Comp always     //default:always
            Pass replace   //default:keep
            //Fail keep      //default:keep
            //ZFail keep     //default:keep
        }
        

        Pass
        {
            //Name "ObjectA"
            Tags { "LightMode"="ObjectA" }

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
            };

            struct v2ff
            {
                float4 vertex : SV_POSITION;
                float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
                float3 vertexWC : TEXCOORD3;
            };

            float4 LightPosition;
            float4 LightDirection;

            v2ff vert (appdata v)
            {
                v2ff o;
                /*
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                o.vertexWC = mul(UNITY_MATRIX_M, v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                */


                o.vertex = UnityObjectToClipPos(v.vertex);   // World to NDC

				o.uv = v.uv; // no specific placement support

                o.vertexWC = mul(UNITY_MATRIX_M, v.vertex); // this is in WC space!
                // this is not pretty but we don't have access to inverse-transpose ...
                float3 p = v.vertex + v.normal;
                p = mul(UNITY_MATRIX_M, p);  // now in WC space
                o.normal = normalize(p - o.vertexWC); // NOTE: this is in the world space!!
                return o;
            }

            fixed4 ComputeDiffuse(v2ff i) {
                //float3 l = normalize(LightPosition - i.vertexWC);
                float3 l = normalize(LightPosition);
                return clamp(dot(i.normal, l), 0, 1);
            }

            fixed4 ComputeDiffuse2(v2ff i) {
                return max(0,dot(i.normal, LightPosition.xyz)) * float4(1,0,0,1);
            }

            //https://github.com/wlgys8/SRPLearn/wiki/DirLight
            half4 BlinnPhongSpecular(float3 viewDir, v2ff i){
                float3 halfDir = normalize((viewDir  + LightDirection));
                float nh = max(0,dot(halfDir,i.normal));
                return pow(nh,1) * float4(1,0,0,1);
            }

			void frag (v2ff i,
            out half4 GRT0:SV_Target0,
            out half4 GRT1:SV_Target1,
            out float GRTDepth:SV_Depth
            )
			{   //float3 viewDir = normalize( _WorldSpaceCameraPos - i.vertexWC);
                //GRT1 = ComputeDiffuse2(i) * (1,1,1,1);
                //GRT1 = BlinnPhongSpecular(viewDir, i);
				//GRT0 = float4(i.normal.x, i.normal.y, i.normal.z, 1);
                //GRT0 = float4(i.uv.x, i.uv.y, 0, 1);
                //GRT1 = float4(1,0,0,1) * diff;
				//GRT1 = float4(0,1,0,1);
                
                float diff = ComputeDiffuse(i);
                GRT0 =  float4(0,1,0,1) * diff;
                GRT1 =  float4(1,0,0,1) * diff;
                

                GRTDepth = 0.5;    

			}
            ENDCG
        }

        /*
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
            };

            struct v2ff
            {
                float4 vertex : SV_POSITION;
            };

            v2ff vert (appdata v)
            {
                v2ff o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

			void frag (v2ff i,
            out half4 GRT2:SV_Target2,
            out half4 GRT3:SV_Target3,
            out float GRTDepth:SV_Depth
            )
			{                
                GRT2 = float4(0,0,0.2,0);
                GRT3 = float4(0,0,0.2,0);
                 GRTDepth = 0.5;
			}
            ENDCG
        }
        */
    }
}