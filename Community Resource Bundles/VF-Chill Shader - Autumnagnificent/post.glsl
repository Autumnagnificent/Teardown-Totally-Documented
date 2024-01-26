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

// float compare(vec3 a, vec3 b) {
// 	// Increase saturation
// 	// a = max(vec3(0.0), a - min(a.r, min(a.g, a.b)) * 0.25);
// 	// b = max(vec3(0.0), b - min(b.r, min(b.g, b.b)) * 0.25);
// 	a*=a*a;
// 	b*=b*b;
// 	vec3 diff = (a - b);
// 	return dot(diff, diff);
// }

vec3 XYZToLab(vec3 xyzColor) {
    const vec3 D65 = vec3(0.95047, 1.00000, 1.08883);
    const float epsilon = 0.008856;
    const float kappa = 903.3;

    vec3 white = D65 / D65.y;

    vec3 labColor;
    vec3 xyzNormalized = xyzColor / white;

    float fx = xyzNormalized.x > epsilon ? pow(xyzNormalized.x, 1.0 / 3.0) : (kappa * xyzNormalized.x + 16.0) / 116.0;
    float fy = xyzNormalized.y > epsilon ? pow(xyzNormalized.y, 1.0 / 3.0) : (kappa * xyzNormalized.y + 16.0) / 116.0;
    float fz = xyzNormalized.z > epsilon ? pow(xyzNormalized.z, 1.0 / 3.0) : (kappa * xyzNormalized.z + 16.0) / 116.0;

    labColor.x = 116.0 * fy - 16.0;
    labColor.y = 500.0 * (fx - fy);
    labColor.z = 200.0 * (fy - fz);

    return labColor;
}

vec3 linearRGBToXYZ(vec3 linearRGB) {
    mat3 rgbToXYZ = mat3(0.4124564, 0.3575761, 0.1804375,
                        0.2126729, 0.7151522, 0.0721750,
                        0.0193339, 0.1191920, 0.9503041);
    vec3 xyzColor = rgbToXYZ * linearRGB;
    
    return xyzColor;
}

vec3 rgbToLab(vec3 color) {
    // Convert color to linear RGB
    vec3 linearRGB = pow(color, vec3(2.2));

    // Convert linear RGB to XYZ
    vec3 xyzColor = linearRGBToXYZ(linearRGB);

    // Convert XYZ to CIELAB
    vec3 labColor = XYZToLab(xyzColor);

    return labColor;
}

float compare(vec3 color1, vec3 color2) {
    // Convert color1 to CIELAB
    vec3 lab1 = rgbToLab(color1);

    // Convert color2 to CIELAB
    vec3 lab2 = rgbToLab(color2);

    // Calculate the perceptual color difference using CIELAB values
    float diff = distance(lab1, lab2);

    return diff;
}

const int PALETTE_SIZE = 30;  // Number of colors in the palette

// VF_Chill
uniform vec3 palette[PALETTE_SIZE] = vec3[](
    vec3(0.28627450980392, 0.25490196078431, 0.38039215686275),
    vec3(0.41960784313725, 0.39607843137255, 0.58823529411765),
    vec3(0.6, 0.33725490196078, 0.42352941176471),
    vec3(0.78039215686275, 0.53333333333333, 0.56470588235294),
    vec3(0.41960784313725, 0.38039215686275, 0.46666666666667),
    vec3(0.49803921568627, 0.46274509803922, 0.55686274509804),
    vec3(0.3843137254902, 0.76078431372549, 0.76078431372549),
    vec3(0.4156862745098, 0.90980392156863, 0.63529411764706),
    vec3(0.33725490196078, 0.52156862745098, 0.6),
    vec3(0.29411764705882, 0.68627450980392, 0.69019607843137),
    vec3(0.28627450980392, 0.46666666666667, 0.58039215686275),
    vec3(0.32156862745098, 0.60392156862745, 0.78039215686275),
    vec3(1, 0.7921568627451, 0.83137254901961),
    vec3(0.80392156862745, 0.70588235294118, 0.85882352941176),
    vec3(0.70196078431373, 0.45098039215686, 0.64313725490196),
    vec3(0.94901960784314, 0.57647058823529, 0.86274509803922),
    vec3(0.56470588235294, 0.34117647058824, 0.63921568627451),
    vec3(0.77647058823529, 0.45098039215686, 0.8156862745098),
    vec3(0.7921568627451, 0.65490196078431, 0.32156862745098),
    vec3(0.89803921568627, 0.75686274509804, 0.36862745098039),
    vec3(0.7843137254902, 0.50196078431373, 0.28627450980392),
    vec3(0.96470588235294, 0.63921568627451, 0.18039215686275),
    vec3(0.72549019607843, 0.35686274509804, 0.48627450980392),
    vec3(0.84313725490196, 0.33333333333333, 0.41960784313725),
    vec3(0.84705882352941, 0.74509803921569, 0.61960784313725),
    vec3(0.96470588235294, 0.91372549019608, 0.80392156862745),
    vec3(0.2078431372549, 0.31372549019608, 0.43921568627451),
    vec3(0.19607843137255, 0.61176470588235, 0.78823529411765),
    vec3(0.22352941176471, 0.098039215686275, 0.2),
    vec3(0.74901960784314, 0.21960784313725, 0.49019607843137)
);

