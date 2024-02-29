shader_type spatial;

global uniform vec3 camera_position;

void vertex() {
	float hight_variation = (INSTANCE_CUSTOM.x + 1.0) / 2.0;
	float green_color = 7.5 * VERTEX.y + 0.25;
	float red_color = green_color * hight_variation;
	COLOR.rgb = vec3(red_color, green_color, 0);
	
	VERTEX.y += mix(0, hight_variation * hight_variation, VERTEX.y);
	VERTEX.y -= mix(0, -0.5 * hight_variation, VERTEX.y);
	
	float rotation_speed = mix(0.1, 0.5, hight_variation);
	float local_rotation = TIME - round(INSTANCE_CUSTOM.y);
	VERTEX.x += mix(0, sin(local_rotation) * rotation_speed, VERTEX.y);
	VERTEX.z += mix(0, cos(local_rotation) * rotation_speed, VERTEX.y);
	
	vec2 dire_to_cam = INSTANCE_CUSTOM.zw - camera_position.xz;
	float dist_to_cam = length(dire_to_cam);
	vec2 norm_dist_to_cam = normalize(dire_to_cam);
	
	float sin_angle = sin(INSTANCE_CUSTOM.y);
	float cos_angle = cos(INSTANCE_CUSTOM.y);
	norm_dist_to_cam.x = norm_dist_to_cam.x * cos_angle - norm_dist_to_cam.y * sin_angle;
    norm_dist_to_cam.y = norm_dist_to_cam.x * sin_angle + norm_dist_to_cam.y * cos_angle;
	
	float bend_amount = max(1.0 - (dist_to_cam * 4.0), 0);
	
	VERTEX.x += norm_dist_to_cam.x * VERTEX.y * bend_amount;
	VERTEX.z += norm_dist_to_cam.y * VERTEX.y * bend_amount;
}

void fragment() {
	ALBEDO = COLOR.rgb;
}
