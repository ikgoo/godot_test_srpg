extends Control

@onready var settings = $Windows/settings


func _on_settings_pressed():
	settings.visible = not settings.visible
	#settings.raise()
	settings.move_to_front()
