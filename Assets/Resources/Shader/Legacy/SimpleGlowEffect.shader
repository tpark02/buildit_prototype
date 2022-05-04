Shader "Legacy/SimpleGlowEffect" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_ScreenTex ("ScreenTex", 2D) = "white" {}
		_Tint ("Tint", Color) = (1,1,1,1)
		_Intensity ("Intensity", float) = 0
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform sampler2D _ScreenTex;		
	fixed4 _Tint;	
	float _Intensity;
	
	fixed4 glowEffect (v2f_img i) : COLOR
	{	
		fixed4 original = tex2D(_MainTex, i.uv);
		fixed4 overlay = tex2D(_ScreenTex, i.uv);
		
		return original + overlay * _Tint * _Intensity;
	}	
																																																																																																																																																																																																																																																												
	ENDCG
	
	
	SubShader {
	
		ZTest Always Cull Off ZWrite Off
		Fog { Mode off }  
		ColorMask RGB	  
  		  	
		Pass {    
		     CGPROGRAM
		     #pragma fragmentoption ARB_precision_hint_fastest
		     #pragma vertex vert_img
		     #pragma fragment glowEffect
		     ENDCG
		}	
						
	}
	
	Fallback off
}