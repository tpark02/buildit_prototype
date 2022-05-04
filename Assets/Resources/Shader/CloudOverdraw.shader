Shader "Custom/Cloud - Overdraw" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_Alpha ("Alpha", float) = 1
	}

	SubShader {
		Tags { "Queue" = "Transparent+2" }
		LOD 200

		ZWrite Off 
		ZTest Off
		Blend SrcAlpha OneMinusSrcAlpha 

		CGPROGRAM
	
		sampler2D _MainTex;
		fixed4 _Color;
		float _Alpha;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd keepalpha
	
		struct Input {
			float2 uv_MainTex;
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
