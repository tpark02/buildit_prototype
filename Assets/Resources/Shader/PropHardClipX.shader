Shader "Custom/Prop - HardClipX" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_XRange ("X Range", Vector) = (-200, 200, 0, 0)
	}

	SubShader 
	{
		Tags { "Queue"="Transparent+1" "RenderType"="Opaque" }
		
		LOD 200
		Blend SrcAlpha OneMinusSrcAlpha

		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;
		float2 _XRange;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert vertex:vert noforwardadd keepalpha
		
		struct Input {
			half2 uv_MainTex;
			float3 worldPos : TEXCOORD0;
		};

		void vert(inout appdata_full v, out Input o)
		{
			o.uv_MainTex = v.texcoord.xy;
			o.worldPos = mul(unity_ObjectToWorld, v.vertex);
		}
				
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;

			if (IN.worldPos.x > _XRange.x && IN.worldPos.x < _XRange.y)
			{
				o.Alpha = 1;
			}
			else 
			{
				o.Alpha = 0;
			}
		}

		ENDCG
	}
 
	Fallback "VertexLit"
}
