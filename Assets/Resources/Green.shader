Shader "Unlit/Green"
{
   Properties
    {
    }
    SubShader
    {   
       Tags { "RenderType"="Opaque" "Queue"="Geometry+1"}

       Stencil {
            Ref 2          
            Comp equal    
        }

        Pass
        {
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

			half4 frag (v2ff i) : SV_Target {  
			        
				return half4(0,1,0,1);
			}
            ENDCG
        }
     }
}

