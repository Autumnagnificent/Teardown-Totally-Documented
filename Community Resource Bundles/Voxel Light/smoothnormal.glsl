uniform sampler2D uNormal;
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
	vec3 n = texture(uNormal, vTexCoord).xyz;
#if 1
	float depth = texture(uDepth, vTexCoord).r;
	const float maxSmoothRadius = 0.0; // pixels
	const float maxSmoothDist = 0.0; // meters
	float size = maxSmoothRadius * clamp(1.0 - depth*uFar/maxSmoothDist, 0.0, 1.0);
	if (size > 0.0)
	{
		const float goldenAngle = 2.39996323;
		float radius = 0.5;
		float radInc = 0.3;
		for (float ang = 0.0; radius < size; ang += goldenAngle)
		{
			vec2 tc = vTexCoord + vec2(cos(ang), sin(ang))*uPixelSize*(radius);
			float d = texture(uDepth, tc).r;
			if (abs(d - depth) < 0.0001)
			{
				float t = 1.0 - radius / size;
				n += texture(uNormal, tc).xyz * t;
			}
			radius += radInc;
		}
		float l = length(n) + 0.0001; 
		n /= l;
	}
#endif
	gl_FragColor = vec4(n, 1.0);
}

#endif


