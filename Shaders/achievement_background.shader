shader_type canvas_item;

uniform float gotten = 0.0;

void fragment(){
	float val  = gotten/2.0;
	COLOR.rgb = vec3(val, val, val);
}