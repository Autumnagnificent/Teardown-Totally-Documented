uniform sampler2D uColor;
uniform sampler2D uOld;
uniform sampler2D uDepth;
uniform sampler2D uMotion;

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
#if 1
	blueNoiseInit(vTexCoord);
	float depth = texture(uDepth, vTexCoord).r;
	const float goldenAngle = 2.39996323;
	const float size = 0.0;
	float radInc = 0.0;
	float radius = 0.0;
	vec4 fog = texture(uColor, vTexCoord);
	float threshold = depth*0.1;
	float c = 1.0;
	for (float ang = 6.28*blueNoise(); radius < size; ang += goldenAngle)
	{
		radius += radInc;
		vec2 tc = vTexCoord + vec2(cos(ang), sin(ang))*uPixelSize*(radius);
		float d = texture(uDepth, tc).r;
		float t = smoothstep(threshold, 0.0, abs(d - depth));
		fog += texture(uColor, tc)*t;
		c += t;
	}

	vec2 motion = texture(uMotion, vTexCoord).rg;
	vec4 old = texture(uOld, vTexCoord-motion);
	vec4 new = fog / c;
	gl_FragColor = mix(old, new, 0.5);
#else
	gl_FragColor = texture(uColor, vTexCoord);
#endif
}


#endif


