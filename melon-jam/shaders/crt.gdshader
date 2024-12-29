shader_type canvas_item;

void vertex() {
}

void fragment() {
	float scanLineStrength = 0.85;
	float bandingStrength = 0.01;
	float lineThickness = 1.2;
	float opacity = 1.2;
	
	float wave = cos(FRAGCOORD.y * lineThickness + TIME)*opacity;
	// Static Scanline
	if(int(FRAGCOORD.y) % 2 == 0)
	{
		COLOR.rgb *= scanLineStrength;
	}
	// Wave of banding
	COLOR.rgb += wave*bandingStrength;
}