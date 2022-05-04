#ifndef TREE
#define TREE

void TreeVert(inout appdata_full v) 
{
  float3 vPos = v.vertex;
  float3 baseWorldPos = mul(unity_ObjectToWorld, float4(0,0,0,1)).xyz;
   
  ApplyMainBendingWithTrembling(vPos, normalize(_WindSpeed), length(_WindSpeed) * _MainBendingPower, baseWorldPos, 
				_TremblingFrequency, _TremblingAmplitude * _TremblingPower);
            
  v.vertex = float4(vPos.xyz, 1);
}

#endif