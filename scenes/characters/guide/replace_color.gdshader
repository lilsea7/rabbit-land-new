shader_type canvas_item;

uniform vec4 original_0 : source_color;
uniform vec4 original_1 : source_color;

uniform vec4 replace_0 : source_color;
uniform vec4 replace_1 : source_color;

const float precision = 0.1;

vec4 replace_color(vec4 color) {
	vec4 original_colors[2] = vec4[2](original_0, original_1);
	vec4 replace_colors[2] = vec4[2](replace_0, replace_1);
	
	for(int I = 0; I < 2; I++) {
		if (distance(color, original_colors[I]) <= precision) {
			color = replace_colors[I];
		}
	}
	
	return color;
}

void fragment() {
	COLOR = replace_color(texture(TEXTURE, UV));
}
