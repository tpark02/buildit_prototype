#ifndef WIND
#define WIND

        float4 SmoothCurve( float4 x ) {  
		  return x * x *( 3.0 - 2.0 * x );  
		} 

		float4 TriangleWave( float4 x ) {  
		  return abs( frac( x + 0.5 ) * 2.0 - 1.0 );  
		}

		float4 SmoothTriangleWave( float4 x ) {  
			return SmoothCurve( TriangleWave( x ) );  
		}

        // This bends the entire plant in the direction of the wind.
		// vPos:		The world position of the plant *relative* to the base of the plant.
		//			(That means we assume the base is at (0, 0, 0). Ensure this before calling this function).
		// vWind:		The current direction and strength of the wind.
		// fBendScale:	How much this plant is affected by the wind.
		void ApplyMainBending(inout float3 vPos, float2 vWind, float fBendScale)
		{
			// Calculate the length from the ground, since we'll need it.
			float fLength = length(vPos);
			// Bend factor - Wind variation is done on the CPU.
			float fBF = vPos.y * fBendScale;
			// Smooth bending factor and increase its nearby height limit.
			fBF += 1.0;
			fBF *= fBF;
			fBF = fBF * fBF - fBF;
			// Displace position
			float3 vNewPos = vPos;
			vNewPos.xz +=   vWind.xy * fBF;
			// Rescale - this keeps the plant parts from "stretching" by shortening the y (height) while
			// they move about the xz.
			vPos.xyz = normalize(vNewPos.xyz)* fLength;
		}

		// The suggested frequencies from the Crytek paper
		// The side-to-side motion has a much higher frequency than the up-and-down.
		#define SIDE_TO_SIDE_FREQ1 1.975
		#define SIDE_TO_SIDE_FREQ2 0.793
		#define UP_AND_DOWN_FREQ1 0.375
		#define UP_AND_DOWN_FREQ2 0.193

		float2 ApplyMainBendingWithTrembling(inout float3 vPos, float2 vWind, float fBendScale, float3 objectWorldPos, float tremblingFrequency, float tremblingAmplitude)
		{
			float fObjPhase = dot(objectWorldPos.xyz, 0.5);  
   
   			float2 vWavesIn = _Time.xy + float2(fObjPhase,fObjPhase) + vPos.xx * 0.1;  
   			float4 vWaves = (frac(vWavesIn.xxyy *  
							   float4(SIDE_TO_SIDE_FREQ1, SIDE_TO_SIDE_FREQ2, UP_AND_DOWN_FREQ1, UP_AND_DOWN_FREQ2)) *  
							   2.0 - 1.0 );  	 
			vWaves = SmoothTriangleWave(vWaves * tremblingFrequency);  
			float2 vWavesSum = (vWaves.xz + vWaves.yw) * tremblingAmplitude;  

			// Calculate the length from the ground, since we'll need it.
			float fLength = length(vPos);
			// Bend factor - Wind variation is done on the CPU.
			float fBF = vPos.y * fBendScale;
			// Smooth bending factor and increase its nearby height limit.
			fBF += 1.0;
			fBF *= fBF;
			fBF = fBF * fBF - fBF;
			// Displace position
			float3 vNewPos = vPos;
			vNewPos.xz +=   vWind.xy * fBF;
			// Rescale - this keeps the plant parts from "stretching" by shortening the y (height) while
			// they move about the xz.
			vPos.xyz = normalize(vNewPos.xyz)* fLength + float3(vWavesSum.x, 0, vWavesSum.y) * vPos.y;
	

			return vWavesSum;
		}

#endif