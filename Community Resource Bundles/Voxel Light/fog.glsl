uniform mat4 uMvpMatrix;
uniform mat4 uModelMatrix;

uniform int uLightType;
uniform mat4 uLightTransform;
uniform mat4 uLightTransformInv;
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


vec3 raySphereIntersect(vec3 origin, vec3 dir, vec3 center, float radius)
{
	float radius2 = radius*radius;
	vec3 l = center - origin;
	float tca = dot(l, dir);
	float d2 = dot(l, l) - tca * tca;
	if (d2 >= radius2)
		return vec3(0.0);
	float thc = sqrt(radius2 - d2);
	return vec3(tca - thc, tca + thc, 1.0);
}


vec3 rayHalfSphereIntersect(vec3 origin, vec3 dir, vec3 center, float radius, vec3 planeNormal)
{
	float radius2 = radius*radius;
	vec3 l = center - origin;
	float tca = dot(l, dir);
	float d2 = dot(l, l) - tca * tca;
	if (d2 >= radius2)
		return vec3(0.0);
	float thc = sqrt(radius2 - d2);
	float enter = tca - thc;
	float leave = tca + thc;

	//Plane intersect
	float pt = dot(planeNormal, l) / dot(planeNormal, dir);

	if (dot(planeNormal, dir*enter - l) < 0.0)
	{
		vec3 tmp = l - dir*pt;
		if (dot(tmp, tmp) < radius2)
			enter = pt;
		else
			return vec3(0.0);
	}
	if (dot(planeNormal, dir*leave - l) < 0.0)
	{
		vec3 tmp = l - dir*pt;
		if (dot(tmp, tmp) < radius2)
			leave = pt;
		else
			return vec3(0.0);
	}

	return vec3(enter, leave, 1.0);
}


vec3 rayBoxIntersect(vec3 origin, vec3 rayDir, vec3 size)
{
	vec3 tMin = (-size - origin) / rayDir;
	vec3 tMax = (size - origin) / rayDir;
	vec3 t1 = min(tMin, tMax);
	vec3 t2 = max(tMin, tMax);
	vec3 ret;
	ret.x = max(max(t1.x, t1.y), t1.z);
	ret.y = min(min(t2.x, t2.y), t2.z);
	ret.z = ret.x < ret.y ? 1.0 : 0.0;
	return ret;
}


bool SolveSquare(float A, float B, float C, out vec2 x) {
	float D = B*B - 4.0 * A * C;
	if (D < 0.0) return false;
	x.x = (-B - sqrt(D)) / (2.0 * A);
	x.y = (-B + sqrt(D)) / (2.0 * A);
	return true;
}


bool ConeIntersect(float ConeR, float height, vec3 ro, vec3 rd, out vec2 t) {
	float cr = ConeR*height;
	float sphRadius = sqrt(height*height + cr*cr);
	vec3 stt = raySphereIntersect(ro, rd, vec3(0, 0, 0), sphRadius);
	if (stt.z == 0.0)
		return false;

	float Al = ConeR * rd.z;
	float Bl = ConeR * ro.z;

	float A = dot(rd.xy, rd.xy) - Al*Al;
	float B = 2.0*(dot(rd.xy, ro.xy) - Al*Bl);
	float C = dot(ro.xy, ro.xy) - Bl*Bl;

	vec2 tt;
	if (!SolveSquare(A, B, C, tt))
		return false;

	//Project result onto cone axis, for comparisons
	vec2 zz = ro.zz + rd.zz*tt;

	//Total miss
	if (zz.x < 0.0 && (zz.y < 0.0 || zz.y > height))
		return false;
	if (zz.y < 0.0 && (zz.x < 0.0 || zz.x > height))
		return false;

	if (zz.x > height && zz.y > height)
	{
		if (stt.x > tt.x && stt.y < tt.y)
		{
			t = stt.xy;
			return true;
		}
		return false;
	}

	if (zz.x < 0.0)
	{
		//Ray hits cone from sphere front and exits through cone
		t.x = stt.x;
		t.y = tt.y;
	}
	else if (zz.y < 0.0)
	{
		//Ray hits cone from below and exits through sphere
		t.x = tt.x;
		t.y = stt.y;
	}
	else
	{
		//Ray hits cone from side
		t.x = max(stt.x, tt.x);
		t.y = min(stt.y, tt.y);
	}
	return true;
}


vec3 rayConeIntersect(vec3 rayOrigin, vec3 rayDir, float radius, float cosAngle)
{
	float height = cosAngle * radius;
	float r = (sin(acos(cosAngle)) * radius) / height;
	vec2 mima;
	if (ConeIntersect(r, radius, rayOrigin, rayDir, mima.xy))
		return vec3(mima, 1.0);
	return vec3(0.0);
}


float raycast(vec3 pos, vec3 dir, float dist)
{
	return raycastShadowVolumeSparse(pos, dir, dist);
}


float getDistanceAttenuation(float dist, float range)
{
	float win = (dist / range);
	win = win*win*win*win;
	win = max(0.0, 1.0 - win);
	win = win*win;
	float attenuation = win / (dist*dist + 0.1);
	return max(attenuation, 0.0);
}


vec3 getClosestPointOnCapsule(vec3 worldPos)
{
	float halfLength = uLightData[1].z;
	float z = clamp((uLightTransformInv*vec4(worldPos, 1.0)).z, -halfLength, halfLength);
	return uLightTransform[3].xyz + uLightTransform[2].xyz * z;
}


