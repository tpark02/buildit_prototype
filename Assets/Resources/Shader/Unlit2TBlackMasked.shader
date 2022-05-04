Shader "Custom/Unlit - 2 Textures (Black Masked)" {

	Properties 
	{
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_SecondaryTex ("Tex2 (RGB)", 2D) = "white" {}
	}
 
	SubShader 
	{
    	Tags { "Queue" = "Geometry+10" "RenderType"="Opaque" }

		LOD 100

		CGPROGRAM

		sampler2D _MainTex;
		sampler2D _SecondaryTex;
  	
		fixed4 _Color;
 	       	
		#include "CustomLighting.inc"
		#pragma surface surf Unlit noforwardadd
            
		struct Input 
		{
			half2 uv_MainTex;
			half2 uv2_SecondaryTex;
			fixed3 viewDir;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
    		{	
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
              			fixed4 tex2 = tex2D(_SecondaryTex, IN.uv2_SecondaryTex);
                  
                  		if (dot(tex.rgb, fixed3(1,1,1)) == 0) 
                  		{
				o.Albedo = tex2 * _Color; 
			}
			else 
			{
				o.Albedo = tex * _Color;
			}            
			o.Alpha = 1;
                	}
         
		ENDCG

	}
    
	Fallback "Bumped Diffuse"

}
