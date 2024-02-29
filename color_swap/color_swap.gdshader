shader_type canvas_item;

uniform vec3 replacement_color: source_color;

void fragment() {
	vec3 greenscreen_color = COLOR.rgb * vec3(1, 0, 1);
	float greenscreen_presence = length(greenscreen_color);
	float greenscreen_mask = step(0.085, greenscreen_presence);
	float inverted_mask = 1.0 - greenscreen_mask;
	
	vec3 masked_replacement_color = replacement_color * greenscreen_mask;
	vec3 retained_color = COLOR.rgb * inverted_mask;
	vec3 final_color = masked_replacement_color + retained_color;
	
	COLOR.rgb = final_color;
}

