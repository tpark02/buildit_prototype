// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Water Tile" {
	Properties {
		_TintColor ("Tint Color", Color) = (1,1,1,1)
		_WaterSpeed ("Water Speed", float) = 1
		_Water ("Water", 2D) = "white" {}
		_WaterOpaque ("Water Opaque", float) = 0.5
	}
	SubShader {
		Tags {
			"IgnoreProjector"="True"
			"Queue"="Transparent"
			"RenderType"="Transparent"
		}
		Pass {
			Name "ForwardBase"
			Tags {
				"LightMode"="ForwardBase"
			}
			Blend SrcAlpha OneMinusSrcAlpha
			ZWrite Off
			
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#define UNITY_PASS_FORWARDBASE
			#include "UnityCG.cginc"
			#pragma multi_compile_fwdbase
			uniform sampler2D _Water;
			uniform half _WaterSpeed;
			uniform half3 _TintColor;
			uniform half _WaterOpaque;

			struct VertexInput {
				float4 vertex : POSITION;
				float2 texcoord0 : TEXCOORD0;
				fixed4 vertexColor : COLOR;
			};
			
			struct VertexOutput {
				float4 pos : SV_POSITION;
				float2 uv0 : TEXCOORD0;
				float2 uv1 : TEXCOORD1;
				fixed4 vertexColor : COLOR;
			};
			
			VertexOutput vert (VertexInput v) {
				VertexOutput o;

				float speed = frac(_Time.r*_WaterSpeed);
				o.uv0 = v.texcoord0.rg+mul(unity_WorldToObject, float4(speed,0,0,0)).rb;
				o.uv1 = v.texcoord0.rg+mul(unity_WorldToObject, float4(0,0,speed,0) +float4(0.123,0,0.1234,0)).rb;

				o.vertexColor = v.vertexColor;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}
			
			half4 frag(VertexOutput i) : COLOR 
			{
				half3 caustic0 = tex2D(_Water, i.uv0);
				half3 caustic1 = tex2D(_Water, i.uv1);
				half caustic = caustic0.r * caustic1.r;
			   
				half node_1524 = (i.vertexColor.a*caustic);
				half alpha = saturate(node_1524 + caustic);
				half3 emissive = lerp(_TintColor + half3(alpha,alpha,alpha), half3(1,1,1), alpha);
			   
				return half4(emissive, max(i.vertexColor.r, _WaterOpaque));
			}
			ENDCG
		}
	}
	FallBack "Diffuse"   
}
