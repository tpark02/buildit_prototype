// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Ground - Alpha" 
{
 	Properties 
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)	
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags { "Queue"="AlphaTest" "RenderType"="Opaque" }
		
		LOD 300

		AlphaTest Greater [_Cutoff]
		Blend SrcAlpha OneMinusSrcAlpha 	
		CGPROGRAM
		
		fixed4 _Color;				
		sampler2D _MainTex;
		fixed _Alpha;
		
		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert noforwardadd keepalpha
				
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf (Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb * _Color.rgb;
			o.Alpha = c.a * _Color.a * _Alpha;
		}
		 
		ENDCG
	}

	SubShader 
	{
		Tags { "Queue" = "AlphaTest" "RenderType"="Opaque" }
		
		LOD 200
			
		Pass {

			Tags { "LightMode" = "ForwardBase" }

			AlphaTest Greater [_Cutoff]
			Blend SrcAlpha OneMinusSrcAlpha 

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
			fixed _Alpha;
			 
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
		       	return fixed4(c.rgb * i.vlight, c.a * _Color.a * _Alpha);
		    }

			ENDCG
		}
	}
}