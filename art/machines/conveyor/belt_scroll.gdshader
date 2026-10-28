shader_type canvas_item;

uniform float speed = 1.0;      // клеток в секунду, как у предметов
uniform vec2 dir = vec2(1.0, 0.0);

void fragment() {
	float shift = floor(TIME * speed * 32.0);
	vec2 uv = UV;
	uv -= dir * shift / 32.0;
	COLOR = texture(TEXTURE, fract(uv));
}
