shader_type canvas_item;

uniform float speed = 0.2;
uniform vec2 tile_size = vec2(6.0, 6.0); // higher = bigger tiles

void fragment() {
    vec2 uv = UV / tile_size;
    
    uv.x -= TIME * speed;
    uv = fract(uv);
    
    COLOR = texture(TEXTURE, uv);
}