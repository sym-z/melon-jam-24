shader_type canvas_item;

void vertex() {
	float speed = 1.22;
	float dist = 2.0;
	float wiggle_x = dist*cos(TIME*speed);
	float wiggle_y = wiggle_x;
	float shiver_intensity = 10.0;
	if (int(wiggle_x * shiver_intensity)%2==0){
		wiggle_x = -wiggle_x;
	}
	VERTEX += vec2(wiggle_x,wiggle_y);
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