Shader "Custom/Crop" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_Alpha ("Alpha", Range(0, 1)) = 1
  	}
 	
 	SubShader 
 	{
 	    Tags { "Queue"="Geometry-4" "DisableBatching"="True" }

		LOD 400

		Cull Off


		CGPROGRAM

        #include "CustomLighting.inc"
        #pragma surface surf HalfLambert vertex:vert noforwardadd
       
		#include "Wind.inc"

    uniform fixed4 _Color;
    uniform sampler2D _MainTex;
      	
		uniform float2 _WindSpeed;
	
		uniform float _TremblingAmplitude;
		uniform float _TremblingFrequency;
		
      	struct Input {
            half2 uv_MainTex;
        };

        void vert(inout appdata_full v) 
        {
        	float4 worldPosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
			float3 vPos = v.vertex;
	
        	float3 baseWorldPos = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
   
			ApplyMainBendingWithTrembling(vPos, normalize(_WindSpeed), length(_WindSpeed), baseWorldPos, 
				_TremblingFrequency, _TremblingAmplitude);

			v.vertex = float4(vPos.xyz, 1);
        }

        void surf(Input IN, inout SurfaceOutput o) 
  	    {
  	        fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
  	        o.Albedo = c.rgb;
  	        o.Alpha = 1;
       }

        ENDCG
    }
 
	Fallback "Custom/Prop"
}
