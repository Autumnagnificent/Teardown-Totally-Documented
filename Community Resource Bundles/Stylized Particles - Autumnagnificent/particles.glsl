uniform mat4 uMvpMatrix;
uniform mat4 uStableVpMatrix;
uniform mat4 uOldStableVpMatrix;
uniform sampler2D uTexture;

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
varying float vLife;

#ifdef VERTEX
attribute vec3 aPosition;
attribute vec3 aPositionOld;
attribute vec4 aColor;
attribute vec3 aNormal;
attribute vec2 aTexCoord;
attribute float aEmissive;
attribute float aIndex;
attribute float aRadius;
attribute float aLife;

void main(void)
{
	blueNoiseInit(aPosition.xy);

	gl_Position = uMvpMatrix * vec4(aPosition, 1.0);
	vTexCoord = aTexCoord;
	vColor = aColor;
	vEmissive = aEmissive;
	vDepth = gl_Position.w;
	vNormal = aNormal;
	vIndex = aIndex;
	vRadius = aRadius;
	vLife = aLife;
	vToCamera = uCameraPos - aPosition.xyz;

	vCurrentPos = uStableVpMatrix * vec4(aPosition, 1.0);
	vOldPos = uOldStableVpMatrix * vec4(aPositionOld, 1.0);
}
#endif


#ifdef FRAGMENT

layout(location=0) out vec4 outputColor;
layout(location=1) out vec3 outputNormal;
layout(location=2) out vec4 outputMaterial;
layout(location=3) out vec2 outputMotion;
layout(location=4) out float outputDepth;

void main(void)
{
	float depth = vDepth;
	vec2 tc = gl_FragCoord.xy * uPixelSize;
	tc += alpha2*vIndex;
	blueNoiseInit(tc);

	vec4 color = texture(uTexture, vTexCoord);
	color = vec4(1.0, 1.0, 1.0, color.r);
	color *= vColor;

	color.rgb = pow(color.rgb, vec3(2.2));		// vColor and texcolor should be handled sparately!
	
	//Fade out close to geometry
	float screenDepth = texture(uDepth, gl_FragCoord.xy*uPixelSize).r * uFar;
	float diff = screenDepth - depth;
	color.a *= smoothstep(0.0, vRadius, diff);

	// //Fade out smoke very close to camera
	// color.a *= smoothstep(0.4, 2.0, depth);

	bool visible = 0.1 < color.a - 0.001;
	if (!visible)
		discard;

	vec3 normal = normalize(vNormal);

	//Flip normal for every other pixel to light from back of sphere
	vec3 toCamera = normalize(vToCamera);
	if (mod(gl_FragCoord.x + gl_FragCoord.y, 2.0) == 0.0)
		normal = normal - toCamera*(dot(toCamera, normal)*2.0);

	outputColor = vec4(color.rgb, 0.0);
	outputNormal = normal;
	outputMaterial = vec4(0.0, 0.0, 0.0, vEmissive);
	outputMotion = (vCurrentPos.xy / vCurrentPos.w - vOldPos.xy / vOldPos.w) * 0.5;
	outputDepth = depth / uFar;
}
#endif

