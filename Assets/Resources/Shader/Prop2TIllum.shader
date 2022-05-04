Shader "Custom/Prop - (2Tex) Illum" 
{
	Properties 
	{	
	    	_Color ("Main Color", Color) = (1,1,1,1)
	    	_MainTex ("Base (RGB)", 2D) = "white" { }	
	    	_AlphaTex ("Trans (A)", 2D) = "white" { }	
	    	_IllumColor ("Illum Color", Color) = (1,1,1,1)    
		_Intensity ("Intensity", float) = 1 	

		[Toggle] LUMINANCE_CONTROL ("Luminance Control On/Off", float) = 0
		_LuminanceParams ("Luminance Multiplier, Secondary Luminance", Vector) = (1,0,0,0) 		
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry-1" }
		
		LOD 200    	
	
		CGPROGRAM
	
		#pragma multi_compile LUMINANCE_CONTROL_OFF LUMINANCE_CONTROL_ON

		sampler2D _MainTex;
		sampler2D _AlphaTex;
		fixed4 _Color;
		fixed4 _IllumColor;
		fixed _Alpha;
		fixed _Intensity;
		fixed _LampLuminance;

		fixed4 _LuminanceParams;
		
        		#include "CustomLighting.inc"
        		#pragma surface surf HalfLambert noforwardadd
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed3 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed3 a = tex2D(_AlphaTex, IN.uv_MainTex);

			#ifdef LUMINANCE_CONTROL_ON	
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - a.g) * max(_LampLuminance * _LuminanceParams.r, _LuminanceParams.g) * _Intensity;
			#else
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - a.g) * _LampLuminance * _Intensity;
			#endif
		}
		
		ENDCG
	}
		
	Fallback "VertexLit"

}