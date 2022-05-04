#ifndef CUSTOM_LAMBERT_LIGHTING_INCLUDED
#define CUSTOM_LAMBERT_LIGHTING_INCLUDED

	    inline fixed4 LightingCustomLambert(SurfaceOutput s, fixed3 lightDir, fixed atten) 
	    {
	        fixed NdotL = dot(s.Normal, lightDir);
	        fixed diff = NdotL * _LambertMultiply + _LambertAdd;
			fixed4 c;
	        c.rgb = s.Albedo * _LightColor0.rgb * diff * (atten * 2);
	        c.a = s.Alpha;
	        return c; 
	    }

#endif

