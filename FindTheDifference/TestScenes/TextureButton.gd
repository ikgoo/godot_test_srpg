extends TextureButton

signal ImageClick(name)

func _on_pressed():
	emit_signal("ImageClick", name)
	
