// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced '_World2Object' with 'unity_WorldToObject'

Shader "Custom/Character Hair" {

    Properties 
    {
	    _Color ("Main Color (R)", Color) = (1,1,1,1)
   		_SubColorG("Sub Color (G)", Color) = (1,1,1,1)
   		_SubColorB("Sub Color (B)", Color) = (1,1,1,1)
        _MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}           
   		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)	
   		_RimPower ("Rim Power", float) = 3.0
   		_HairTremblingBoost ("Hair Trembling Boost", float) = 1	
	}
 
    SubShader 
    {
        Tags { "Queue" = "Geometry+10" "RenderType"="Opaque"}

		LOD 100

        CGPROGRAM

		sampler2D _MainTex;
		sampler2D _BumpMap;

		fixed4 _Color;
		fixed4 _SubColorG;
		fixed4 _SubColorB;            
		fixed4 _RimColor;
		fixed _RimPower;
        float _HairTremblingBoost;

		uniform float2 _WindSpeed;
	
		uniform float _TremblingAmplitude;
		uniform float _TremblingFrequency;

		#include "CustomLighting.inc"
		#pragma surface surf HalfLambert vertex:vert noforwardadd
            
		struct Input 
		{
			half2 uv_MainTex;
			half2 uv_BumpMap;                
			fixed3 viewDir;
		};
	

        float4 SmoothCurve( float4 x ) {  
		  return x * x *( 3.0 - 2.0 * x );  
		} 

		float4 TriangleWave( float4 x ) {  
		  return abs( frac( x + 0.5 ) * 2.0 - 1.0 );  
		}

		float4 SmoothTriangleWave( float4 x ) {  
			return SmoothCurve( TriangleWave( x ) );  
		}

		// The suggested frequencies from the Crytek paper
		// The side-to-side motion has a much higher frequency than the up-and-down.
		#define SIDE_TO_SIDE_FREQ1 1.975
		#define SIDE_TO_SIDE_FREQ2 0.793
		#define UP_AND_DOWN_FREQ1 0.375
		#define UP_AND_DOWN_FREQ2 0.193

		float2 ApplyCharactreHair(inout float3 vPos, float3 vColor, float3 vWind, float windSpeed, float tremblingFrequency, float tremblingAmplitude)
		{
			float2 vWavesIn = _Time.xy;  
   			float4 vWaves = (frac(vWavesIn.xxyy *  
							   float4(SIDE_TO_SIDE_FREQ1, SIDE_TO_SIDE_FREQ2, UP_AND_DOWN_FREQ1, UP_AND_DOWN_FREQ2)) *  
							   2.0 - 1 );  	 
			vWaves = SmoothTriangleWave(vWaves * tremblingFrequency * _HairTremblingBoost);  
			float2 vWavesSum = (vWaves.xz + vWaves.yw) * tremblingAmplitude;  

			float3 varyPos = (vWind.xyz * windSpeed + float3(0, 0, vWavesSum.x - 0.1)) * (1 - vColor.r);
			
			vPos.xyz = vPos.xyz + varyPos;
			
			return vWavesSum;
		}

        void vert(inout appdata_full v) 
        {
        	// x -> y (+ = down), y -> forward, z -> left)
        	float4 worldPosition = mul(unity_ObjectToWorld, float4(v.vertex.xyz, 1));
			float3 vPos = v.vertex;

			float4 objectWind = mul(unity_WorldToObject, float4(_WindSpeed.x, 0, _WindSpeed.y, 0));

			ApplyCharactreHair(vPos, v.color, objectWind.xyz, length(_WindSpeed), _TremblingFrequency, _TremblingAmplitude);

			v.vertex = float4(vPos.xyz, 1);
        }

		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
                
			o.Albedo = _Color * tex.r * (1 - tex.g) * (1 - tex.b) + _SubColorG * tex.g * (1 - tex.b) + _SubColorB * tex.b;             
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			o.Alpha = 1;
                
			fixed rim = 1.0 - saturate(dot(IN.viewDir, o.Normal));
				
			o.Emission = _RimColor.rgb * pow(rim, _RimPower);
        }
         
        ENDCG

    }
    
    Fallback "Bumped Diffuse"

}
