Shader "Custom/Grid - Ranch" 
{
	Properties 
	{
        _Color1 ("Pattern Color 1", Color) = (1,1,1,1)
		_Color2 ("Pattern Color 2", Color) = (1,1,1,1)
	
		_MainTex ("Base (RGB)", 2D) = "white" {}		     
	}
	
	SubShader 
	{
		Tags { "Queue" ="Geometry-66"}
		
		LOD 200

		Blend One One 
		ZTest Always 
		ZWrite Off
		
		Lighting Off
		Fog { Mode off }    		
		
		CGPROGRAM
		
		sampler2D _MainTex;
		fixed4 _Color1;
		fixed4 _Color2;

		#include "CustomLighting.inc"
		#pragma surface surf Unlit alpha

		struct Input {
			half2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
		    o.Albedo = c.r * _Color1.rgb + (1 - c.r) * _Color2.rgb;              
			o.Alpha = c.r * _Color1.a + (1 - c.r) * _Color2.a;
		}
		
		ENDCG
	} 
	
	FallBack off
}
