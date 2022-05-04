Shader "Custom/Character UVAni" {

	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB) Roughness (A)", 2D) = "white" {}
		[normal] _BumpMap ("Normalmap", 2D) = "bump" {}           
		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)	
		_RimPower ("Rim Power", float) = 3.0	
		_SkinTint ("Skin Tint", Color) = (1,1,1,1)

		_MaskTex("Mask (A)", 2D) = "white" { }
		_MaskNoiseTex("MaskNoise", 2D) = "white" { }

		_ScrollXSpeed("X Scroll Speed", Range(-15, 15)) = 0
		_ScrollYSpeed("Y Scroll Speed", Range(-15, 15)) = 0

		_NoiseMaskIntensity1("NoiseI Mask Intensity", Range(-5, 15)) = 1
		 
	}
 
	SubShader 
	{
    	Tags { "Queue" = "Geometry+10" "RenderType"="Opaque" }

		LOD 100

		CGPROGRAM

		sampler2D _MainTex;
 		sampler2D _BumpMap;
		sampler2D _MaskTex;
		sampler2D _MaskNoiseTex;

		fixed4 _Color;
		fixed4 _RimColor;
		fixed _RimPower;
 		fixed4 _SkinTint;	

		fixed _ScrollXSpeed;
		fixed _ScrollYSpeed;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd
            
		struct Input
		{
			half2 uv_MainTex;
			half2 uv_BumpMap;                
			fixed3 viewDir;
			float2 uv_MaskTex;
			float2 uv_MaskNoiseTex;

		};



		fixed _NoiseMaskIntensity1;



   
		void surf(Input IN, inout SurfaceOutput o) 
    	{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
            
            fixed4 skinColor = 1;

            if (tex.a < 1) {
            	skinColor = _SkinTint + 0.25;
            }


			fixed varX = _ScrollXSpeed * _Time;
			fixed varY = _ScrollYSpeed * _Time;

			
			 
                
			o.Albedo = _Color * tex.rgb * skinColor;             
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = 1;

			fixed rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));


			// mask add
			fixed4 lampNoise = tex2D(_MaskNoiseTex, IN.uv_MaskNoiseTex);
			
			fixed2 uv_Tex = IN.uv_MaskNoiseTex  + fixed2(varX, varY);
		




			o.Emission = _RimColor.rgb * pow(rim, _RimPower);



			// add color
			o.Emission += tex2D(_MaskTex, IN.uv_MainTex) * tex2D(_MaskNoiseTex, uv_Tex) * _NoiseMaskIntensity1;
		}
         
		ENDCG

	}
    
	Fallback "Bumped Diffuse"

}
