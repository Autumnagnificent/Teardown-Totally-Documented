uniform sampler2D uComposite;
uniform sampler2D uBloom;
uniform sampler2D uDepth;
uniform sampler2D uExposure;
uniform float uGammaCorrection;
uniform vec4 uColorBalance;
uniform float uSaturation;
uniform float uBloomScale;

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
	vec3 bloom = texture(uBloom, vTexCoord).rgb;
	vec3 color = texture(uComposite, vTexCoord).rgb;
	
	color += bloom * uBloomScale; 

	// Exposure
	float exposure = texture(uExposure, vec2(0.5)).r;
	exposure = clamp(exposure, 0.001, 100.0);
	color *= exposure;

	color = mix(vec3(color.r*0.3 + color.g*0.5 + color.b*0.2), color, uSaturation);
	color *= uColorBalance.rgb;

	// Tone mapping (built-in)
	//color = vec3(1.0) - exp(-color);

	// ACES Tonemapping (new)
	color = tonemapACES(color);

	//Gamma correction
	float gamma = 2.2 * uGammaCorrection;
	color = pow(color, vec3(1.0 / gamma));
	gl_FragColor = vec4(color, 1.0);
}
#endif
