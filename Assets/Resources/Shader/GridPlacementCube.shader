Shader "Custom/Grid - Placement Cube" 
{
	Properties 
	{
        _Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}   
     	_AlphaRange ("Alpha Range", float) = 0.3
     	_AlphaSpeed ("Alpha Speed", float) = 30		     
	}
	
	SubShader 
	{
		Tags { "Queue" ="AlphaTest+10"}
		
		LOD 200

		//Cull Off
		ZTest Off
		ZWrite Off
		Lighting Off
		Fog { Mode off }  
		Blend SrcAlpha OneMinusSrcAlpha 
		
		CGPROGRAM
		
		sampler2D _MainTex;
		fixed4 _Color;
		fixed _AlphaRange;
		fixed _AlphaSpeed;	
        
        #include "CustomLighting.inc"
        #pragma surface surf Unlit keepalpha

		struct Input {
			half2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
		    o.Albedo = c * _Color;
		    o.Alpha = c.a * _Color.a;
		}
		
		ENDCG
	} 
	
	FallBack off
}
