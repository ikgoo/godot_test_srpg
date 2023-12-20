extends Label
class_name ItemInfoLine

func _init(value : String, color : String):
	text = value
	vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label_settings = ResourceManager.fonts[8]
	label_settings.font_color = ResourceManager.colors[color]
	
