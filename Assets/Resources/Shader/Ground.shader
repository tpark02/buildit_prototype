// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Ground" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	
	SubShader 
	{
		Tags { "Queue" = "Geometry-800" "RenderType"="Opaque" }
 		
		LOD 300

		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;
		
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd  
		
		struct Input {
			half2 uv_MainTex;
		};
		 
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}

	SubShader 
	{	
		Tags { "Queue" = "Geometry-100" "RenderType"="Opaque" }
		
		LOD 200
		
		Pass {

			Tags { "LightMode" = "ForwardBase" }
		
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag
			#pragma multi_compile_fwdbase nodirlightmap noforwardadd 
			#define UNITY_PASS_FORWARDBASE
			
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "AutoLight.cginc"
			
			#include "CustomLighting.inc"
						
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color;
			
	      	struct VertexInput {
	        	float4 vertex : POSITION;
	        	fixed3 normal : NORMAL;
	            half2 texcoord : TEXCOORD0;
	        };
	        
	        struct VertexOutput {
	        	float4 pos : SV_POSITION;
	        	fixed3 normal : TEXCOORD0;
	        	half2 uv : TEXCOORD1;
	        	fixed3 vlight : TEXCOORD2;
	        };
			 
	        VertexOutput vert(VertexInput v) 
	        {
	            VertexOutput o;
	        
	            o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
	            o.pos = UnityObjectToClipPos(v.vertex);
	            
	            float3 worldN = mul((float3x3)unity_ObjectToWorld, SCALED_NORMAL);
				o.normal = worldN;
	           
				o.vlight = ShadeSH9(float4(worldN,1.0));
				o.vlight += LightingHalfLambertVS(worldN, _WorldSpaceLightPos0.xyz);
				o.vlight *= _Color;
				
	            return o;
	        }
	        
	        fixed4 frag(VertexOutput i) : COLOR 
	        {
	        	fixed4 c = tex2D(_MainTex, i.uv);
		   		return fixed4(c.rgb * i.vlight, 1);
		    }

			ENDCG
		}	
	}

	Fallback "VertexLit"
}
