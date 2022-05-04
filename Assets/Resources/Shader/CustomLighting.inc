#ifndef CUSTOM_LIGHTING_INCLUDED
#define CUSTOM_LIGHTING_INCLUDED

        inline fixed4 LightingEmpty(SurfaceOutput s, fixed3 lightDir, fixed atten) 
        {
            return fixed4(0,0,0,0);
       	}

        inline fixed4 LightingUnlit(SurfaceOutput s, fixed3 lightDir, fixed atten) 
        {
			fixed4 c;
            c.rgb = s.Albedo;              
			c.a = s.Alpha;
            return c;
       	}

	    inline fixed4 LightingHalfLambert(SurfaceOutput s, fixed3 lightDir, fixed atten) 
	    {
	        fixed NdotL = dot(s.Normal, lightDir);
	        fixed diff = NdotL * 0.5 + 0.5;
			fixed4 c;
	        c.rgb = s.Albedo * _LightColor0.rgb * diff * (atten * 2);
	        c.a = s.Alpha;
	        return c;
	    }


	    inline fixed4 LightingHalfLambertBothSide(SurfaceOutput s, fixed3 lightDir, fixed atten) 
	    {
	        fixed NdotL = dot(s.Normal, lightDir);
	        fixed diff = abs(NdotL) * 0.5 + 0.5;
			fixed4 c;
	        c.rgb = s.Albedo * _LightColor0.rgb * diff * (atten * 2);
	        c.a = s.Alpha;
	        return c;
	    }

	    inline fixed4 LightingHalfLambertNoAmbient(SurfaceOutput s, fixed3 lightDir, fixed atten) 
	    {
	        fixed NdotL = dot(s.Normal, lightDir);
	        fixed diff = NdotL * 0.5 + 0.5;
			fixed4 c;
	        c.rgb = s.Albedo * _LightColor0.rgb * diff * (atten * 2) + s.Albedo * 0.9;
	        c.a = s.Alpha;
	        return c;
	    }

		// NOTE: some intricacy in shader compiler on some GLES2.0 platforms (iOS) needs 'viewDir' & 'h'
		// to be mediump instead of lowp, otherwise specular highlight becomes too bright.
		inline fixed4 LightingSkin(SurfaceOutput s, fixed3 lightDir, half3 viewDir, fixed atten)
		{
			half3 h = normalize(lightDir + viewDir);
			
		    fixed NdotL = dot(s.Normal, lightDir);
	        fixed diff = NdotL * 0.5 + 0.5;
			
			float nh = max (0, dot (s.Normal, h));
			float spec = pow (nh, s.Specular) * s.Gloss;
			
			fixed4 c;
			c.rgb = (s.Albedo * _LightColor0.rgb * diff + _LightColor0.rgb * _SpecColor.rgb * spec) * (atten * 2);
			c.a = s.Alpha + _LightColor0.a * _SpecColor.a * spec * atten;
			return c;
		}

	    inline fixed4 LightingCustomLambertNoShade(SurfaceOutput s, fixed3 lightDir, fixed atten) 
	    {
	        fixed4 c;
	        c.rgb = s.Albedo * _LightColor0.rgb * (atten * 2);
	        c.a = s.Alpha;
	        return c; 
	    }

		inline float3 LightingHalfLambertVS(float3 normal, float3 lightDir)
		{
			fixed diff = dot(normal, lightDir) * 0.5 + 0.5;
			
			return _LightColor0.rgb * (diff * 2);
		}
           
#endif
