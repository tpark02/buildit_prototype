Shader "Custom/Tree - Transparent" 
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
        Tags { "Queue"="Transparent" "DisableBatching"="True" }

        LOD 400

        Blend SrcAlpha OneMinusSrcAlpha

        CGPROGRAM
  
        #include "CustomLighting.inc"
        #pragma surface surf HalfLambert vertex:TreeVert noforwardadd keepalpha
        #pragma multi_compile RIMLIGHT_ON RIMLIGHT_OFF
        #pragma multi_compile SELECTVFX_ON SELECTVFX_OFF
        
        fixed4 _Color;
        sampler2D _MainTex;
        float _Alpha;
          
        float2 _WindSpeed;
     
        float _TremblingAmplitude;
        float _TremblingFrequency;
            
        float _MainBendingPower;
        float _TremblingPower;

        #if RIMLIGHT_ON
        fixed4 _RimColor;
        float _RimPower;
        #endif

        struct Input {
            half2 uv_MainTex;
            #if RIMLIGHT_ON
            fixed3 viewDir;
            #endif
        };

        #include "Wind.inc"
        #include "Tree.inc"

        void surf(Input IN, inout SurfaceOutput o) 
        {
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a * _Alpha;

            #if RIMLIGHT_ON
            fixed rim = 1.2 - saturate(dot(normalize(IN.viewDir), o.Normal));
            float rimPower = _RimPower;
            #if SELECTVFX_ON
            rimPower = 1 + (sin(_Time.r*100) + 1) * 0.3;
            #endif
            o.Emission = _RimColor.rgb * pow(rim, rimPower);
            #endif
        }

        ENDCG

    }
 
    Fallback "Custom/Prop"
}
