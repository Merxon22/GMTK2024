shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, filter_nearest;

void fragment() {
	vec4 screen_color = texture(screen_tex, SCREEN_UV);
	float contrast = 3.0;
	COLOR = clamp(mix(vec4(0.5), vec4(1.0) - screen_color, contrast), 0.0, 1.0);
	COLOR.a = texture(TEXTURE, UV).a;
}