Shader "Custom/Ground - (2Tex, L2) Overdraw" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_AlphaTex ("Trans (A)", 2D) = "white" {}
		_Alpha ("Alpha", float) = 1
	}

	SubShader {
		Tags { "Queue" = "Geometry-68" "RenderType"="Opaque" }
		LOD 200

		ZWrite Off 
		ZTest Off
		Blend SrcAlpha OneMinusSrcAlpha 

		CGPROGRAM
	
		sampler2D _MainTex;
		sampler2D _AlphaTex;
		fixed4 _Color;
		float _Alpha;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd alpha
	
		struct Input {
			half2 uv_MainTex;
		};
		 
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed3 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed3 a = tex2D(_AlphaTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = a.g * _Color.a * _Alpha;
		}

		ENDCG
	}

	Fallback "VertexLit"
}
