shader_type canvas_item;

void vertex() {
}

void fragment() {
	float temp = COLOR.r;
	COLOR.r = COLOR.g;
	COLOR.g = COLOR.b;
	COLOR.b = temp;
	float distortionSpeed = 1000.0;
	int lineQuantity = 10;
	if (int(TIME*1000.0) % int(FRAGCOORD.y) < 10)
	{
		COLOR.rgb *=3.0;
	}
}