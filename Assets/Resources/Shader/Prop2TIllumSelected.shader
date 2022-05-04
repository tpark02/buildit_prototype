Shader "Custom/Prop - (2Tex) Illum Selected" 
{
	Properties 
	{	
	    _Color ("Main Color", Color) = (1,1,1,1)
	    _MainTex ("Base (RGB)", 2D) = "white" { }	
	    _AlphaTex ("Trans (A)", 2D) = "white" { }	
	    _IllumColor ("Illum Color", Color) = (1,1,1,1)    
		_Intensity ("Intensity", float) = 1 	
		_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
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
		fixed _Intensity;
		fixed _LampLuminance;
		float4 _RimColor;

        #include "CustomLighting.inc"
        #pragma surface surf HalfLambert noforwardadd noambient
		
		struct Input {
			half2 uv_MainTex;
			float3 viewDir;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
		    float weight = (sin(_Time.r*100) + 1) * 0.3;

			fixed3 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed3 a = tex2D(_AlphaTex, IN.uv_MainTex);
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - a.g) * _LampLuminance * _Intensity;

        half rim = 1.2 - saturate(dot(normalize(IN.viewDir), o.Normal));
	
        o.Emission = _RimColor.rgb * pow (rim, 1 + weight);       
		}
		
		ENDCG
	}
		
	Fallback "VertexLit"

}