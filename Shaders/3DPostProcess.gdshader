shader_type spatial;
render_mode unshaded,fog_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;


uniform float colors_per_channel: hint_range(1.0, 64.0, 1.0) = 8.0;
uniform float normal_outline_strength: hint_range(0.0, 10.0, 0.1) = 0.5;

uniform float sensitivity: hint_range(0.0, 100.0, 0.0001);
uniform float normal_sensitivity: hint_range(0.001,1,0.001);
uniform float normal_horizontal_vertical_sensitivity:  hint_range(0.001,1,0.001);
uniform float depth_range:hint_range(1.0, 10000.0, 0.1);
uniform float thickness:hint_range(0.0,5.0,0.1);
uniform float normalSampleThickness:hint_range(0.01,5.0,0.01);
uniform float step_threshold: hint_range(0.0, 1.0, 0.01);
uniform vec3 outline_color: source_color;

void vertex() {


	//POSITION = vec4(VERTEX, 1.0);

	// Called for every vertex the material is visible on.
}

float sampleLinearDepth(vec2 uv, mat4 inv_proj, float vertexDepth) {
	
	float depth = texture(DEPTH_TEXTURE, uv).x;
	vec3 ndc = vec3(uv * 2.0 - 1.0, depth);
	vec4 view = inv_proj * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z;
	linear_depth = vertexDepth + linear_depth;
	linear_depth = linear_depth * 0.01;
	return pow(linear_depth,1.);
}

vec3 sampleNormal(vec2 uv) {
	return texture(NORMAL_TEXTURE, uv).rgb;
}

void fragment() {
	// Called for every pixel the material is visible on.

	vec2 uv = SCREEN_UV;

	
	//float roughness =  texture(NORMAL_TEXTURE, uv).w;
	
	
	float outline_thickness = thickness * 0.01;
	float pixel_depth = sampleLinearDepth(uv, INV_PROJECTION_MATRIX, VERTEX.z);

	float border_r = sampleLinearDepth(uv + vec2(outline_thickness, 0.0), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	float border_l = sampleLinearDepth(uv + vec2(-outline_thickness, 0.0), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	float border_t = sampleLinearDepth(uv + vec2(0.0, outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	float border_b = sampleLinearDepth(uv + vec2(0.0, -outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	//float border_rt = sampleLinearDepth(uv + vec2(outline_thickness, outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	//float border_rb = sampleLinearDepth(uv + vec2(outline_thickness, -outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	//float border_lt = sampleLinearDepth(uv + vec2(-outline_thickness, outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	//float border_lb = sampleLinearDepth(uv + vec2(-outline_thickness, -outline_thickness), INV_PROJECTION_MATRIX, VERTEX.z)- pixel_depth;
	
	float depth_outline = clamp(((border_r + border_l + border_t + border_b) * sensitivity) / 4. , 0., 1.);
	depth_outline = smoothstep(0, step_threshold, depth_outline);
	
	float normal_thickness = normalSampleThickness * 0.01;
	
	vec3 normal_center = sampleNormal(uv);
	
	vec3 normal_t = sampleNormal(uv + vec2(normal_thickness,0.0));
	vec3 normal_b = sampleNormal(uv + vec2(-normal_thickness,0.0));
	vec3 normal_r = sampleNormal(uv + vec2(0.0,normal_thickness));
	vec3 normal_l = sampleNormal(uv + vec2(0.0,-normal_thickness));
	
	float nt_difference = distance(normal_center, normal_t);
	float nb_difference = distance(normal_center, normal_b);
	float nl_difference = distance(normal_center, normal_l);
	float nr_difference = distance(normal_center, normal_r);
	
	
	float h_inline = step(normal_horizontal_vertical_sensitivity, nl_difference + nr_difference);
	float v_inline = step(normal_horizontal_vertical_sensitivity, nt_difference + nb_difference);
	float normal_outline = step(normal_sensitivity, h_inline + v_inline) * normal_outline_strength;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
	vec3 quantized_color = floor(screen_color * colors_per_channel) / colors_per_channel;
	
	ALBEDO.rgb = vec3(max(depth_outline,normal_outline) * outline_color);
	
	//ALBEDO = outline * outline_color;
	ALPHA = max(depth_outline,normal_outline);
	//linear_depth = smoothstep(linear_depth,0.00001, 0.001);
	//ALBEDO.rgb = screen_color;
	//ALBEDO = vec3(pixel_depth);
	//ALBEDO = vec3(pixel_depth);	// showing screen texture
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
