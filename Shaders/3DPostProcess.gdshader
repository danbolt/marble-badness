shader_type spatial;
render_mode unshaded,fog_disabled;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, repeat_disable, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;

uniform float depth_range:hint_range(0.1, 100.0, 0.1);


void vertex() {


	//POSITION = vec4(VERTEX, 1.0);

	// Called for every vertex the material is visible on.
}

void fragment() {
	// Called for every pixel the material is visible on.

	vec2 uv = SCREEN_UV;

	vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	float roughness =  texture(NORMAL_TEXTURE, uv).w;

	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z / depth_range;

	// your code goes here!


	// example outputs

	//ALBEDO = vec3(linear_depth); 	// showing depth texture
	//ALBEDO = normal; 				// showing normal texture
	//ALBEDO = vec3(roughness); 	// showing roughness texture
	//screen_color.b = 0.;
	
	ALBEDO = screen_color;		// showing screen texture
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
