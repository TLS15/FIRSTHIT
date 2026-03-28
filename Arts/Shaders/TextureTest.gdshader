//shader_type canvas_item;
//
//uniform float speed = 0.2;
//uniform vec2 tiling = vec2(4.0, 1.0); // number of repeats
//
//void fragment() {
    //vec2 uv = UV * tiling;
    //
	//
    //// scrolling
    //uv.x -= TIME * speed;
    //
    //// wrap
    //uv = fract(uv);
    //
    //COLOR = texture(TEXTURE, uv);
//}

shader_type canvas_item;

uniform float speed = 0.2;
uniform vec2 tile_size = vec2(6.0, 6.0); // higher = bigger tiles

void fragment() {
    vec2 uv = UV / tile_size;
    
    uv.x -= TIME * speed;
    uv = fract(uv);
    
    COLOR = texture(TEXTURE, uv);
}