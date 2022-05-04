Shader "Custom/FX - Transparent" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Alpha ("Alpha", float) = 1
	}

	SubShader 
	{
		Tags { "Queue"="Transparent" }
			
		LOD 200

		CGPROGRAM
		#include "CustomLighting.inc"
		#pragma surface surf Unlit alpha
		
		sampler2D _MainTex;
		fixed4 _Color;
		float _Alpha;

		struct Input {
			fixed2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a * _Alpha;
		}
	    
		ENDCG
	}

	Fallback "VertexLit"
}
