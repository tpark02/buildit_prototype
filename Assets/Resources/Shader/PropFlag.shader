// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Prop - Flag" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_WaveStrength ("Wave Strength", float) = 1
		_WaveSpeed ("Wave Speed", float) = 1	
		_Alpha ("Alpha", float) = 1
	}
 	
 	SubShader 
 	{
      	Tags { "Queue"="Transparent" }	

		Cull Off 
		
        CGPROGRAM

      	fixed4 _Color;
      	sampler2D _MainTex;

      	float _WaveStrength;
      	float _WaveSpeed;
      	float _Alpha;
      	float _WindPower;

		#include "CustomLighting.inc"
        #pragma surface surf HalfLambertBothSide vertex:vert noforwardadd alpha:fade

		#include "UnityCG.cginc"

		struct v2f {
		    V2F_SHADOW_CASTER;
		    float2 uv : TEXCOORD1;
		};

        void ComputeWave(inout appdata_full v, inout v2f o)
		{
			float sinOff = (v.vertex.x + v.vertex.y + v.vertex.z) * _WaveStrength;
			float t = _Time.r * _WaveSpeed;
			float fx = v.texcoord.x * 0.3;
			float fy = v.texcoord.x * v.texcoord.y;

			float windX = sin(t * 4.75 + sinOff) * _WindPower * 10;
			float windZ = sin(t * 5.43 + sinOff) * _WindPower * 10;
			float windY = sin(t * 3.71 + sinOff) * _WindPower * 10;

			v.vertex.x += (windX + sin(t * 1.45 + sinOff)) * fx * 0.5;
			v.vertex.z = ((windZ + sin(t * 3.12 + sinOff)) * fx * 0.5 - fy * 0.9);
			v.vertex.y -= (windY + sin(t * 2.2 + sinOff)) * fx * 0.2;

			o.pos = UnityObjectToClipPos(v.vertex);
			o.uv = v.texcoord;
		}

		v2f vert(inout appdata_full v)
		{
			v2f o;
			ComputeWave(v, o);
			return o;
		}

       struct Input {
            float2 uv_MainTex;
        };
        
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = _Alpha;
		}

        ENDCG

	}
 
	Fallback "VertexLit"
}
