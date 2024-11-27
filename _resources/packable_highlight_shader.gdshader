shader_type spatial;

uniform float alphaAmt;
const vec3 selectionColor = vec3(97./255., 179./255., 255./255.);

void fragment() {
	ROUGHNESS = 0.0;
	ALBEDO = vec3(0, 0, 0);
	ALPHA = alphaAmt;
	EMISSION = selectionColor;
}
