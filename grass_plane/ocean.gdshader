shader_type spatial;

uniform sampler2D water_noise;
uniform sampler2D wave_noise;
uniform vec3 water_color: source_color;

global uniform vec3 camera_position;
uniform sampler2D screen_texture: hint_screen_texture, repeat_disable;

void vertex() {
	vec2 d_uv = UV;
	d_uv.x += sin(TIME) * 0.05;
	d_uv.y += cos(TIME) * 0.05;
	float vertex_change = texture(wave_noise, d_uv).x;
	
	VERTEX.y += (vertex_change - 0.5) * 0.25;
	COLOR.rgb = vec3(0);
	COLOR.rgb = vec3(vertex_change * vertex_change * vertex_change / 4.0);
}

void fragment() {
	vec2 d_uv = UV;
	d_uv.x += sin(TIME + (UV.x + UV.y) * 10.0) * 0.01;
	d_uv.y += cos(TIME + (UV.x - UV.y) * 10.0) * 0.01;
	
	NORMAL_MAP = texture(water_noise, d_uv).rgb;
	NORMAL *= 0.5;
	
	vec2 d_screen_uv = SCREEN_UV;
	d_screen_uv.x += sin(TIME + (SCREEN_UV.x + SCREEN_UV.y) * 5.0) * 0.005;
	d_screen_uv.y += cos(TIME + (UV.x - SCREEN_UV.y) * 5.0) * 0.005;
	
	vec2 world_pos = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xz;
	float dist = distance(world_pos, camera_position.xz) * 10.0 + 0.1;
	
	vec3 splash_color = vec3((sin(TIME - dist * 5.0) + 1.0) * 0.25) / (dist*dist*1.5);
	
	ALBEDO = texture(screen_texture, d_screen_uv).rgb * water_color + splash_color + COLOR.rgb;
	ALPHA = 20000.0 / (dist*dist*dist);
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
