Shader "Custom/Prop - Normal Rim" {

	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Roughness (A)", 2D) = "white" {}
		[normal] _BumpMap ("Normalmap", 2D) = "bump" {}           
		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)	
		_RimPower ("Rim Power", float) = 3.0	
	}
 
	SubShader 
	{
    	Tags { "Queue" = "Geometry" "RenderType"="Opaque" }

		LOD 100

		CGPROGRAM

		sampler2D _MainTex;
 		sampler2D _BumpMap;

		fixed4 _Color;
		fixed4 _RimColor;
		fixed _RimPower;	

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd
            
		struct Input
		{
			half2 uv_MainTex;
			half2 uv_BumpMap;                
			fixed3 viewDir;
		};
   
		void surf(Input IN, inout SurfaceOutput o) 
    	{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            
			o.Albedo = _Color * tex.rgb;             
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = 1;

			fixed rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));
				
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
         
		ENDCG

	}
    
	Fallback "Bumped Diffuse"

}
