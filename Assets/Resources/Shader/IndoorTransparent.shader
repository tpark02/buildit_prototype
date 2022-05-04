Shader "Custom/Indoor - Transparent" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_OcclusionTex ("Occlusion (RGB) Trans (A)", 2D) = "white" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}

	SubShader 
	{
		Tags { "Queue"="Transparent" }
		
		LOD 300

		Blend SrcAlpha OneMinusSrcAlpha 	

		CGPROGRAM

		sampler2D _MainTex;
		sampler2D _OcclusionTex;
		fixed4 _Color;
		fixed _Alpha;
 
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert vertex:vert noforwardadd keepalpha
		
		struct Input {
			half2 uv_MainTex;	
			half2 uv2_OcclusionTex;
		};

		void vert(inout appdata_full v, out Input o)
		{
			o.uv_MainTex = v.texcoord.xy;
			o.uv2_OcclusionTex = v.texcoord1.xy;
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed4 ao = tex2D(_OcclusionTex, IN.uv2_OcclusionTex);
			o.Albedo = c.rgb * ao.rgb;
			o.Alpha = _Alpha;
		}

		ENDCG
	}
	
	Fallback "VertexLit"
}
