// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Unlit - Circle" {
	Properties {
		_MainTex ("Main Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_Radius ("Radius", float) = -0.5
		_Hardness("Hardness", float) = 1.0
	}
 
	SubShader 
	{
		Tags
		{
			"Queue"="AlphaTest"
			"IgnoreProjector"="True"
			"RenderType"="TransparentCutout"
			"PreviewType"="Plane"
		}

		Cull Off
		Lighting Off
		ZWrite Off
		Blend SrcAlpha OneMinusSrcAlpha

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
 
 			struct appdata_t
			{
				float4 vertex   : POSITION;
				float4 color    : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 vertex   : SV_POSITION;
				float4 color    : COLOR;
				float2 texcoord  : TEXCOORD0;
			};

			sampler2D _MainTex;
	 
			float4 _Color;
			float _Radius, _Hardness;


			v2f vert (appdata_t IN)
			{
				v2f OUT;
				OUT.vertex = UnityObjectToClipPos(IN.vertex);
				OUT.texcoord = IN.texcoord;
				OUT.color = IN.color * _Color;
				return OUT;
			}

			float4 frag (v2f IN) : SV_Target
			{
				float4 c = tex2D (_MainTex, IN.texcoord);
	 
				float dist = length(float2(0.5, 0.5) - IN.texcoord.xy);
	 			float circleTest = saturate(dist / (_Radius + 0.0001));
	 
	 			float4 color;
				color.rgb = _Color.rgb * c.rgb;
				color.a = pow(circleTest, _Hardness) * _Color.a * c.a;

				return color;
			}

			ENDCG
		}
	} 
	FallBack "Diffuse"
}