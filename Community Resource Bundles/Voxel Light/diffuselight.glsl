uniform mat4 uMvpMatrix;

uniform sampler2D uNormal;

uniform int uLightType;
uniform mat4 uLightTransform;
uniform mat4 uLightData;

uniform sampler2D uScreen;

varying vec4 vHPos;


#ifdef VERTEX
attribute vec3 aPosition;

void main(void)
{
	vHPos = uMvpMatrix * vec4(aPosition, 1.0);
	gl_Position = vHPos;
}
#endif


#ifdef FRAGMENT


float raycast(vec3 pos, vec3 normal, vec3 dir, float dist)
{
	

	vec3 jitter = (blueNoise3() - vec3(0.5));
	jitter -= normal*dot(normal, jitter);
	jitter = normalize(jitter) * uVolTexelSize * 1.0 * blueNoise();
	pos += jitter;

	pos += dir * uVolTexelSize*0.5;
	//Continue along normal until one voxel out
	pos += normal * uVolTexelSize * (0.9 * (1.0 - max(0.0, dot(dir, normal))));
	return raycastShadowVolume(pos, dir, dist);
}


float getAttenuation(vec3 lightPos, vec3 worldPos, float dist, float range, float lightRadius)
{
	float win = (dist / range);
	win = win*win*win*win;
	win = max(0.0, 1.0 - win);
	win = win*win;
	float attenuation = win / (dist*dist + 0.1);

	attenuation = max(attenuation, 0.0);
	if (uLightType < 3)
	{
		//Sphere and capsule
		return attenuation;
	}
	else if (uLightType == 3)
	{
		//Cone
		vec3 coneDir = uLightTransform[2].xyz;
		float coss = dot(coneDir, (worldPos - lightPos) / dist);
		float cosu = uLightData[3].x; // cos(umbraAngle)
		float cosp = uLightData[3].y; // cos(penumbraAngle)
		float t = (coss - cosu) / (cosp - cosu);
		t = clamp(t, 0.0, 1.0);
		return smoothstep(0.0, 1.0, t)*attenuation;
	}
	else
	{
		//Area
		vec3 areaDir = uLightTransform[2].xyz;
		vec3 lightDir = (worldPos - lightPos) / dist;
		float contribution = clamp(dot(areaDir, lightDir), 0.0, 1.0);
		return attenuation * contribution;
	}
}


void main(void)
{
	gl_FragColor = vec4(0.0);

	vec2 texCoord = vHPos.xy / vHPos.w * 0.5 + vec2(0.5);
	float depth = texture(uDepth, texCoord).r + 0.00001;
	if (depth == 1.0)
		return;

	blueNoiseInit(texCoord);

	vec3 farVec = computeFarVec(texCoord);
	vec3 pos = uCameraPos + farVec*depth;

	float lightRadius = uLightData[1].x;
	float lightRange = uLightData[1].y;
	vec3 lightPos = uLightTransform[3].xyz;
	vec3 lightColor = uLightData[0].rgb;

	//Jitter light pos
	vec3 offset = vec3(0.0);
	if (uLightType == 2)
	{
		//Capsule
		float halfLength = uLightData[1].z;
		offset += uLightTransform[2].xyz * halfLength * (blueNoise()*2.0 - 1.0);
		offset += (blueNoise3()*2.0 - vec3(1.0))*lightRadius;
	}
	else if (uLightType == 4)
	{
		//Area
		vec2 r2 = (blueNoise2()*2.0 - vec2(1.0));
		vec2 area = uLightData[3].zw;
		offset += uLightTransform[0].xyz * area.x * r2.x;
		offset += uLightTransform[1].xyz * area.y * r2.y;
	}
	else if (uLightType == 5)
	{
		//Screen
		vec2 b2 = blueNoise2();
		vec2 r2 = (b2*2.0 - vec2(1.0));
		vec2 area = uLightData[3].zw;
		offset += uLightTransform[0].xyz * area.x * r2.x;
		offset += uLightTransform[1].xyz * area.y * r2.y;
		lightColor *= texture2D(uScreen, b2).rgb;
	}
	else
		offset = (blueNoise3()*2.0 - vec3(1.0))*lightRadius;
	lightPos += offset;

	vec3 toLight = ((floor(lightPos*10)/10)+0.05) - ((floor(pos*10)/10)+0.05);
	float distToLight2 = dot(toLight, toLight);

	//Quickly discard everything that is out of range
	if (distToLight2 < 0.01 || distToLight2 > lightRange*lightRange)
		return;

	float distToLight = sqrt(distToLight2);
	vec3 dirToLight = toLight / distToLight;

	float attenuation = getAttenuation(lightPos, floor(pos*10)/10+0.05,distToLight, lightRange, lightRadius);
	if (attenuation == 0.0)
		return;

	vec3 normal = texture(uNormal, texCoord).xyz;
	float incoming = dot(dirToLight, normal);
	float contrib = incoming*attenuation;

	float contribLight = contrib * (lightColor.r + lightColor.g + lightColor.b);
	float lowerLimit = 0.02;
	float upperLimit = 0.04;
	if (contribLight <= upperLimit)
	{
		if (contribLight <= lowerLimit || (contribLight - lowerLimit) / (upperLimit - lowerLimit) < blueNoise())
			return;
	}

	float lightUnshadowedDist = max(uLightData[2].x, uLightData[1].x*2.0);
	float rayLength = distToLight - lightUnshadowedDist;
	float hitDist = raycast((floor((pos)*10)/10)+0.05, normal, dirToLight, rayLength);
	if (hitDist < rayLength)
		return;
	
	gl_FragColor = vec4(lightColor * contrib, 1.0);
}

#endif

