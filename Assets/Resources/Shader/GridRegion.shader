// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Grid - Region" 
{
	Properties 
	{
        _Color1 ("Pattern Color 1", Color) = (1,1,1,1)
		_Color2 ("Pattern Color 2", Color) = (1,1,1,1)
	
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_OccupantTex ("Base (RGB)", 2D) = "white" {}	     
	}
	
	SubShader 
	{
		Tags { "Queue" ="Geometry-76"}
		
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha 
		ZTest Always 
		ZWrite Off
		
		Lighting Off
		Fog { Mode off }    		
		
		CGPROGRAM
		
		sampler2D _MainTex;	
		sampler2D _OccupantTex;
		fixed4 _Color1;
		fixed4 _Color2;

		#include "CustomLighting.inc"
		#pragma surface surf Unlit vertex:vert keepalpha

		struct Input {
			half2 uv_MainTex;	
			float2 worldPos2D;
		};

		void vert(inout appdata_full v, out Input o)
		{
			o.uv_MainTex = v.texcoord.xy;
			float4 worldPos = mul(unity_ObjectToWorld, v.vertex );
			o.worldPos2D = float2(worldPos.x, worldPos.z) + 128;
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);

			fixed2 uv_OccupantTex = (floor(IN.worldPos2D + 0.5) + 0.5) / 256 ;
			fixed4 c2 = tex2D(_OccupantTex, uv_OccupantTex);
		    
		    o.Albedo = c.r * _Color1.rgb + (1 - c.r) * _Color2.rgb;     
		    o.Albedo = o.Albedo * c2;         
			o.Alpha = c.r * _Color1.a + (1 - c.r) * _Color2.a;
			o.Alpha = o.Alpha * c.a * c2.a;
		}
		
		ENDCG
	} 
	
	FallBack off
}
