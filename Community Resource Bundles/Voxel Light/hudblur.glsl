#define VERTICAL 0

uniform sampler2D uTexture;
uniform vec2 uPixelSize;
uniform float uAmount;

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
void main(void) 
{
#if VERTICAL
	vec2 offset = vec2(0.0, uPixelSize.y);
#else
	vec2 offset = vec2(uPixelSize.x, 0.0);
#endif
	vec4 c = vec4(0.0);
	float tot = 0.0;
	for (float s = -uAmount-0.5; s <= uAmount+0.5 ; s+=2.0)
	{
		float w = smoothstep(1.0, 0.0, abs(s) / (uAmount + 1.0));
		c += texture(uTexture, vTexCoord - offset*s) * w;
		tot += w;
	}
	gl_FragColor = vec4(c/tot);
}
#endif
