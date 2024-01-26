uniform sampler3D uVolTex;
uniform vec3 uVolOffset;
uniform vec3 uVolResolution;
uniform float uVolTexelSize;
uniform sampler2D uDepth;

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

void main(void)
{
	vec3 farVec = computeFarVec(vTexCoord);
	vec3 dir = normalize(farVec);
	float depth = texture(uDepth, vTexCoord).r * uFar;
	vec3 pos = (uCameraPos - uVolOffset) / uVolTexelSize;
	float stepSize = 0.25 / uVolTexelSize;
	vec3 step = dir *stepSize;
	float fog = 0.0;
	float d = 0.0;
	depth /= uVolTexelSize;
	for (int i = 0; i < 50; i++)
	{
		float f = texture(uVolTex, pos / uVolResolution).r;
		fog += f * 0.05;
		pos += step;
		d += stepSize;
		if (d > depth)
			break;
	}
	gl_FragColor = vec4(fog, fog*0.6, fog*0.3, 1.0);
}

#endif


