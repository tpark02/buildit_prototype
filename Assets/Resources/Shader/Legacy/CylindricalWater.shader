// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

#warning Upgrade NOTE: unity_Scale shader variable was removed; replaced 'unity_Scale.w' with '1.0'

Shader "Legacy/CylindricalWater" { 
Properties {
	_WaveScale ("Wave scale", Range (0.02,0.15)) = 0.063
	_WaveHeight ("Wave height", Range(0, 1)) = 1
	_WaveFrequency ("Wave frequency", Range(0, 1000)) = 300
	_WaterNormal ("Water Normal", Range(0, 3.14)) = 0
	_ReflDistort ("Reflection distort", Range (0,1.5)) = 0.44
	_RefrColor ("Refraction color", COLOR)  = ( .34, .85, .92, 1)
	WaveSpeed ("Wave speed (map1 x,y; map2 x,y)", Vector) = (19,9,-16,-7)
	_Fresnel ("Fresnel (A) ", 2D) = "gray" {}
	_BumpMap ("Normalmap ", 2D) = "bump" {}
	_ReflectiveColor ("Reflective color (RGB) fresnel (A) ", 2D) = "" {}
	_ReflectiveColorCube ("Reflective color cube (RGB) fresnel (A)", Cube) = "" { TexGen CubeReflect }
	_MainTex ("Fallback texture", 2D) = "" {}
	_ReflectionTex ("Internal Reflection", 2D) = "" {}
}


// -----------------------------------------------------------
// Fragment program cards


Subshader { 
	Tags { "WaterMode"="Cylindrical" "RenderType"="Transparent" "Queue"="Background+2" }
	
	Pass {
	
			Blend SrcAlpha OneMinusSrcAlpha
			ZTest LEqual
			Cull Off
	
	
CGPROGRAM
#pragma vertex vert
#pragma fragment frag
#pragma fragmentoption ARB_precision_hint_fastest 
#pragma multi_compile WATER_CYLINDRICAL WATER_FLAT

#include "UnityCG.cginc"

uniform float _WaveHeight;
uniform float _WaveFrequency;
uniform float _WaterNormal;

uniform float4 _WaveScale4;
uniform float4 _WaveOffset;

uniform sampler2D _CameraDepthTexture;

uniform float _ReflDistort;

struct appdata {
	float4 vertex : POSITION;
	float3 normal : NORMAL;
};

struct v2f {
	float4 pos : SV_POSITION;
	float4 ref : TEXCOORD0;
	float2 bumpuv0 : TEXCOORD1;
	float2 bumpuv1 : TEXCOORD2;
	float3 viewDir : TEXCOORD3;
};

v2f vert(appdata v)
{	
	// scroll bump waves
	float4 temp;
	
	#if defined (WATER_CYLINDRICAL)
	float x = v.vertex.x;
	float y = v.vertex.y;
	float z = v.vertex.z;
	
	if (y == 0) 
	{
		y = 0.00001;
	}
	
	float t = atan(z/y);
	float tt = t;
	
	if (y < 0)
	{
		if (z >= 0)
		{
			t = t + 3.141592;
		}
		else
		{
			t = t - 3.141592;
		}
	}
	
	z = t*40;
			
	float4 xzxz = { x, z, x, z };	
	
	temp.xyzw = xzxz * _WaveScale4 / 1.0 + _WaveOffset;
	#else
	temp.xyzw = v.vertex.xzxz  * _WaveScale4 / 1.0 + _WaveOffset;
	#endif
	
	v.vertex.y = v.vertex.y + sin(temp.xyzw.x*temp.xyzw.y * _WaveFrequency) * _WaveHeight;	
	
	v2f o;
	o.pos = UnityObjectToClipPos (v.vertex);	
	
	o.bumpuv0 = temp.xy;
	o.bumpuv1 = temp.wz;
	
	// object space view direction (will normalize per pixel)
	o.viewDir.xzy = ObjSpaceViewDir(v.vertex);

	#if defined (WATER_CYLINDRICAL)
	
	_WaterNormal = 2.6;
	
	float3 viewPlane = {0, cos(_WaterNormal), sin(_WaterNormal) };			
	o.viewDir = viewPlane;
	
	#endif

	o.ref = ComputeScreenPos(o.pos);
	
	return o;
}

sampler2D _ReflectionTex;
sampler2D _ReflectiveColor;
uniform float4 _RefrColor;
sampler2D _BumpMap;

half4 frag( v2f i ) : COLOR
{
	i.viewDir = normalize(i.viewDir);
	
	// combine two scrolling bumpmaps into one
	half3 bump1 = UnpackNormal(tex2D( _BumpMap, i.bumpuv0 )).rgb;
	half3 bump2 = UnpackNormal(tex2D( _BumpMap, i.bumpuv1 )).rgb;
	half3 bump = (bump1 + bump2) * 0.5;
	
	// fresnel factor
	half fresnelFac = dot( i.viewDir, bump );
	
	// perturb reflection/refraction UVs by bumpmap, and lookup colors
	
	float4 uv1 = i.ref; uv1.xy += bump * _ReflDistort;
	half4 refl = tex2Dproj( _ReflectionTex, UNITY_PROJ_COORD(uv1) );	

	half edgeBlendFactors = 0;
	
	half depth = UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.ref)));
	depth = LinearEyeDepth(depth);	
	edgeBlendFactors = saturate((depth-i.ref.z)*0.5);		
	edgeBlendFactors = saturate(edgeBlendFactors* edgeBlendFactors);
	
	// final color is between refracted and reflected based on fresnel	
	half4 color;
	
	half4 water = tex2D( _ReflectiveColor, float2(fresnelFac,fresnelFac) );
	color.rgb = lerp(_RefrColor.rgb, refl.rgb, water.a );
	color.a = edgeBlendFactors;

	return color;
}
ENDCG

	}
}

// -----------------------------------------------------------
//  Old cards

// three texture, cubemaps
Subshader {
	Tags { "WaterMode"="Flat" "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture * primary
		}
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix2]
			combine texture * primary + previous
		}
		SetTexture [_ReflectiveColorCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// dual texture, cubemaps
Subshader {
	Tags { "WaterMode"="Flat" "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0.5)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture
		}
		SetTexture [_ReflectiveColorCube] {
			combine texture +- previous, primary
			Matrix [_Reflection]
		}
	}
}

// single texture
Subshader {
	Tags { "WaterMode"="Flat" "RenderType"="Opaque" }
	Pass {
		Color (0.5,0.5,0.5,0)
		SetTexture [_MainTex] {
			Matrix [_WaveMatrix]
			combine texture, primary
		}
	}
}


}
