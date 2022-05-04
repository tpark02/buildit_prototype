Shader "Custom/Foliage" 
{
 	Properties 
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)	
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Alpha ("Alpha", float) = 1
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags { "Queue"="AlphaTest+5" }
		
		LOD 300

		Blend SrcAlpha OneMinusSrcAlpha
	
		CGPROGRAM
		
		fixed4 _Color;				
		sampler2D _MainTex;
		fixed _Alpha;
		
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd keepalpha alphatest:_Cutoff
				
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Color.a * _Alpha;
		}
		 
		ENDCG
	}
}