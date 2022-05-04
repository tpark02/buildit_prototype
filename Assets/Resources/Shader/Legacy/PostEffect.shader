Shader "Legacy/PostEffect" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_ScreenTex ("ScreenTex", 2D) = "white" {}
		_GlowTint ("Glow Tint", Color) = (1,1,1,1)
		_GlowIntensity ("Glow Intensity", float) = 0
		_Attr1 ("Attr1", float) = 0
		_Attr2 ("Attr2", float) = 0
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform sampler2D _ScreenTex;		
	fixed4 _GlowTint;	
	float _GlowIntensity;
	float _Attr1;
	float _Attr2;
	
	fixed4 glowEffect (v2f_img i) : COLOR
	{	
		fixed4 original = tex2D(_MainTex, i.uv);
		fixed4 overlay = tex2D(_ScreenTex, i.uv);
		
		return original + overlay * _GlowTint * _GlowIntensity;
	}	
	
	fixed4 bloomEffect (v2f_img i) : COLOR
	{	
		fixed4 original = tex2D(_MainTex, i.uv);
		fixed4 overlay = tex2D(_ScreenTex, i.uv);
		
		return original + overlay * _GlowTint * _GlowIntensity;
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

		Pass {    
		     CGPROGRAM
		     #pragma fragmentoption ARB_precision_hint_fastest
		     #pragma vertex vert_img
		     #pragma fragment bloomEffect
		     ENDCG
		}					

	}
	
	Fallback off
}