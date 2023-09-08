shader_type spatial;
render_mode depth_draw_opaque, cull_disabled, ambient_light_disabled, blend_add, shadows_disabled;

uniform vec4 color : source_color;
uniform float fresnel_power = 1.0;
uniform float edge_intensity = 2.0;
uniform float fill_amount : hint_range(0, 1) = 0.1;

uniform float pulsing_strength = 0.25;
uniform float pulsing_speed = 1.0;

uniform float scanline_period = 0.5;
uniform float scanline_width : hint_range(0, 0.49) = 0.1;
uniform float scanline_intensity = 0.35;

uniform float pattern_scroll_speed = 0.025;
uniform vec2 pattern_uv_offset = vec2(6.0, 3.0);

uniform sampler2D pattern_texture : hint_default_white;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture, filter_linear_mipmap;

void vertex() {
	float pulse_distance = sin(TIME * pulsing_speed) * 0.1 * pulsing_strength;
	VERTEX += NORMAL * pulse_distance;
}

void fragment() {
	float fresnel = pow(1.0 - dot(NORMAL, VIEW), fresnel_power) * edge_intensity;
	
	fresnel = fresnel + fill_amount;
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).r * 2.0 - 1.0;
	depth = pow(1.0 - clamp(depth, 0, 1), fresnel_power) * edge_intensity;
	
	fresnel = fresnel + depth;
	
	float scrolling_time = TIME * pattern_scroll_speed;
	vec4 pattern = texture(pattern_texture, (UV * pattern_uv_offset) + vec2(scrolling_time));
	
	fresnel *= pattern.r;
	
	float uv_offset = mod(-TIME * scanline_period, 2.0) - 1.0;
	float scanline = smoothstep(0.5 - scanline_width, 0.5, UV.y + uv_offset) 
			* (1.0 - smoothstep(0.5, 0.5 + scanline_width, UV.y + uv_offset)) * pattern.r;
	
	ALBEDO = vec3(0);
	EMISSION = color.rgb;
	ALPHA = smoothstep(0.0, 1.0, fresnel + scanline * scanline_intensity);
}