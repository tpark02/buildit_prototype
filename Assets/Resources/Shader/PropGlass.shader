Shader "Custom/Prop - Glass" 
{
 	Properties 
	{
		_Color ("Main Color", Color) = (0.5,0.5,0.5,1)	
		_MainTex ("Base (RGB) Trans (A)", 2D) = "white" {}
		_Alpha ("Alpha", Range(0, 1)) = 1
		_Cutoff ("Alpha cutoff", Range (0,1)) = 0.1
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry-99" "RenderType"="Transparent" }
		
		LOD 300
		
		Cull Off
		ColorMask A
		ZWrite On
		ZTest Less 

		// Do nothing specific in the pass:
		Pass {


		}

	}

}