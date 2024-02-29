shader_type spatial;

global uniform vec3 camera_position;

varying float height;

void vertex() {
	vec3 world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 sand_color = vec3(0.90, 0.8, 0.1);
	vec3 grass_color = vec3(0.2 * VERTEX.y, 0.6 - VERTEX.y, 0);
	height = world_pos.y;
	
	if (world_pos.y + 0.1 > 0.0) {
		COLOR.rgb = grass_color;
	}
	else if (world_pos.y + 0.2 > 0.0) {
		COLOR.rgb = mix(grass_color, sand_color, -world_pos.y * 5.0);
	}
	else {
		COLOR.rgb = sand_color;
	}
}

void fragment() {
	ALBEDO = COLOR.rgb;
}
