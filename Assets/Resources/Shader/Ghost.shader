Shader "Custom/Ghost" 
{
    Properties {
        _Color ("Main Color", Color) = (1,1,1,1)
   		_RimColor ("Rim Color", Color) = (0.5, 0.5, 0.5, 0.0)
   		_RimPower ("Rim Power", Range(0.5, 8.0)) = 3.0	
   		_GhostAmount ("Ghost Amount", Range (0.0, 2.0)) = 0.5
    }

    SubShader {
        Tags { "RenderType" = "Transparent" "Queue" = "Transparent"}

		LOD 100

		Cull Off

		Pass {
			ColorMask 0
		}
 
		Blend SrcAlpha OneMinusSrcAlpha 
		
        CGPROGRAM

            fixed4 _Color;
            fixed4 _RimColor;
            fixed _RimPower;
            fixed _GhostAmount;

			#include "CustomLighting.inc"
			#pragma surface surf HalfLambert noforwardadd keepalpha
			
            struct Input 
            {				
				half3 viewDir;
            };
 
            void surf (Input IN, inout SurfaceOutput o) 
            {
			    o.Albedo = _Color.rgb;
                
				half rim = 1.0 - saturate(dot(normalize(IN.viewDir), o.Normal ));
				
				o.Emission = _RimColor.rgb * pow (rim, _RimPower);
				o.Alpha = (1.0 - saturate(_GhostAmount) + rim * _GhostAmount) * (1 + saturate(_GhostAmount) - _GhostAmount);
            }

        ENDCG

    }
}
