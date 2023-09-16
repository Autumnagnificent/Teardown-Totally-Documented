#define FAST 0

uniform sampler2D uNormal;
uniform sampler2D uMaterial;
uniform sampler2D uDiffuse;
uniform mat3 uCubeMapRot;
uniform samplerCube uCubeMap;
uniform vec4 uCubeMapColor;
uniform float uAmbientScale;

varying vec2 vTexCoord;
varying vec3 vFarVec;

#ifdef VERTEX
attribute vec2 aPosition;
attribute vec2 aTexCoord;

void main(void)
{
	gl_Position = vec4(aPosition, 0.0, 1.0);
	vTexCoord = aTexCoord;
	vFarVec = computeFarVec(aTexCoord);
}
#endif


#ifdef FRAGMENT

float raycast(vec3 pos, vec3 normal, vec3 dir, float dist)
{
	if (blockedInScreenspace(pos, dir))
		return uVolTexelSize*0.5;

	pos += normal * uVolTexelSize*0.5;
	//pos += dir * blueNoise() * uVolTexelSize*0.5;		// This will get rid of some jagged edges in reflections when using sparse
#if FAST
	return raycastShadowVolumeSuperSparse(pos, dir, dist);
#else
	return raycastShadowVolumeSparse(pos, dir, dist);
#endif
}


void main(void)
{
	blueNoiseInit(vTexCoord);

	vec2 tc = vTexCoord;

	vec3 normal = texture(uNormal, tc).rgb;
	if (dot(normal, normal) == 0.0)
	{
		gl_FragColor = vec4(0.0);
		return;
	}

	vec3 pos = uCameraPos + vFarVec*texture(uDepth, tc).r;
	vec4 material = texture(uMaterial, tc);

	vec3 toPix = vFarVec;
	vec3 refDir = normalize(toPix - normal*(2.0*dot(normal, toPix)));

	float roughness = 1.0 - material.g;
	float deviation = 0.1*roughness;

	//Do we even have to compute reflection?
	float reflectivity = material.r;
	float t = abs(dot(normalize(toPix), normal));
	t = exp2(-8.656170 * t); //  1/ln(2) * 6 from  https://seblagarde.wordpress.com/2011/08/17/hello-world/
	float roughFresnel = (0.1 + 0.9*material.g); // Rough surfaces should have less fresnel effect, kind of
	reflectivity += t*(1.0 - reflectivity)*roughFresnel;
	reflectivity -= 0.01;
	if (reflectivity <= 0.0)
	{
		gl_FragColor = vec4(0.0);
		return;
	}

	vec3 rndDir = blueNoise3()*2.0-vec3(1.0);
	vec3 dir = normalize(refDir + rndDir*deviation);

	float maxDist = 32.0;
	float d = raycast(pos, normal, dir, maxDist);

	vec4 env;
	env.rgb = textureLod(uCubeMap, uCubeMapRot*refDir, 5.0*roughness).rgb * uCubeMapColor.rgb;
	env = applyDistanceFog(env, refDir, 1.0);
	env.a = reflectivity;

	if (d < maxDist)
	{
		vec3 hitPos = pos + dir*d;
		vec4 hp = uVpMatrix * vec4(hitPos, 1.0);
		vec2 xy = hp.xy / hp.w * 0.5 + vec2(0.5);
		float rDepth = hp.w * uInvFar;
		vec2 a2 = clamp(hp.xy/hp.w, vec2(-1.0), vec2(1.0));
		a2 = abs(a2);
		float a = (1.0 - a2.x)*(1.0 - a2.y);
		float dDiff = (texture(uDepth, xy).r - rDepth);
		float thickness = 2.0*uVolTexelSize*uInvFar;
		a *= smoothstep(thickness, 0.0, abs(dDiff));
		gl_FragColor.rgb  = texture(uDiffuse, xy).rgb * a;
		
		float envT = d / maxDist;
		envT *= envT;
		envT *= envT;
		gl_FragColor = mix(gl_FragColor, env, envT);
		gl_FragColor.a = reflectivity;
	}
	else
	{
		gl_FragColor = env;
	}
}

#endif
