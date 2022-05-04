Shader "Custom/Grid - Focus" 
{
	Properties 
	{
        _Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}   
     	_AlphaRange ("Alpha Range", float) = 0.3
     	_AlphaSpeed ("Alpha Speed", float) = 30		     
	}
	
	SubShader 
	{
		Tags { "Queue" ="Transparent"}
		
		LOD 200
				
		Blend One One 
		ZTest Off 
		ZWrite Off
		
		Lighting Off
		Fog { Mode off }    		
		
		CGPROGRAM
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _AlphaRange;
		fixed _AlphaSpeed;	

		#include "CustomLighting.inc"
		#pragma surface surf Unlit alpha
			
		struct Input {
			half2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			fixed t = _Time * _AlphaSpeed;
		    o.Albedo = c.rgb * _Color.rgb;              
			o.Alpha = c.a * (_AlphaRange / 2 * sin(t) + _Color.a);
		}
		
		ENDCG
	} 
	
	FallBack off
}
