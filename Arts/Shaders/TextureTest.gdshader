shader_type canvas_item;

uniform float speed = 0.2;
uniform vec2 tile_size = vec2(1.0, 1.0); // higher = bigger tiles
uniform vec4 color = vec4(0.5,0.5,0.5, 1);

void fragment() {
    vec2 uv = UV / tile_size;
    
    uv.x -= TIME * speed;
    uv = fract(uv);
    
    COLOR = (texture(TEXTURE, uv) * vec4(0,0,0,1) + vec4(1,1,1,0)) * color;
}