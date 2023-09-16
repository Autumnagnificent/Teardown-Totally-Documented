uniform usampler3D uVolTex;
uniform vec3 uVolResolution;
uniform float uVolTexelSize;
uniform vec3 uVolOffset;
uniform sampler2D uDepth;


bool blockedInScreenspace(vec3 start, vec3 dir)
{
	vec3 mid = start + dir*(uVolTexelSize*0.5*blueNoise());
	float thickness = uVolTexelSize*uInvFar;
	vec4 p = uVpMatrix * vec4(mid, 1.0);
	vec2 tc = (p.xy / p.w)*0.5 + vec2(0.5);
	float pDepth = p.w*uInvFar*0.99;
	float depth = texture(uDepth, tc).r;
	if (pDepth > depth && pDepth < depth + thickness)
		return true;
	return false;
}


float raycastShadowVolume(vec3 origin, vec3 dir, float dist)
{
	origin -= uVolOffset;
	vec3 invDir = vec3(1.0) / (abs(dir) + vec3(0.00001));

	vec3 invRes = vec3(1.0) / uVolResolution;
	vec3 halfInvRes = invRes*0.5;

	vec3 tSign = sign(dir);
	vec3 zSign = step(vec3(0.0), tSign);

	int mip = -1;

	float t = 0.0;
	while (t < dist)
	{
		if (mip == -1)
		{
			float texelSize = uVolTexelSize * 0.5;
			vec3 invResolution = invRes * 0.5;
			vec3 tDelta = invDir * texelSize;
			vec3 tPos = (origin + t*dir) / texelSize;
			vec3 ti = floor(tPos);
			vec3 tMax = (invDir * (zSign + tSign*(ti - tPos))) * texelSize + vec3(t);
			ti = (ti + vec3(0.5)) * invResolution;
			vec3 tStep = tSign * invResolution;
			int c = 0;
			while (t < dist && c++ < 8)
			{
				uint a = textureLod(uVolTex, ti, 0.0).x;
				if (a != 0u)
				{
					uint bit = 0u;
					bit += mod(ti.x, invRes.x) > halfInvRes.x ? 1u : 0u;
					bit += mod(ti.y, invRes.y) > halfInvRes.y ? 2u : 0u;
					bit += mod(ti.z, invRes.z) > halfInvRes.z ? 4u : 0u;
					uint mask = 1u << bit;
					if ((mask & a) != 0u)
					{
						return t;
					}
				}
				vec3 cmp = step(tMax.xyz, tMax.zxy) * step(tMax.xyz, tMax.yzx);
				t = dot(tMax, cmp);
				tMax += tDelta * cmp;
				ti += tStep * cmp;
			}
			mip = 0;
		}
		else
		{
			float mipScale = float(1 << mip);
			float texelSize = uVolTexelSize * mipScale;
			vec3 invResolution = invRes * mipScale;
			vec3 tDelta = invDir * texelSize;
			vec3 tPos = (origin + t*dir) / texelSize;
			vec3 ti = floor(tPos);
			vec3 tMax = (invDir * (zSign + tSign*(ti - tPos))) * texelSize + vec3(t);
			ti = (ti + vec3(0.5)) * invResolution;
			vec3 tStep = tSign * invResolution;

			int c = (mip < 2 ? 8 : 1024);
			while (t < dist)
			{
				if (c-- == 0)
				{
					mip++;
					break;
				}
				uint a = textureLod(uVolTex, ti, mip).x;
				if (a != 0u)
				{
					mip--;
					break;
				}
				vec3 cmp = step(tMax.xyz, tMax.zxy) * step(tMax.xyz, tMax.yzx);
				t = dot(tMax, cmp);
				tMax += tDelta * cmp;
				ti += tStep * cmp;
			}
		}
	}
	return dist;
}


float raycastShadowVolumeSparse(vec3 origin, vec3 dir, float dist)
{
	origin -= uVolOffset;
	float step = uVolTexelSize;
	vec3 invRes = vec3(1.0) / uVolResolution;
	vec3 halfInvRes = invRes*0.5;
	vec3 stepDir = dir * (step / uVolTexelSize) * invRes;
	vec3 pos = (origin / uVolTexelSize) * invRes;

	stepDir *= 0.5;
	step *= 0.5;
	int lod = -1;

	float d = 0.0;
	while (d < dist)
	{
		uint c = textureLod(uVolTex, pos, lod).x;
		if (lod == -1)
		{
			if (c != 0u)
			{
				uint bit = 0u;
				bit += mod(pos.x, invRes.x) > halfInvRes.x ? 1u : 0u;
				bit += mod(pos.y, invRes.y) > halfInvRes.y ? 2u : 0u;
				bit += mod(pos.z, invRes.z) > halfInvRes.z ? 4u : 0u;
				uint mask = 1u << bit;
				if ((mask & c) != 0u)
					return d;
				else
				{
					pos += stepDir;
					d += step;
				}
			}
			else
			{
				lod++;
				stepDir *= 2.0;
				step *= 2.0;
				pos += stepDir;
				d += step;
			}
		}
		else
		{
			if (c != 0u)
			{
				stepDir *= 0.5;
				step *= 0.5;
				lod--;
				pos -= stepDir;
				d -= step;
			}
			else
			{
				if (lod < 2)
				{
					c = textureLod(uVolTex, pos, lod + 1).x;
					if (c == 0u)
					{
						lod++;
						stepDir *= 2.0;
						step *= 2.0;
					}
				}
				pos += stepDir;
				d += step;
			}
		}
	}
	return dist;
}


float raycastShadowVolumeSuperSparse(vec3 origin, vec3 dir, float dist)
{
	origin -= uVolOffset;
	float step = uVolTexelSize;
	vec3 invRes = vec3(1.0) / uVolResolution;
	vec3 halfInvRes = invRes*0.5;
	vec3 stepDir = dir * (step / uVolTexelSize) * invRes;
	vec3 pos = (origin / uVolTexelSize) * invRes;
	float baseDistance = 0.5;
	float d = 0.0;

	//Start in half res and bitmask
	stepDir *= 0.5;
	step *= 0.5;
	while (d < baseDistance)
	{
		uint c = textureLod(uVolTex, pos, 0).x;
		uint bit = 0u;
		bit += mod(pos.x, invRes.x) > halfInvRes.x ? 1u : 0u;
		bit += mod(pos.y, invRes.y) > halfInvRes.y ? 2u : 0u;
		bit += mod(pos.z, invRes.z) > halfInvRes.z ? 4u : 0u;
		uint mask = 1u << bit;
		if ((mask & c) != 0u)
			return d;

		pos += stepDir;
		d += step;
	}

	//Move up to base level
	stepDir *= 2.0;
	step *= 2.0;
	while (d < baseDistance*2.0)
	{
		if (textureLod(uVolTex, pos, 0).x != 0u)
			return d;
		pos += stepDir;
		d += step;
	}

	//First mip
	stepDir *= 2.0;
	step *= 2.0;
	while (d < baseDistance*4.0)
	{
		if (textureLod(uVolTex, pos, 1).x != 0u)
			return d;
		pos += stepDir;
		d += step;
	}

	//Second mip
	stepDir *= 2.0;
	step *= 2.0;
	while (d < dist)
	{
		if (textureLod(uVolTex, pos, 2).x != 0u)
			return d;
		pos += stepDir;
		d += step;
	}

	return dist;
}