vec3 getClosestPointOnAreaLight(vec3 worldPos)
{
	vec2 xy = clamp((uLightTransformInv*vec4(worldPos, 1.0)).xy, -uLightData[3].zw, uLightData[3].zw);
	return uLightTransform[3].xyz + uLightTransform[0].xyz * xy.x + uLightTransform[1].xyz * xy.y;
}


vec3 getClosestPointOnAreaLight(vec3 worldPos, out vec2 uv)
{
	vec2 xy = clamp((uLightTransformInv*vec4(worldPos, 1.0)).xy, -uLightData[3].zw, uLightData[3].zw);
	uv = (xy / uLightData[3].zw) * 0.5 + vec2(0.5);
	return uLightTransform[3].xyz + uLightTransform[0].xyz * xy.x + uLightTransform[1].xyz * xy.y;
}


float getAttenuation(vec3 lightPos, vec3 worldPos, float dist, float range)
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
		float coss = dot(coneDir, floor(((worldPos - lightPos) / dist)*10)/10+0.05);
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
		vec3 lightDir = floor(((worldPos - lightPos) / dist)*10)/10+0.05;
		float contribution = clamp(dot(areaDir, lightDir), 0.0, 1.0);
		return attenuation * contribution;
	}
}


void main(void) 
{
	vec2 texCoord = (gl_FragCoord.xy+vec2(0.25))*uPixelSize;

	blueNoiseInit(texCoord);

#if 0
	float zeroOrOne = mod(gl_FragCoord.x + gl_FragCoord.y, 2.0);
	texCoord.x += 0.5*zeroOrOne*uPixelSize.x;
#endif

	float depth = texture(uDepth, texCoord).r;
	vec3 farVec = computeFarVec(texCoord);
	vec3 pixelDir = normalize(farVec);

	gl_FragColor = vec4(0.0);

	float stepCount = uLightData[2].y;
	float scale = 0.001 * uLightData[2].z;

	vec3 lightPos = uLightTransform[3].xyz;
	float lightRadius = uLightData[1].x;
	float lightRange = uLightData[1].y;
	vec3 lightColor = uLightData[0].rgb;
	float lightUnshadowedDist = max(uLightData[2].x, lightRadius*2.0);

	//Ray/colume intersection points
	vec3 miMa;
	if (uLightType == 1)
	{
		lightPos += (blueNoise3()*2.0 - vec3(1.0)) * lightRadius * 0.5; // Only move half of radius to reduce noise
		miMa = raySphereIntersect(uCameraPos, pixelDir, lightPos, lightRange);
	}
	else if (uLightType == 2)
	{
		float halfLength = uLightData[1].z;
		vec3 localOrigin = (uLightTransformInv*vec4(uCameraPos, 1.0)).xyz;
		vec3 localDir = (uLightTransformInv*vec4(pixelDir, 0.0)).xyz;
		miMa = rayBoxIntersect(localOrigin, localDir, vec3(lightRange, lightRange, halfLength + lightRange));
	}
	else if (uLightType == 3)
	{
		//Cone
		vec3 localOrigin = (uLightTransformInv*vec4(uCameraPos, 1.0)).xyz;
		vec3 localDir = (uLightTransformInv*vec4(pixelDir, 0.0)).xyz;
		float cosConeAngle = uLightData[3].x;
		miMa = rayConeIntersect(localOrigin, localDir, lightRange, cosConeAngle);
	}
	else
	{
		//Area and screen
		vec3 planeNormal = uLightTransform[2].xyz;
		miMa = rayHalfSphereIntersect(uCameraPos, pixelDir, lightPos, lightRange, planeNormal);
	}

	//Ray misses light geometry
	if (miMa.z < 1.0)
		return;

	//Skip if light does not intersect pixel ray
	float minDist = max(miMa.x, 0.0);
	float maxDist = min(miMa.y, length(farVec*depth));

	//Discard if there is something in front
	if (maxDist < minDist)
		return;

	float segmentLength = (maxDist - minDist) / stepCount;
	vec3 step = pixelDir * segmentLength;

	//Jitter start pos
	vec3 pos = uCameraPos + pixelDir * minDist + step*blueNoise();

	float fogSegment = scale * segmentLength;
	float hit = 0.0;
	float lightColorMagnitude = length(lightColor);
	float limit = 0.001 / stepCount;
	for (float j = 0.5; j < stepCount; j += 1.0)
	{
		vec3 targetLightPos = lightPos;
		//TODO: Maybe use closest point on capsule?
		if (uLightType == 2)
			targetLightPos = getClosestPointOnCapsule(floor(pos*10)/10+0.05);
		else if (uLightType == 4)
			targetLightPos = getClosestPointOnAreaLight(floor(pos*10)/10+0.05);
		else if (uLightType == 5)
		{
			vec2 uv;
			targetLightPos = getClosestPointOnAreaLight(floor(pos*10)/10+0.05, uv);
			lightColor = texture2D(uScreen, uv).rgb;
		}

		vec3 dir = targetLightPos - floor(pos*10)/10+0.05;
		float dist = length(dir);
		dir /= dist;

		vec3 rayStart = targetLightPos - dir*lightUnshadowedDist;
		vec3 rayDir = -dir;
		float rayLength = dist -lightUnshadowedDist;

		float attenuation = getAttenuation(targetLightPos, floor(pos*10)/10+0.05, dist, lightRange);
		//Early out if very small contribution (big performance win)
		if (fogSegment * attenuation * lightColorMagnitude > limit)
		{
			if (raycast(rayStart, rayDir, rayLength) == rayLength)
			{
				gl_FragColor.rgb += lightColor * (fogSegment * attenuation);
				gl_FragColor.a = 1.0;
			}
		}
		pos += step;
	}
}



#endif
