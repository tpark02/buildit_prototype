#ifndef WARPPED_DIFFUSE_LIGHTING_INCLUDED
#define WARPPED_DIFFUSE_LIGHTING_INCLUDED

	    inline fixed4 LightingWrappedDiffuse(SurfaceOutput s, fixed3 lightDir, fixed atten) 
        {
			fixed diff = saturate((dot(s.Normal,lightDir) + _WrapAmount) / ((1 + _WrapAmount) * ( 1 + _WrapAmount)));
            fixed4 c;

            c.rgb = (s.Albedo * _LightColor0.rgb * diff) * (atten * 2);
			c.a = s.Alpha;

            return c;
        }  

#endif
