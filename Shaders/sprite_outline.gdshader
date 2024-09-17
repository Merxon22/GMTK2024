shader_type canvas_item;

uniform vec4 outline_color : source_color;
uniform float outline_width = 0;

void fragment() {
	vec2 uv_up = UV + TEXTURE_PIXEL_SIZE * vec2(0.0, outline_width);
	vec2 uv_down = UV + TEXTURE_PIXEL_SIZE * vec2(0.0, -outline_width);
	vec2 uv_left = UV + TEXTURE_PIXEL_SIZE * vec2(outline_width, 0.0);
	vec2 uv_right = UV + TEXTURE_PIXEL_SIZE * vec2(-outline_width, 0.0);
	
	vec4 outline = texture(TEXTURE, uv_up) + texture(TEXTURE, uv_down) + texture(TEXTURE, uv_left) + texture(TEXTURE, uv_right);
	outline.rgb = outline_color.rgb;
	
	vec4 original_color = texture(TEXTURE, UV);
	COLOR = mix(outline, original_color, original_color.a);
}
	