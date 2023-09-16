uniform sampler2D uNew;
uniform sampler2D uOld;
uniform sampler2D uNormal;
uniform sampler2D uMotion;
uniform sampler2D uMaterial;
uniform vec2 uPixelSize;
uniform mat4 uVpInvMatrix;
uniform mat4 uVpMatrix;
uniform vec3 uCameraPos;
uniform float uInvFar;


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
vec3 computeFarVec(vec2 texCoord)
{
	vec4 aa = vec4(texCoord*2.0-vec2(1.0),1.0f,1.0f);
	aa = uVpInvMatrix * aa;
	return aa.xyz/aa.w-uCameraPos;
}

void main(void)
{
#if 1
	vec2 motion = texture(uMotion, vTexCoord).rg;
	vec3 normal = texture(uNormal, vTexCoord).rgb;
	vec4 material = texture(uMaterial, vTexCoord);

	if (length(normal) == 0.0)
		return;

	float roughness = 1.0-material.g;

	vec4 colNew = texture(uNew, vTexCoord);
	vec4 colOld = texture(uOld, vTexCoord - motion);
	colOld = min(colOld, vec4(1.0));

	float blendFactor = clamp(roughness, 0.0, 0.8);

	float refOld = colOld.a;
	float refNew = colNew.a;
	blendFactor *= clamp((1.0 - abs(refOld - refNew)*10.0), 0.0, 1.0);

	gl_FragColor = mix(colNew, colOld, blendFactor);
#else
	gl_FragColor = texture(uNew, vTexCoord);
	return;
#endif

}
#endif




