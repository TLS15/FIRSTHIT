shader_type canvas_item;

uniform float speed : hint_range(0.0, 10.0) = 0.5;
uniform float arrow_size_px = 3.0; // size of one arrow in pixels
uniform vec4 arrow_color : source_color = vec4(0.2, 0.6, 1.0, 1.0);

void fragment() {
    // Convert UV to pixel space so size stays constant
    vec2 pixel_uv = UV * vec2(textureSize(TEXTURE, 0));

    // If no texture exists (ColorRect), fallback to SCREEN_PIXEL_SIZE
    if (textureSize(TEXTURE, 0).x == 0) {
        pixel_uv = UV / SCREEN_PIXEL_SIZE;
    }

    // Animate movement (right → left)
    float t = TIME * speed;
    pixel_uv.x += t * arrow_size_px;

    // Repeat pattern based on arrow size
    vec2 grid_uv = pixel_uv / arrow_size_px;
    grid_uv.x = fract(grid_uv.x);
    grid_uv.y = fract(grid_uv.y);

    // Center the arrow
    vec2 p = grid_uv - 0.5;

    // Arrow shape (triangle + tail)
    float body = step(-0.2, p.x) * step(abs(p.y), 0.15);
    float head = step(p.x, 0.3) * step(abs(p.y), 0.5 - p.x);

    float arrow = max(body, head);

    // Optional soft edges
    arrow = smoothstep(0.5, 0.4, arrow);

    COLOR = vec4(arrow_color.rgb, arrow * arrow_color.a);
}