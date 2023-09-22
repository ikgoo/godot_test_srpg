shader_type canvas_item;

void fragment() {
	
	vec2 waves_uv_offset = vec2(0, 0);
	waves_uv_offset.x += TIME * 2.5;
	//if( waves_uv_offset.y % )
	waves_uv_offset.y += cos(TIME) * -1.5;

	//waves_uv_offset.x = cos(TIME) * 0.05;
	//waves_uv_offset.y = sin(TIME) * 0.05;
	
	COLOR = texture( TEXTURE, (UV * 10.0) + waves_uv_offset);
}
