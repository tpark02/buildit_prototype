Shader "Custom/Water Edge Wave" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpeedX ("Speed X", float) = 1
		_SpeedY ("Speed Y", float) = 1
		_WaveScale ("Wave Scale", float) = 0.1
		_WavePhase ("Wave Phase", float) = 80
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
 		half _SpeedX;
 		half _SpeedY;
 		float _WaveScale;
 		float _WavePhase;

       		 #include "CustomLighting.inc"
       		 #pragma surface surf CustomLambertNoShade vertex:vert keepalpha noforwardadd nolightmap nometa noshadow
		
		
		 struct appdata {
		 	float4 vertex : POSITION;
			float2 texcoord : TEXCOORD0;
			float3 normal : NORMAL;
        		};

		struct Input {
			float2 uv_MainTex;
			fixed4 color;
		};

		void vert(inout appdata v) 
		{
			float phase = dot(v.vertex, float4(1,1,1,1));
			float offset = sin(_WavePhase * (_Time.r + phase)) * _WaveScale;
			v.vertex = v.vertex + float4(0, offset, 0, 0);
			v. texcoord = v.texcoord+ frac(float2(_SpeedX, _SpeedY) * _Time.r);
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = c.a * IN.color.r;
		}

		ENDCG
	}
	

	Fallback "VertexLit"
}
