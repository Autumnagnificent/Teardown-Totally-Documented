uniform mat4 uMvpMatrix;
uniform mat4 uModelMatrix;
uniform mat4 uOldModelMatrix;
uniform mat4 uStableVpMatrix;
uniform mat4 uOldStableVpMatrix;
uniform sampler2D uTexture;
uniform vec2 uRandom;
uniform float uEmissive;
uniform float uRaster;
uniform float uChromatic;
uniform float uNoise;
uniform vec2 uTexelSize;
uniform float uScale;
uniform float uAlpha;

varying vec2 vTexCoord;
varying vec4 vCurrentPos;
varying vec4 vOldPos;
varying vec3 vNormal;
varying float vZ;

#ifdef VERTEX
attribute vec3 aPosition;
attribute vec3 aNormal;
attribute vec2 aTexCoord;

void main(void)
{
	gl_Position = uMvpMatrix * vec4(aPosition, 1.0);
	vec4 vp = uModelMatrix * vec4(aPosition, 1.0);
	vec4 vpOld = uOldModelMatrix* vec4(aPosition, 1.0);
	vec4 vn = uModelMatrix * vec4(aNormal, 0.0);
	vCurrentPos = uStableVpMatrix * vp;
	vOldPos = uOldStableVpMatrix * vpOld;
	vZ = gl_Position.w*uInvFar;
	vNormal = normalize(vn.xyz);
	vTexCoord = aTexCoord;
}
#endif


#ifdef FRAGMENT
layout(location=0) out vec4 outputColor;
layout(location=1) out vec3 outputNormal;
layout(location=2) out vec4 outputMaterial;
layout(location=3) out vec3 outputMotion;
layout(location=4) out float outputDepth;

void main(void)
{
	vec2 tcCurrent = vCurrentPos.xy / vCurrentPos.w*0.5 + vec2(0.5);
	vec2 tcOld = vOldPos.xy / vOldPos.w*0.5 + vec2(0.5);

	if (uScale > 0.0)
	{
		blueNoiseInit(gl_FragCoord.xy);
		vec2 tc = vTexCoord;

		//Scale for turning on/off
		tc.x = ((tc.x*2.0 - 1.0) / pow(uScale, 2.0))*0.5 + 0.5;
		tc.y = ((tc.y*2.0 - 1.0) / pow(uScale, 6.0))*0.5 + 0.5;

		vec4 color;

		if (uChromatic > 0.0)
		{
			color.r = texture(uTexture, tc + vec2(uChromatic*uTexelSize.x, 0.0)).r;
			color.g = texture(uTexture, tc + vec2(0.0, 0.0)).g;
			color.b = texture(uTexture, tc + vec2(-uChromatic*uTexelSize.x, 0.0)).b;
			color.a = 1.0;
		}
		else
			color = texture(uTexture, tc);

		//Crt
		float rasterWidth = 4.0;
		float dy = dFdy(tc.y);
		float ry = ((blueNoise() - 0.5) * dy) / uTexelSize.y / rasterWidth;
		color += sin(ry*6.28)*uRaster;

		color.rgb += (rnd(tc + uRandom) - 0.5) * uNoise;

		//Gamma correction
		color.rgb = pow(color.rgb, vec3(2.2));

		if (tc.x < 0.0 || tc.x > 1.0 || tc.y < 0.0 || tc.y > 1.0)
			color = vec4(0.0);

		outputColor = color*uAlpha;
	}
	else
		outputColor = vec4(0.0);

	outputMaterial = vec4(0.05, 0.5, 0.0, uEmissive);
	outputNormal = vNormal;
	outputMotion = vec3(tcCurrent - tcOld, 1.0);
	outputDepth = vZ;
}
#endif
