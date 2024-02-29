shader_type canvas_item;

const float WAVE_SIZE = 100.0;
const float WAVE_SPEED = 2.0;

void vertex() {
	if (VERTEX.y < 0.0) {
		float wave = sin(TIME * WAVE_SPEED) * WAVE_SIZE;
		VERTEX.x += wave;
	}
}
