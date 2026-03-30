shader_type canvas_item;

uniform vec4 replace_color : source_color = vec4(1,0,1,1); 

void fragment() {
	
    vec4 tex_color = texture(TEXTURE, UV);

	COLOR = vec4(replace_color.rgb, tex_color.a);
}