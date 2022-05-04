Shader "Custom/Prop - Transparent + Illum" 
{
 	Properties 
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)	
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	  	_IllumColor ("Illum Color", Color) = (1,1,1,1)    
		_Intensity ("Intensity", float) = 1 
		_Alpha ("Alpha", float) = 1
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags { "Queue"="Transparent" }
		
		LOD 300

		Blend SrcAlpha OneMinusSrcAlpha
	
		CGPROGRAM
		
		fixed4 _Color;				
		sampler2D _MainTex;
		fixed _Alpha;
		fixed4 _IllumColor;
		fixed _Intensity;
		fixed _LampLuminance;

		
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd keepalpha alphatest:_Cutoff
				
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - c.a) * _LampLuminance * _Intensity;
			o.Alpha = _Alpha +  + _IllumColor.a * (1 - c.a) * _LampLuminance * _Intensity;
		}
		 
		ENDCG
	}

}