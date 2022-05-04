Shader "Hidden/Unlit/Transparent Masked Color Fill 1"
{
	Properties
	{
		_MainTex ("Base (RGB)", 2D) = "black" {}
		_MainOffset ("Base Offset", Vector) = (0,0,0,0)
		_MaskTex ("Mask (A)", 2D) = "white" {}
		_MaskOffset ("Mask Offset", Vector) = (0,0,0,0)
		_NumOfSpritesPer1D ("Number Of Sprites Per 1D", float) = 8
		_Ratio("Ratio", Range(0,1)) = 1
		_ColorChR ("Color R Channel", Color) = (0,0,0,1)
		_ColorChG ("Color G Channel", Color) = (0,0,0,1)
		_ColorChB ("Color B Channel", Color) = (0,0,0,1)
	}

	SubShader
	{
		LOD 200

		Tags
		{
			"Queue" = "Transparent"
			"IgnoreProjector" = "True"
			"RenderType" = "Transparent"
		}
		
		Pass
		{
			Cull Off
			Lighting Off
			ZWrite Off
			Offset -1, -1
			Fog { Mode Off }
			//ColorMask RGB
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			sampler2D _MainTex;
			float2 _MainOffset;
			sampler2D _MaskTex;
			float2 _MaskOffset;
			float _NumOfSpritesPer1D;
			float4 _ClipRange0 = float4(0.0, 0.0, 1.0, 1.0);
			float2 _ClipArgs0 = float2(1000.0, 1000.0);
			float _Ratio;
			fixed4 _ColorChR;
			fixed4 _ColorChG;
			fixed4 _ColorChB;

			struct appdata_t
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				fixed4 color : COLOR;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float2 texcoord : TEXCOORD0;
				float2 texcoord1 : TEXCOORD1;
				float2 worldPos : TEXCOORD2;
				fixed4 color : COLOR;
			};

			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.worldPos = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
				return o;
			}

			half4 frag (v2f IN) : SV_Target
			{
				// Softness factor
				float2 factor = (float2(1.0, 1.0) - abs(IN.worldPos)) * _ClipArgs0;
			
				half3 col = tex2D(_MainTex, IN.texcoord / _NumOfSpritesPer1D + _MainOffset);

				fixed4 mixed = lerp(fixed4(0,0,0,0), _ColorChR, col.r);	
				mixed = lerp(mixed, _ColorChG, col.g);	
				mixed = lerp(mixed, _ColorChB, col.b);

				mixed.a *= clamp( min(factor.x, factor.y), 0.0, 1.0);
				mixed.a *= tex2D(_MaskTex, IN.texcoord1 / _NumOfSpritesPer1D + _MaskOffset).a;
				return mixed;
			}
			ENDCG
		}
	}
	
}
