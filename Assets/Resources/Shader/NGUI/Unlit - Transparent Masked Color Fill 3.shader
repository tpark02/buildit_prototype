Shader "Hidden/Unlit/Transparent Masked Color Fill 3"
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
			float4 _ClipArgs0 = float4(1000.0, 1000.0, 0.0, 1.0);
			float4 _ClipRange1 = float4(0.0, 0.0, 1.0, 1.0);
			float4 _ClipArgs1 = float4(1000.0, 1000.0, 0.0, 1.0);
			float4 _ClipRange2 = float4(0.0, 0.0, 1.0, 1.0);
			float4 _ClipArgs2 = float4(1000.0, 1000.0, 0.0, 1.0);
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
				float4 worldPos : TEXCOORD2;
				float2 worldPos2 : TEXCOORD3;
				fixed4 color : COLOR;
			};

			float2 Rotate (float2 v, float2 rot)
			{
				float2 ret;
				ret.x = v.x * rot.y - v.y * rot.x;
				ret.y = v.x * rot.x + v.y * rot.y;
				return ret;
			}

			v2f o;

			v2f vert (appdata_t v)
			{
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				o.texcoord1 = v.texcoord1;
				o.worldPos.xy = v.vertex.xy * _ClipRange0.zw + _ClipRange0.xy;
				o.worldPos.zw = Rotate(v.vertex.xy, _ClipArgs1.zw) * _ClipRange1.zw + _ClipRange1.xy;
				o.worldPos2 = Rotate(v.vertex.xy, _ClipArgs2.zw) * _ClipRange2.zw + _ClipRange2.xy;
				return o;
			}

			half4 frag (v2f IN) : SV_Target
			{
				// First clip region
				float2 factor = (float2(1.0, 1.0) - abs(IN.worldPos.xy)) * _ClipArgs0.xy;
				float f = min(factor.x, factor.y);

				// Second clip region
				factor = (float2(1.0, 1.0) - abs(IN.worldPos.zw)) * _ClipArgs1.xy;
				f = min(f, min(factor.x, factor.y));

				// Third clip region
				factor = (float2(1.0, 1.0) - abs(IN.worldPos2)) * _ClipArgs2.xy;
				f = min(f, min(factor.x, factor.y));

				half3 col = tex2D(_MainTex, IN.texcoord / _NumOfSpritesPer1D + _MainOffset);

				fixed4 mixed = lerp(fixed4(0,0,0,0), _ColorChR, col.r);	
				mixed = lerp(mixed, _ColorChG, col.g);	
				mixed = lerp(mixed, _ColorChB, col.b);

				mixed.a *= clamp(f, 0.0, 1.0);
				mixed.a *= tex2D(_MaskTex, IN.texcoord1 / _NumOfSpritesPer1D + _MaskOffset).a;
				return mixed;
			}
			ENDCG
		}
	}
}
