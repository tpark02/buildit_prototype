Shader "Custom/GUI/Prop - (2Tex, 3CH) Illum" 
{
	Properties 
	{	
	    _Color ("Main Color", Color) = (1,1,1,1)
	    _MainTex ("Base (RGB)", 2D) = "white" { }	
	    _MaskTex ("Mask (A)", 2D) = "white" { }
	    _IllumColor1 ("IllumColor #1", Color) = (0,0,0,0)	
	    _IllumColor2 ("IllumColor #2", Color) = (0,0,0,0)
	    _IllumColor3 ("IllumColor #3", Color) = (0,0,0,0)
	    _Intensity1 ("Intensity #1", float) = 1 		
	    _Intensity2 ("Intensity #2", float) = 1 	    	
	    _Intensity3 ("Intensity #3", float) = 1 
	}
	
	SubShader 
	{
		Tags { "Queue"="Geometry-1" }
		
		LOD 200    	
	
		CGPROGRAM
	
		sampler2D _MainTex;
		sampler2D _MaskTex;
		fixed4 _Color;

		fixed4 _IllumColor1;
		fixed4 _IllumColor2;
		fixed4 _IllumColor3;
		
		fixed _Intensity1;
		fixed _Intensity2;
		fixed _Intensity3;
		
		fixed _Alpha;
		fixed _LampLuminance;

        #include "CustomLighting.inc"
        #pragma surface surf HalfLambertNoAmbient noforwardadd noambient
		
		struct Input {
			half2 uv_MainTex;
		};
		
		void surf(Input IN, inout SurfaceOutput o) 
		{
			fixed3 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
			fixed3 lamp = tex2D(_MaskTex, IN.uv_MainTex);
			o.Albedo = c.rgb; 

			fixed ch1 = _Intensity1 * lamp.r;
			fixed ch2 = _Intensity2 * lamp.g;
			fixed ch3 = _Intensity3 * lamp.b;

			fixed3 color1 = lerp(c.rgb, _IllumColor1.rgb, min(dot(fixed3(5,5,5), _IllumColor1.rgb), 1));
			fixed3 color2 = lerp(c.rgb, _IllumColor2.rgb, min(dot(fixed3(5,5,5), _IllumColor2.rgb), 1));
			fixed3 color3 = lerp(c.rgb, _IllumColor3.rgb, min(dot(fixed3(5,5,5), _IllumColor3.rgb), 1));
			
 			o.Emission = ((color1 * ch1 + color2 * ch2 + color3 * ch3))  * (_LampLuminance + 0.5);
		}
		
		ENDCG
	}
		
	Fallback "VertexLit"

}