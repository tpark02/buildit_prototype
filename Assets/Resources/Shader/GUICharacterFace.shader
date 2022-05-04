Shader "Custom/GUI/Character Face" 
{
	Properties 
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
		_MainTex ("Base (RGB) Roughness (A)", 2D) = "white" {}
		_ExprTex ("Expression (RGB) Trans (A)", 2D) = "white" {}
		_UVOffset ("UV Offset (Eye, Mouth)", Vector) = (0, 0, 0, 0)
		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)	
		_RimPower ("Rim Power", float) = 3.0	
		_SkinTint ("Skin Tint", Color) = (1,1,1,1)
	}

	SubShader 
	{
		Tags { "Queue"="Geometry+11" "RenderType"="Opaque" }
		
		CGPROGRAM

		sampler2D _MainTex;
		sampler2D _ExprTex;
		fixed4 _Color;
 		fixed4 _UVOffset;
 		fixed4 _RimColor;
		fixed _RimPower;
 		fixed4 _SkinTint;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambertNoAmbient vertex:vert noforwardadd noambient 
		 
		struct Input {
			half2 uv_MainTex;	
			half2 uv2_ExprTex;
			fixed4 color;
			fixed3 viewDir;
		};
		
		void vert(inout appdata_full v, out Input o)
		{
			o.uv_MainTex = v.texcoord.xy;
			o.uv2_ExprTex = v.texcoord1.xy;
			o.color = v.color;	
			o.viewDir = WorldSpaceViewDir(v.vertex);
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{ 
			fixed4 c1 = tex2D(_MainTex, IN.uv_MainTex);
			fixed4 c2 = tex2D(_ExprTex, IN.uv2_ExprTex + _UVOffset.rg);	
			fixed4 c3 = tex2D(_ExprTex, IN.uv2_ExprTex + _UVOffset.ba);
		
			fixed mask2 = IN.color.r * c2.a;
			fixed mask3 = IN.color.g * c3.a;
		
			fixed4 c = c1 * (_SkinTint + 0.25) * (1 - max(mask2, mask3)) + c2 * mask2 + c3 * mask3;
			o.Albedo = c * _Color;
			o.Alpha = 1;

			fixed rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal));

			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
		}
 
		ENDCG
	}

	Fallback "Custom/Prop"

}
