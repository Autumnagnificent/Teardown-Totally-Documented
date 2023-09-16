uniform mat4 uMvpMatrix;
uniform mat4 uModelMatrix;

uniform vec3 uLightColor;
uniform vec3 uLightDir;
uniform float uFogScale;
uniform float uLightLength;

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


float raycast(vec3 pos, vec3 dir, float dist)
{
	return raycastShadowVolumeSparse(pos, dir, dist);
}


float henyeyGreenstein(float g, float cosAngle)
{
	return  (1.0 - g*g) / (4 * 3.14159*pow(1.0 + g*g - 2 * g*cosAngle, 1.5));
}


void main(void) 
{
	blueNoiseInit(vTexCoord);

	float depth = texture(uDepth, vTexCoord).r;
	vec3 pixelDir = normalize(vFarVec);

	gl_FragColor = vec4(0.0, 0.0, 0.0, 1.0);

	float stepCount = 1.0;
	float scale = 0.005 * uFogScale;

	//Skip if light does not intersect pixel ray
	float minDist = 0.0;
	float maxDist = length(vFarVec*depth);

	float segmentLength = (maxDist - minDist) / stepCount;
	vec3 step = pixelDir * segmentLength;

	//Jitter start pos
	vec3 pos = uCameraPos + pixelDir * minDist + step*blueNoise();

	float fogSegment = scale * min(segmentLength, 8.0 / stepCount);

	float cosAngle = dot(uLightDir, pixelDir);
	vec3 scatter;
	scatter.r = henyeyGreenstein(0.7, cosAngle);
	scatter.g = henyeyGreenstein(0.8, cosAngle);
	scatter.b = henyeyGreenstein(0.9, cosAngle);
	scatter *= 0.5;
	scatter += vec3(0.5);
	scatter = clamp(scatter, vec3(0.0), vec3(10.0));

	float hit = 0.0;
	float limit = 0.01 / stepCount;

	for (float j = 0.5; j < stepCount; j += 1.0)
	{
		if (raycast(pos, uLightDir, uLightLength) == uLightLength)
			gl_FragColor.rgb += uLightColor * fogSegment * scatter;
		pos += step;
	}
}



#endif
