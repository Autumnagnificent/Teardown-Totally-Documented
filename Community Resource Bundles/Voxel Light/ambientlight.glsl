#define SAMPLES 2
#define DIST 24.0

uniform sampler2D uNormal;
uniform vec4 uConstantColor;
uniform vec4 uAmbientColorAvg;
uniform float uAmbientExponent;

varying vec2 vTexCoord;
varying vec3 vFarVec;

float getDepth(vec2 texCoord)
{
	return texture(uDepth, texCoord).r;
}

vec3 getPixelPos(vec2 texCoord)
{
	return uCameraPos + vFarVec*(getDepth(texCoord)+0.00001);
}

vec3 getPixelNormal(vec2 texCoord)
{
	return texture(uNormal, texCoord).rgb;
}


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


float raycastAmbient(vec3 pos, vec3 normal, vec3 dir, float dist)
{


	//Jitter around normal hide voxel artefacts
	vec3 jitter = (blueNoise3() - vec3(0.0));
	jitter -= normal*dot(normal, jitter);
	jitter = normalize(jitter) * uVolTexelSize * 0.0 * blueNoise();
	pos += jitter;

	//Offset along direction here
	pos += dir * uVolTexelSize * 0.5;

	//Continue along normal until one voxel out
	pos += normal * uVolTexelSize * (1.6 * (1.0 - max(0.0, dot(dir, normal))));

	return raycastShadowVolume(pos, dir, dist);
}


vec3 sampleHemisphere(vec2 rand)
{
	float r = sqrt(1.0f - rand.x * rand.x);
	float phi = 6.28 * rand.y;
	return vec3(cos(phi) * r, sin(phi) * r, rand.x);
}

vec3 cosineSampleHemisphere(vec2 rand)
{
	float r = sqrt(rand.x);
	float theta = 6.28 * rand.y;
	float x = r * cos(theta);
	float y = r * sin(theta);
	return vec3(x, y, sqrt(max(0.0f, 1.0 - rand.x)));
}

void main(void)
{
	//Single sample per pixel experiment
	vec3 normal = getPixelNormal(vTexCoord);
	if (dot(normal, normal) == 0.0)
	{
		gl_FragColor = vec4(0.5);
		return;
	}

	vec3 pos = uCameraPos + vFarVec*getDepth(vTexCoord);
	blueNoiseInit(vTexCoord);
	gl_FragColor = vec4(0.0);

	vec3 t0 = abs(normal.z) > 0.5f ? vec3(0.0f, -normal.z, normal.y) : vec3(-normal.y, normal.x, 0.0f);
	t0 = normalize(t0 - dot(normal, t0));
	vec3 t1 = cross(normal, t0);

	for(int i=0; i<SAMPLES; i++)
	{
		vec3 dir = cosineSampleHemisphere(blueNoise2());
		dir = t0*dir.x + t1*dir.y + normal*dir.z;
		float incoming = dir.y * 0.2 + 0.8;
		float hitDist = raycastAmbient((floor(pos*10)/10)+0.05, normal, dir, DIST);
		float t = hitDist / DIST;
		t = pow(t, uAmbientExponent);

		gl_FragColor.rgb += uAmbientColorAvg.rgb * (incoming*t);

		//Ambient contribution, to avoid total darkness in crowded spaces
		gl_FragColor.rgb += uConstantColor.rgb * (incoming*max(1.0, hitDist / 4.0));
	}
	gl_FragColor.rgb /= float(SAMPLES);
}

#endif

