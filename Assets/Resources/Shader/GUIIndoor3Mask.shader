Shader "Custom/GUI/Indoor (3 Masks)" {

    Properties 
    {
    	_MainColor ("Main Color", Color) = (1,1,1,1) 
		_Color ("Color (R)", Color) = (1,1,1,1)
   		_SubColorG("Color (G)", Color) = (1,1,1,1)
   		_SubColorB("Color (B)", Color) = (1,1,1,1)

        	_MainTex ("Base (RGB)", 2D) = "white" {}
        	_OcclusionTex ("Occlusion (RGB) Trans (A)", 2D) = "white" {}
	_BumpMap ("Normalmap", 2D) = "bump" {}           
	}
 
    SubShader 
    { 
        Tags { "Queue" = "Geometry+10" "RenderType"="Opaque"}

		LOD 100

        CGPROGRAM

		sampler2D _MainTex;
		sampler2D _BumpMap;
		sampler2D _OcclusionTex;

		fixed4 _MainColor;
		fixed4 _Color;
		fixed4 _SubColorG;
		fixed4 _SubColorB;            

		#include "CustomLighting.inc"
		#pragma surface surf  HalfLambertNoAmbient    vertex:vert  noforwardadd noambient
            
		struct Input 
		{
			half2 uv_MainTex;
			half2 uv2_OcclusionTex;         
			half2 uv_BumpMap;    
		};
	
		void vert(inout appdata_full v, out Input o)
		{
			UNITY_INITIALIZE_OUTPUT(Input,o);
			o.uv_MainTex = v.texcoord.xy;
			o.uv2_OcclusionTex = v.texcoord1.xy;
			o.uv_BumpMap = v.texcoord2.xy;
		}

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
                		fixed4 ao = tex2D(_OcclusionTex, IN.uv2_OcclusionTex);

			o.Albedo = _Color * tex.r * (1 - tex.g) * (1 - tex.b) + _SubColorG * tex.g * (1 - tex.b) + _SubColorB * tex.b;             
			o.Albedo = o.Albedo * _MainColor  * ao.rgb; 
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = 1; 
        }
         
        ENDCG

    }
    
    Fallback "Bumped Diffuse"

}
