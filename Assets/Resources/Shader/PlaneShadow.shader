Shader "Custom/Plane Shadow" {
	
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Color", COLOR) = (1,1,1,1)
		_Alpha ("Alpha", Range(0, 1)) = 1

	}
	
	SubShader 
	{
		Tags { "Queue"="Transparent" }
		LOD 100
		
		Offset -1,-1				
		
		CGPROGRAM
		
		#include "CustomLighting.inc"
		#pragma surface surf Unlit alpha

		sampler2D _MainTex;
		fixed4 _Color;
		fixed _Alpha;
		
		struct Input {
			half2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Alpha;
		}
		ENDCG
	} 
	
	FallBack "Diffuse"
}
