Shader "Custom/GUI/Prop - (2Tex) Illum" 
{
	Properties 
	{	
	    _Color ("Main Color", Color) = (1,1,1,1)
	    _MainTex ("Base (RGB)", 2D) = "white" { }	
	    _AlphaTex ("Trans (A)", 2D) = "white" { }	
	    _IllumColor ("Illum Color", Color) = (1,1,1,1)    
	_Intensity ("Intensity", float) = 1 	
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry-1" }
		
		LOD 200    	
	
		CGPROGRAM
	
		sampler2D _MainTex;
		sampler2D _AlphaTex;
		fixed4 _Color;
		fixed4 _IllumColor;
		fixed _Alpha;
		fixed _Intensity;
		fixed _LampLuminance;

        #include "CustomLighting.inc"
        #pragma surface surf HalfLambertNoAmbient noforwardadd noambient
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed3 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed3 a = tex2D(_AlphaTex, IN.uv_MainTex);
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - a.g) * _LampLuminance * _Intensity;
		}
		
		ENDCG
	}
		
	Fallback "VertexLit"

}