// Pastelality
// uniform vec3 palette[PALETTE_SIZE] = vec3[](
// 	vec3(0.2901960784313726, 0.23137254901960785, 0.3607843137254902),
// 	vec3(0.403921568627451, 0.3137254901960784, 0.5882352941176471),
// 	vec3(0.3254901960784314, 0.17647058823529413, 0.3764705882352941),
// 	vec3(0.5333333333333333, 0.3137254901960784, 0.592156862745098),
// 	vec3(0.3058823529411765, 0.17647058823529413, 0.21176470588235294),
// 	vec3(0.43137254901960786, 0.26666666666666666, 0.35294117647058826),
// 	vec3(0.8627450980392157, 0.4117647058823529, 0.4),
// 	vec3(0.8980392156862745, 0.8117647058823529, 0.37254901960784315),
// 	vec3(0.1450980392156863, 0.19607843137254902, 0.27058823529411763),
// 	vec3(0.36470588235294116, 0.7411764705882353, 0.796078431372549),
// 	vec3(0.5647058823529412, 0.5568627450980392, 0.5764705882352941),
// 	vec3(0.7019607843137254, 0.6823529411764706, 0.6705882352941176),
// 	vec3(0.7843137254901961, 0.6980392156862745, 0.8901960784313725),
// 	vec3(0.9137254901960784, 0.8117647058823529, 0.9490196078431372),
// 	vec3(0, 0, 0),
// 	vec3(1, 1, 1),
// 	vec3(0.7803921568627451, 0.8196078431372549, 0.5490196078431373),
// 	vec3(0.8784313725490196, 0.9450980392156862, 0.6666666666666666),
// 	vec3(0.9098039215686274, 0.7254901960784313, 0.796078431372549),
// 	vec3(0.9803921568627451, 0.8431372549019608, 0.9215686274509803),
// 	vec3(0.7450980392156863, 0.4666666666666667, 0.5372549019607843),
// 	vec3(0.9529411764705882, 0.6745098039215687, 0.7294117647058823),
// 	vec3(0.6313725490196078, 0.8156862745098039, 0.7450980392156863),
// 	vec3(0.7647058823529411, 0.9529411764705882, 0.9686274509803922),
// 	vec3(0.9294117647058824, 0.8470588235294118, 0.7254901960784313),
// 	vec3(0.9529411764705882, 0.9137254901960784, 0.8156862745098039),
// 	vec3(0.9137254901960784, 0.7294117647058823, 0.6666666666666666),
// 	vec3(0.9764705882352941, 0.8705882352941177, 0.8431372549019608),
// 	vec3(0.6392156862745098, 0.6705882352941176, 0.8627450980392157),
// 	vec3(0.7843137254901961, 0.803921568627451, 0.9529411764705882)
// );

vec2 brownConradyDistortion(in vec2 uv, in float k1, in float k2)
{
    uv = uv * 2.0 - 1.0;	// brown conrady takes [-1:1]

    // positive values of K1 give barrel distortion, negative give pincushion
    float r2 = uv.x*uv.x + uv.y*uv.y;
    uv *= 1.0 + k1 * r2 + k2 * r2 * r2;
    
    uv = (uv * .5 + .5);	// restore -> [0:1]
    return uv.xy;
}

void main(void) 
{
    float scale = 1;
    vec2 uv = vTexCoord * scale - (scale * 0.5) + 0.5;
    vec2 uv_distorted = brownConradyDistortion(uv, -0.1, 0);

	vec3 bloom = texture(uBloom, uv_distorted.xy).rgb;
	vec3 color = texture(uComposite, uv_distorted.xy).rgb;

	color += bloom * uBloomScale; 

	// Exposure
	float exposure = texture(uExposure, vec2(0.5)).r;
	exposure = clamp(exposure, 0.001, 100.0);
	color *= exposure;

	color = mix(vec3(color.r*0.3 + color.g*0.5 + color.b*0.2), color, uSaturation);
	color *= uColorBalance.rgb;

	// Tone mapping (built-in)
	//color = vec3(1.0) - exp(-color);

	// ACES Tonemapping (new) - Created by Nolram for the Nautilis renderer.
	color = tonemapACES(color);

	//Gamma correction
	float gamma = 2.2 * uGammaCorrection + 0.25;
	color = pow(color, vec3(1.0 / gamma));

    // Dollar Bill
    vec2 wave = uv;
    float strength = 0.16;
    float frequency = 0.01;
    float wave_frequency = 0.02;
    float wave_amp = 0.0125;
    wave.y += sin(uv.x / wave_frequency) * wave_amp;
    color *= 1 - pow((1 - fract(wave.y / frequency)) * strength, 2);
    color *= 1 - pow((1 - fract(wave.x / frequency * 16/9 / 2)) * strength * 0.5, 2);

    // Color Palette
	vec3 quantizedColor = palette[0];
	float minDistance = compare(color, palette[0]);

	for (int i = 1; i < PALETTE_SIZE; ++i) {
		float distance = compare(color, palette[i]);
		if (distance < minDistance) {
			quantizedColor = palette[i];
			minDistance = distance;
		}
	}

    color = mix(color, quantizedColor, 1.0);
	gl_FragColor = vec4(color, 1.0);
}
#endif
