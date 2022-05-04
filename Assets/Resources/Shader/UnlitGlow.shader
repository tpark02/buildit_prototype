Shader "Custom/Unlit - Glow" {

	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)	
		_RimPower ("Rim Power", float) = 3.0	
	}
 
	SubShader 
	{
    	Tags { "Queue" = "Geometry+10" "RenderType"="Opaque" }

		LOD 100

		CGPROGRAM

		sampler2D _MainTex;
 	
		fixed4 _Color;
		fixed4 _RimColor;
		fixed _RimPower;
 	       	
		#include "CustomLighting.inc"
		#pragma surface surf Unlit noforwardadd
            
		struct Input 
		{
			half2 uv_MainTex;
			fixed3 viewDir;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
    	{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
                
			o.Albedo = tex.rgb * _Color;             
			o.Alpha = 1;
                
			fixed rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
				
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
         
		ENDCG

	}
    
	Fallback "Bumped Diffuse"

}
