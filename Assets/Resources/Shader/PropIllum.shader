Shader "Custom/Prop - Illum" 
{
	Properties 
	{
	    _Color ("Main Color", Color) = (1,1,1,1)
	    _IllumColor ("Illum Color", Color) = (1,1,1,1)    
		_Intensity ("Intensity", float) = 1 
	    _MainTex ("Texture", 2D) = "white" { }	
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry-1" }
		
		LOD 200    	
	
		CGPROGRAM
	
		sampler2D _MainTex;
		fixed4 _Color;
		fixed4 _IllumColor;
		fixed _Alpha;
		fixed _Intensity;
		fixed _LampLuminance;

        #include "CustomLighting.inc"
        #pragma surface surf HalfLambert noforwardadd
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb + _IllumColor.rgb * (1 - c.a) * _LampLuminance * _Intensity;
		}
		
		ENDCG
	}
		
	Fallback "VertexLit"

}