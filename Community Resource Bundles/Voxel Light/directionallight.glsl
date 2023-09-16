uniform sampler2D uNormal;

uniform vec3 uLightColor;
uniform vec3 uLightDir;
uniform float uLightSpread;
uniform float uLightLength;

varying vec2 vTexCoord;
varying vec3 vFarVec;

float getDepth(vec2 texCoord)
{
	return texture(uDepth, texCoord).r;
}

vec3 getPixelPos(vec2 texCoord)
{
	return uCameraPos + vFarVec*getDepth(texCoord);
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

float raycastDirectional(vec3 pos, vec3 normal, vec3 dir, float dist)
{


	vec3 jitter = (blueNoise3() - vec3(0.5));
	jitter -= normal*dot(normal, jitter);
	jitter = normalize(jitter) * uVolTexelSize * 0.5 * blueNoise();
	pos += jitter;

	pos += dir * uVolTexelSize*0.5;
	//Continue along normal until one voxel out
	pos += normal * uVolTexelSize * (0.6 * (1.0 - max(0.0, dot(dir, normal))));

	return raycastShadowVolume(pos, dir, dist);
}

void main(void)
{
	blueNoiseInit(vTexCoord);

	vec3 pos = uCameraPos + vFarVec*(getDepth(vTexCoord)+0.00001);
	vec3 normal = getPixelNormal(vTexCoord);

	if (dot(normal, normal) == 0.0)
	{
		gl_FragColor = vec4(0.0);
		return;
	}
	
	gl_FragColor = vec4(0.0, 0.0, 0.0, 0.0);
	{
		vec3 col = uLightColor;
		vec3 rnd = blueNoise3()*2.0 - vec3(1.0);
		vec3 dir = normalize(uLightDir+rnd*uLightSpread);

		float dist = uLightLength;
		float incoming = dot(dir, normal);
		if (incoming > 0.0)
		{
			float hitDist = raycastDirectional((floor(pos*10)/10)+0.05, normal, dir, dist);
			float t = smoothstep(0.8, 1.0, hitDist/dist);	//Fade out shadow towards the end
			gl_FragColor.rgb += uLightColor * (t*incoming);
			gl_FragColor.a = 1.0;
		}
	}
}

#endif

