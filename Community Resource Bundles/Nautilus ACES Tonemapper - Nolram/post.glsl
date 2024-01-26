#include "common.h"
#include "hlsl/postbuffer.h"

varying vec2 vTexCoord;

#ifdef VERTEX
DECLARE_VERTEX_ATTR(vec2, aPosition, POSITION, 0)
DECLARE_VERTEX_ATTR(vec2, aTexCoord, TEXCOORD, 0)

void main(void)
{
	gl_Position = vec4(aPosition, 0.0, 1.0);
	vTexCoord = aTexCoord;
}
#endif


#ifdef FRAGMENT

vec3 tonemapACES(in vec3 c)
{
    float a = 2.51f;
    float b = 0.03f;
    float y = 2.43f;
    float d = 0.59f;
    float e = 0.14f;

    return clamp((c * (a * c + b)) / (c * (y * c + d) + e), 0.0, 1.0);
}

void main(void) 
{
	float gammaCorrection = mubPostParams.r;
	float saturation = mubPostParams.g;
	float bloomScale = mubPostParams.b;

	vec3 bloom = texture(uBloom, vTexCoord).rgb;
	vec3 color = texture(uComposite, vTexCoord).rgb;
	
	color += bloom * bloomScale; 

	//Exposure
	float exposure = texture(uExposure, vec2(0.5)).r;
	exposure = clamp(exposure, 0.001, 100.0);
	color *= exposure;

	color = mix(vec3(color.r*0.3 + color.g*0.5 + color.b*0.2), color, saturation);
	color *= mubColorBalance.rgb;

	// //Tone mapping
	// color = vec3(1.0) - exp(-color);

	// ACES Tonemapping (new)
	color = tonemapACES(color);

	//Gamma correction
	float gamma = 2.2 * gammaCorrection;
	color = pow(color, vec3(1.0 / gamma));
	gl_FragColor = vec4(color, 1.0);
}

#endif
