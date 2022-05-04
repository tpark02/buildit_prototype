Shader "Custom/Window Glass" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}

	SubShader 
	{
		Tags { "Queue"="Geometry-92" "RenderType"="Opaque" }
		
		Cull Back

		LOD 300

		
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;
 
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd  keepalpha
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 0;
		}

		ENDCG
	
	}
 

	Fallback "VertexLit"
}
