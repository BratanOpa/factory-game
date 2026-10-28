shader_type canvas_item;

// Straight belt (and side-inlet patches). The stripe phase is measured as
// "distance travelled from the cell's entry edge", the same way for every
// direction, so belts, inlets and corners all line up at the joints.
uniform float speed = 1.0;			// tiles per second, same as items
uniform vec2 dir = vec2(1.0, 0.0);	// travel direction
uniform vec2 offset = vec2(0.0);	// this sprite's position inside the cell, in pixels

void fragment() {
	vec2 cell = UV / TEXTURE_PIXEL_SIZE + offset;	// pixel position inside the 32x32 cell
	float dist = dir.x > 0.5 ? cell.x : (dir.x < -0.5 ? 32.0 - cell.x : (dir.y > 0.5 ? cell.y : 32.0 - cell.y));
	float shift = floor(TIME * speed * 32.0);		// whole pixels, keeps pixel art crisp
	float i = fract((dist - shift) / 32.0);
	vec2 uv = UV;
	if (abs(dir.x) > 0.5) { uv.x = i; } else { uv.y = i; }
	COLOR = texture(TEXTURE, uv);
}
