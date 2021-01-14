shader_type canvas_item;

uniform vec4 test : hint_color;
uniform sampler2D lookup_palette;
uniform float lookup_step : hint_range(0, 5) = 0;

void fragment()
{
	vec4 col = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 final_color = col;
	if(lookup_step != 0.0)
	{
		final_color = texture(lookup_palette, vec2(col.r, lookup_step/5.0));
	}
	COLOR = final_color;
}