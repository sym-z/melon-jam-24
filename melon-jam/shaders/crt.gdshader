shader_type canvas_item;

void vertex() {
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