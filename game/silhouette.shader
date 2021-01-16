shader_type canvas_item;

uniform bool active;
uniform vec4 color : hint_color;

void fragment()
{
	if(active)
		COLOR = texture(TEXTURE, UV).a > 0.0 ? color : vec4(0.0);
	else
		COLOR = texture(TEXTURE, UV);
}