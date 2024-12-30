shader_type canvas_item;

void vertex() {
	float ossSpeed = 2.0;
	float moveSpeed = 0.3;
	float amount = cos(TIME*ossSpeed)*moveSpeed;
	VERTEX.x += amount*2.0;
	VERTEX.y += abs(amount);

}

void fragment() {
	float scanLineStrength = 0.85;
	float bandingStrength = 0.012;
	float wave = cos(FRAGCOORD.y + TIME);
	// Static Scanline
	if(int(FRAGCOORD.y) % 2 == 0)
	{
		COLOR.rgb *= scanLineStrength;
	}
	// Wave of banding
	COLOR.rgb += wave*bandingStrength;
}