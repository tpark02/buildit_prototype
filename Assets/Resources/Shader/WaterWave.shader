// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/WaterWave" {

Properties {
    _Color ("Main Color", Color) = (1,1,1,1)
    _MainTex ("Color", 2D) = "white" { }
    
}
SubShader {
	Tags { "Queue"="Transparent-1"}

   	Blend SrcAlpha OneMinusSrcAlpha 
   	ZWrite Off 

	LOD 200
	
    Fog { Mode Off }
    Lighting Off   

    Pass {
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag
		#include "UnityCG.cginc"
		
		float4 _Color;
				
		sampler2D _MainTex;
		float4 _MainTex_ST;
				
		struct appdata {
			fixed4 vertex : POSITION;
			fixed3 normal : NORMAL;
			fixed2 texcoord : TEXCOORD0;
			fixed2 texcoord1 : TEXCOORD1;
			fixed4 color : COLOR;
		};
		
		struct v2f {
		    float4  pos : SV_POSITION;
		    float2  uv : TEXCOORD0;
		    float4	color : COLOR;
		};
		
		v2f vert (appdata v)
		{
		    v2f o;
		    o.pos = UnityObjectToClipPos(v.vertex);
		    o.uv = TRANSFORM_TEX (v.texcoord.xy, _MainTex);
		    		  
		   	o.color = v.color;

		    return o;
		}
		
		half4 frag (v2f i) : COLOR
		{
		    half4 c = tex2D(_MainTex, i.uv.xy) * _Color;		     
		    half4 ambient = UNITY_LIGHTMODEL_AMBIENT * 2; 	
  		    c.rgb *= ambient;
			c.a *= i.color.r;
		    return c;
		}
		
		ENDCG
		
		}
	}
	
Fallback "Diffuse"

}