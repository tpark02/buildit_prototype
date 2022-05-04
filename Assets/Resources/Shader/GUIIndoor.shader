Shader "Custom/GUI/Indoor" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_OcclusionTex ("Occlusion (RGB) Trans (A)", 2D) = "white" {}
	}
 
	SubShader 
	{
		Tags { "Queue"="Geometry-90" "RenderType"="Opaque" }
		
		LOD 300

		CGPROGRAM

		sampler2D _MainTex;
		sampler2D _OcclusionTex;
		fixed4 _Color;
 
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambertNoAmbient vertex:vert noforwardadd  noambient
		
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
			o.Alpha = 1;
		}

		ENDCG
	}
	
	Fallback "VertexLit"
}
