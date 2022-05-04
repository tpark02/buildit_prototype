Shader "Legacy/SimpleBloomEffect" {
	Properties {
		_MainTex ("MainTex", 2D) = "white" {}
		_ScreenTex ("ScreenTex", 2D) = "white" {}
		
		_GlowTint ("Tint", Color) = (1,1,1,1)
		_GlowIntensity ("Intensity", float) = 0.5
		
		_BlurSpread ("BlurSpread", float) = 0.005
		
		_BloomTolerance ("Tolerance", float) = 0				
		_BloomIntensity ("Intensity", float) = 0.5
	}
	
	CGINCLUDE
	#include "UnityCG.cginc"

	uniform sampler2D _MainTex;
	uniform sampler2D _ScreenTex;		
	
	fixed4 _GlowTint;
	float _GlowIntensity;

	float _BlurSpread;
	float _BloomTolerance;
	float _BloomIntensity;	
	
	fixed4 BloomSource1 (v2f_img i) : COLOR
	{	
		fixed4 c = tex2D(_MainTex, i.uv);
		
		float bloomValue = max(c.r + c.g + c.b - _BloomTolerance, 0);
		
		if (bloomValue > 0)
		{
			fixed4 tt = tex2D(_MainTex, float2(i.uv.x, i.uv.y - _BlurSpread));
			fixed4 ll = tex2D(_MainTex, float2(i.uv.x - _BlurSpread, i.uv.y));
			fixed4 cc = tex2D(_MainTex, i.uv);		
			fixed4 rr = tex2D(_MainTex, float2(i.uv.x + _BlurSpread, i.uv.y));
			fixed4 bb = tex2D(_MainTex, float2(i.uv.x, i.uv.y + _BlurSpread));
		
			fixed4 bl = tex2D(_MainTex, float2(i.uv.x - _BlurSpread, i.uv.y + _BlurSpread));
			fixed4 br = tex2D(_MainTex, float2(i.uv.x + _BlurSpread, i.uv.y + _BlurSpread));
			
			fixed4 bloom = (tt*0.08 + ll*0.08  + rr*0.08 + bb*0.08 + bl*0.04 + br*0.04) * bloomValue * _BloomIntensity;
							
			return c + bloom;		
		}
		else
		{
			return c;
		}	
	}
	
	fixed4 BloomSource2 (v2f_img i) : COLOR
	{	
		fixed4 c = tex2D(_MainTex, i.uv);
		
		float bloomValue = max(c.r + c.g + c.b - _BloomTolerance, 0);
		
		if (bloomValue > 0)
		{
			fixed4 tt = tex2D(_MainTex, float2(i.uv.x, i.uv.y - _BlurSpread*2));
			fixed4 ll = tex2D(_MainTex, float2(i.uv.x - _BlurSpread*2, i.uv.y));
			fixed4 rr = tex2D(_MainTex, float2(i.uv.x + _BlurSpread*2, i.uv.y));
			fixed4 bb = tex2D(_MainTex, float2(i.uv.x, i.uv.y + _BlurSpread*2));
			fixed4 tl = tex2D(_MainTex, float2(i.uv.x - _BlurSpread, i.uv.y - _BlurSpread));
			fixed4 tr = tex2D(_MainTex, float2(i.uv.x + _BlurSpread, i.uv.y - _BlurSpread));

			fixed4 bloom = (tt + ll + rr + bb + tl + tr) * 0.04 * bloomValue * _BloomIntensity;
							
			return c + bloom;		
		}
		else
		{
			return c;
		}	
	}

	fixed4 BloomSource3 (v2f_img i) : COLOR
	{	
		fixed4 c = tex2D(_MainTex, i.uv);
		
		float bloomValue = max(c.r + c.g + c.b - _BloomTolerance, 0);
		
		if (bloomValue > 0)
		{
			fixed4 t0 = tex2D(_MainTex, float2(i.uv.x - _BlurSpread, i.uv.y - _BlurSpread*2));
			fixed4 t1 = tex2D(_MainTex, float2(i.uv.x - _BlurSpread*2, i.uv.y - _BlurSpread));
			fixed4 t2 = tex2D(_MainTex, float2(i.uv.x - _BlurSpread*2, i.uv.y + _BlurSpread));
			fixed4 t3 = tex2D(_MainTex, float2(i.uv.x - _BlurSpread, i.uv.y + _BlurSpread*2));
			fixed4 t4 = tex2D(_MainTex, float2(i.uv.x + _BlurSpread, i.uv.y + _BlurSpread*2));
			fixed4 t5 = tex2D(_MainTex, float2(i.uv.x + _BlurSpread*2, i.uv.y + _BlurSpread));
			fixed4 t6 = tex2D(_MainTex, float2(i.uv.x + _BlurSpread*2, i.uv.y - _BlurSpread));
			//fixed4 t7 = tex2D(_ScreenTex, float2(i.uv.x + _BlurSpread, i.uv.y - _BlurSpread*2));

			fixed4 bloom = (t0 + t1 + t2 + t3 + t4 + t5 + t6) * 0.02 * bloomValue * _BloomIntensity;
							
			return c + bloom;		
		}
		else
		{
			return c;
		}	
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
		     #pragma fragment BloomSource1
		     ENDCG
		}	
							
		Pass {    
		     CGPROGRAM
		     #pragma fragmentoption ARB_precision_hint_fastest
		     #pragma vertex vert_img
		     #pragma fragment BloomSource2
		     ENDCG
		}
								
		Pass {    
		     CGPROGRAM
		     #pragma fragmentoption ARB_precision_hint_fastest
		     #pragma vertex vert_img
		     #pragma fragment BloomSource3
		     ENDCG
		}						

	}
	
	Fallback off
}