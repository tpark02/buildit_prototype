Shader "Custom/Prop - UVAnim" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_SpeedX ("Speed X", float) = 1
		_SpeedY ("Speed Y", float) = 1
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry" }
		
		LOD 200

		CGPROGRAM

		sampler2D _MainTex;
		fixed4 _Color;	
 		half _SpeedX;
 		half _SpeedY;
 		
        #include "CustomLighting.inc"
        #pragma surface surf HalfLambert noforwardadd
		
		struct Input {
			float2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			float2 uv = IN.uv_MainTex + frac(float2(_SpeedX, _SpeedY) * _Time.r);
			fixed4 c = tex2D(_MainTex, uv) * _Color;
			o.Albedo = c.rgb;
			o.Alpha = 1;
		}

		ENDCG
	}
	

	Fallback "VertexLit"
}
