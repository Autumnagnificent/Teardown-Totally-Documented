#define METHOD 0

uniform sampler2D uNew;
uniform sampler2D uOld;
uniform sampler2D uNormal;
uniform sampler2D uDepth;
uniform sampler2D uOldDepth;
uniform sampler2D uMotion;
uniform vec2 uRandom;

varying vec2 vTexCoord;

#ifdef VERTEX
attribute vec2 aPosition;
attribute vec2 aTexCoord;

void main(void)
{
	gl_Position = vec4(aPosition, 0.0, 1.0);
	vTexCoord = aTexCoord;
}
#endif


#ifdef FRAGMENT

#if METHOD == 0

void main(void)
{
	gl_FragColor = texture(uNew, vTexCoord);
}

#endif

#if METHOD == 1

void main(void)
{
	float depth = texture(uDepth, vTexCoord).r;
	if (depth > 0.9)
		return;

	vec2 motion = texture(uMotion, vTexCoord).rg;
	vec3 normal = texture(uNormal, vTexCoord).rgb;

	vec3 pixRay = computeFarVec(vTexCoord);
	float d = texture(uDepth, vTexCoord).r;
	vec3 position = pixRay*d;
	vec4 plane = vec4(normal, -dot(position, normal));
	vec3 precalc = -plane.w*vec3(uVpMatrix[0][3], uVpMatrix[1][3], uVpMatrix[2][3])*uInvFar;

	vec4 new = texture(uNew, vTexCoord);
	vec4 org = new;
	vec4 mi = new;
	vec4 ma = new;
	
	blueNoiseInit(vTexCoord);
	float tot = 1.0;
	const float goldenAngle = 2.39996323;
	const float size = 4.0;
	const float radInc = 1.0;
	float radius =  1.0;
	for (float ang = blueNoise()*goldenAngle; radius < size; ang += goldenAngle)
	{
		radius += radInc;
		vec2 tc = vTexCoord + vec2(cos(ang), sin(ang))*uPixelSize*(radius);

		//Ramp function based on radius
		float t = 1.2 - radius / size;

		//Compute the planar depth (what we expect the depth to be)
		vec4 aa = uVpInvMatrix * vec4(tc*2.0 - vec2(1.0), 1.0f, 1.0f);
		vec3 ray = aa.xyz / aa.w - uCameraPos;
		vec3 hitPoint = ray / dot(ray, plane.xyz);
		float hitDepth = dot(precalc, hitPoint);

		//Check depth
		float d = texture(uDepth, tc).r;
		t *= step(abs(d - hitDepth), 8.0 / 65535.0);

		//Also check normal
		vec3 n = texture(uNormal, tc).rgb;
		t *= step(0.9, dot(normal, n));

		vec4 col = texture(uNew, tc);
		vec4 mc = mix(org, col, t);
		mi = min(mi, mc);
		ma = max(ma, mc);

		new += t*col;
		tot += t;
	}
	new /= tot;
	
	vec4 colOld = texture(uOld, vTexCoord - motion);
	colOld = clamp(colOld, mi, ma);
	gl_FragColor = mix(new, colOld, 0.5);
}

#elif METHOD == 2

void main(void)
{
	vec4 new = texture(uNew, vTexCoord);
	vec2 motion = texture(uMotion, vTexCoord).rg;
	vec4 colOld = texture(uOld, vTexCoord - motion);
	gl_FragColor = mix(new, colOld, 0.5);
}
#endif


#endif


