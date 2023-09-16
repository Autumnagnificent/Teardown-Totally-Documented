uniform mat4 uMvpMatrix;
uniform mat4 uModelMatrix;
uniform mat4 uOldModelMatrix;
uniform mat4 uStableVpMatrix;
uniform mat4 uOldStableVpMatrix;
uniform float uInvFar;

varying vec4 vColor;
varying vec3 vNormal;
varying vec4 vMaterial;
varying vec4 vCurrentPos;
varying vec4 vOldPos;
varying vec3 vPosition;
varying float vZ;

#ifdef VERTEX
attribute vec3 aPosition;
attribute vec3 aNormal;
attribute vec4 aMaterial;
attribute vec4 aColor;

void main(void)
{
	gl_Position = uMvpMatrix * vec4(aPosition, 1.0);
	vColor = aColor;
	vNormal = (uModelMatrix * vec4(aNormal, 0.0)).xyz;
	vMaterial = aMaterial;
	vPosition = (uModelMatrix * vec4(aPosition, 1.0)).xyz;

	vCurrentPos = uStableVpMatrix * uModelMatrix * vec4(aPosition, 1.0);
	vOldPos = uOldStableVpMatrix * uOldModelMatrix * vec4(aPosition, 1.0);
	vZ = gl_Position.w*uInvFar;
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
	vec2 tcCurrent = vCurrentPos.xy/vCurrentPos.w*0.5+vec2(0.5);
	vec2 tcOld = vOldPos.xy/vOldPos.w*0.5+vec2(0.5);

	outputColor = vColor;
	outputNormal = normalize(vNormal);
	outputMaterial = vMaterial;
	outputMotion = vec3(tcCurrent - tcOld, 0.0);
	outputDepth = vZ;
}
#endif

