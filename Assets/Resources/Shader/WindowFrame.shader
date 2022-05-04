Shader "Custom/Window Frame" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "Queue"="Geometry-93" "RenderType"="Opaque" }
		
		LOD 300

		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;
 
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd  
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
 

	Fallback "VertexLit"
}
