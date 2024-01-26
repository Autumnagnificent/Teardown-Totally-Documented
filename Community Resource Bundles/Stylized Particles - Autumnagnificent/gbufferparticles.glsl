#include "raytracing.h"
#include "hlsl/gbufferparticlesresources.h"

varying vec4 vCurrentPos;
varying vec4 vOldPos;
varying vec4 vColor;
varying vec3 vNormal;
varying vec3 vToCamera;
varying vec2 vTexCoord;
varying float vEmissive;
varying float vDepth;
varying float vIndex;
varying float vRadius;

#ifdef VERTEX
DECLARE_VERTEX_ATTR(vec3, aPosition, POSITION, 0)
DECLARE_VERTEX_ATTR(vec3, aPositionOld, POSITION, 1)
DECLARE_VERTEX_ATTR(vec3, aNormal, NORMAL, 0)
DECLARE_VERTEX_ATTR(vec2, aTexCoord, TEXCOORD, 0)
DECLARE_VERTEX_ATTR(vec4, aColor,COLOR, 0)
DECLARE_VERTEX_ATTR(float, aEmissive, TEXCOORD, 1)
DECLARE_VERTEX_ATTR(float, aIndex, TEXCOORD, 2)
DECLARE_VERTEX_ATTR(float, aRadius, TEXCOORD, 3)

void main(void)
{
	blueNoiseInit(aPosition.xy);

	gl_Position = mubVpMatrix * vec4(aPosition, 1.0);
	vTexCoord = aTexCoord;
	vColor = aColor;
	vEmissive = aEmissive;
	vDepth = gl_Position.w;
	vNormal = aNormal;
	vIndex = aIndex;
	vRadius = aRadius;
	vToCamera = mubCameraPos.xyz - aPosition.xyz;

	vCurrentPos = mubStableVpMatrix * vec4(aPosition, 1.0);
	vOldPos = mubOldStableVpMatrix * vec4(aPositionOld, 1.0);
}
#endif


#ifdef FRAGMENT

layout(location=0) out vec4 outputColor;
layout(location=1) out vec4 outputNormal;
layout(location=2) out vec4 outputMaterial;
layout(location=3) out vec2 outputMotion;

void main(void)
{
	float far = mubNearFar.g;
	vec2 pixelSize = mubPixelSize.rg;

	float depth = vDepth;
	vec2 tc = gl_FragCoord.xy * pixelSize;
	tc += alpha2*vIndex;
	blueNoiseInit(tc);

	vec4 color = texture(uTexture, vTexCoord);
	color = vec4(1.0, 1.0, 1.0, color.r);
	color *= vColor;

	color.rgb = convertSrgbToLinearFast(color.rgb);
	
	//Fade out close to geometry
	float screenDepth = getLinear16BitDepth(gl_FragCoord.xy * pixelSize) * far;
	float diff = screenDepth - depth;
	color.a *= smoothstep(0.0, vRadius, diff);

	//Fade out smoke very close to camera
	// color.a *= smoothstep(0.4, 2.0, depth);

	bool visible = 0.1 < color.a - 0.001;
	if (!visible)
		discard;

	vec3 normal = normalize(vNormal);

	//Flip normal for every other pixel to light from back of sphere
	vec3 toCamera = normalize(vToCamera);
	if (mod(gl_FragCoord.x + gl_FragCoord.y, 2.0) == 0.0)
		normal = normal - toCamera*(dot(toCamera, normal)*2.0);

	outputColor = vec4(color.rgb, vEmissive / EMISSIVE_SCALE_RANGE);
	outputNormal = vec4(normal, flagToSNorm(kIsParticles));
	outputMaterial = vec4(0.0, 0.0, 0.0, 0.0);
	outputMotion = (vCurrentPos.xy / vCurrentPos.w - vOldPos.xy / vOldPos.w) * 0.5;
}
#endif

