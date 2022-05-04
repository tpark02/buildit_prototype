Shader "Custom/Window Frame - Selected" {
Properties {
	_Color ("Main Color", Color) = (0.5,0.5,0.5,1)
	_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
	_Alpha ("Alpha", Range(0, 1)) = 1
	_RimColor ("Rim Color", Color) = (1, 1, 1, 1)
}

SubShader 
{
	Tags { "Queue"="Geometry-93"  "DisableBatching"="True" }
	LOD 200
	
	Blend SrcAlpha OneMinusSrcAlpha
	
	CGPROGRAM

	#include "CustomLighting.inc"
	#pragma surface surf HalfLambert noforwardadd noambient
	
    sampler2D _MainTex;
    float4 _Color;
    float _Alpha;
    float4 _RimColor;
    
    struct Input {
        float2 uv_MainTex;
        float3 viewDir;
    };

    void surf(Input IN, inout SurfaceOutput o) 
    {
    	fixed4 c = tex2D(_MainTex, IN.uv_MainTex);		
    
    	float weight = (sin(_Time.r*100) + 1) * 0.3;
     
        o.Albedo = c.rgb; // * (1 - weight) + Y * weight ;	 
        o.Alpha = c.a * _Color.a * _Alpha;
   
        half rim = 1.2 - saturate(dot(normalize(IN.viewDir), o.Normal));
	
        o.Emission = _RimColor.rgb * pow (rim, 1 + weight);       
    }

	ENDCG
}

Fallback off
}
