shader_type canvas_item;

uniform float speed = 1.0;      // клеток в секунду, как у предметов
uniform float dir = 1.0;        // 1 = вправо, -1 = влево

void fragment() {
	float shift = floor(TIME * speed * 32.0) * dir;  // сдвиг в целых пикселях
	vec2 uv = UV;
	uv.x -= shift / 32.0;                            // пиксели → доли текстуры
	COLOR = texture(TEXTURE, fract(uv));             // fract = прокрутка по кругу
}
