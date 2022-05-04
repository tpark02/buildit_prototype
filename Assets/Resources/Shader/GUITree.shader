Shader "Custom/GUI/Tree" 
{
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}	
		_Alpha ("Alpha", Range(0, 1)) = 1
 		_MainBendingPower ("Main Bending Power", float) = 0.2	
 		_TremblingPower ("Trembling Power", float) = 0.2
  }
 	
 	SubShader 
 	{
 	    Tags { "Queue"="Geometry-5" "DisableBatching"="True" }

        LOD 400
    
        CGPROGRAM
  
        #include "CustomLighting.inc"
        #pragma surface surf HalfLambertNoAmbient vertex:TreeVert noforwardadd noambient
      
      	fixed4 _Color;
      	sampler2D _MainTex;
      	float _Alpha;
		  
		float2 _WindSpeed;
	 
		float _TremblingAmplitude;
		float _TremblingFrequency;
		    
 		float _MainBendingPower;
		float _TremblingPower;

		struct Input {
			half2 uv_MainTex;		
	    };

        #include "Wind.inc"
        #include "Tree.inc"

  		void surf(Input IN, inout SurfaceOutput o) 
  	    {
  	        fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
  	        o.Albedo = c.rgb;
  	        o.Alpha = 1;
  	    }

		ENDCG

    }
 
	Fallback "Custom/Prop"
}
