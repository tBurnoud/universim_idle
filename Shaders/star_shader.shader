shader_type canvas_item;

uniform float rate = 1.0;

uniform vec3 baseColor = vec3(0.75, 0.1, 0.1);

uniform float radius = 20.0;

varying vec2 v; // This is our varying value yet to be assigned
//varying float a;

float dist(vec2 uv){
	vec2 center = vec2(0.5, 0.5);
	return radius * pow(distance(uv, center), 1.0);
}

void vertex() {
	float pi = 3.141592653589793;

    //VERTEX = mat2(vec2(cos(a), sin(a)), vec2(-sin(a), cos(a))) * VERTEX;
	v = VERTEX; // Here we assign the value to our varying
}

void fragment() {
    COLOR = texture(TEXTURE, UV);
	float a = fract(TIME * rate);
	COLOR.rgb = baseColor;
	COLOR.a = (1.0 - clamp(dist(UV), 0., 1.0));// (1.0-a);
}