shader_type canvas_item;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	float scanLineStrength = 0.85;
	float bandingStrength = 0.01;
	float lineThickness = 1.2;
	float opacity = 1.2;
	
	float wave = cos(FRAGCOORD.y * lineThickness + TIME)*opacity;
	
	if(int(FRAGCOORD.y) % 2 == 0)
	{
		COLOR.rgb *= scanLineStrength;
	}
	COLOR.rgb += wave*bandingStrength;
}