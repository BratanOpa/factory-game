shader_type canvas_item;

// Square corner. Each stripe is a rigid line that rotates around the inner
// corner (pivot) as it travels, like in Mindustry: the stripe itself keeps
// its width, only the gaps between stripes grow toward the outer wall.
uniform sampler2D belt_tex : filter_nearest, repeat_enable;	// surface.png
uniform float speed = 1.0;					// tiles per second, same as items
uniform float period = 8.0;				// stripe repeat in surface.png, in pixels
const float ARC = 24.0;					// belt length through the corner; must be a multiple of period
uniform vec2 side_in = vec2(-1.0, 0.0);		// side items come from
uniform vec2 dir_out = vec2(0.0, -1.0);		// direction items leave

void fragment() {
	vec2 p = UV * 32.0;
	// the two closed sides are -side_in and -dir_out: leave room for their rails
	vec2 closed = -(side_in + dir_out);
	if (closed.y > 0.5 && p.y >= 24.0) { discard; }
	if (closed.y < -0.5 && p.y < 6.0) { discard; }
	if (closed.x < -0.5 && p.x < 7.0) { discard; }
	if (closed.x > 0.5 && p.x >= 25.0) { discard; }

	vec2 pivot = vec2(16.0) + (side_in + dir_out) * 16.0;	// inner corner
	vec2 d = abs(p - pivot);
	float r = length(d);
	float a = atan(d.y, d.x) / (PI * 0.5);		// 0 on the top/bottom edge, 1 on the left/right edge
	float s = dir_out.x != 0.0 ? a : 1.0 - a;	// 0 at the input edge, 1 at the output edge

	float shift = floor(TIME * speed * 32.0);
	float q = s * ARC - shift;					// distance travelled from the entry edge (same phase as straight belts)
	float c = round(q / period) * period;		// nearest stripe slot
	float t = r * sin((q - c) * (PI * 0.5) / ARC);	// angle offset -> real distance in pixels
	t = clamp(t, -period * 0.5 + 0.01, period * 0.5 - 0.01);
	float v = clamp((r - 6.0) / 18.0, 0.0, 1.0);	// across the belt
	COLOR = texture(belt_tex, vec2(fract((c + t) / 32.0), v));
}
