Shader "Custom/Water - Alpha + UVAnim" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpeedX ("Speed X", float) = 1
		_SpeedY ("Speed Y", float) = 1
	}
	
	SubShader 
	{
		Tags { "Queue"="Transparent-1" }
		
		LOD 200

		Blend SrcAlpha OneMinusSrcAlpha 	
		ZWrite Off 
		
		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;	
 		float _SpeedX;
 		float _SpeedY;
 		
		#include "CustomLighting.inc"
		#pragma surface surf CustomLambertNoShade vertex:vert keepalpha noforwardadd nolightmap nometa noshadow
		
		 struct appdata {
		 	float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float3 normal : NORMAL;
		};

		struct Input {
			float2 uv_MainTex;
		};

		void vert(inout appdata v) 
		{
			v. texcoord = v.texcoord+ frac(float2(_SpeedX, _SpeedY) * _Time.g);
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}

		ENDCG
	}
	

	Fallback "VertexLit"
}
