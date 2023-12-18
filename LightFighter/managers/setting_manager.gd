extends Node

var fullscreen = DisplayServer.WINDOW_MODE_FULLSCREEN : set = set_fullscreen
var scale : float = 1.0 : set = set_scale

func _ready():
	pass

func set_fullscreen(value):
	if value == true:
		fullscreen = DisplayServer.WINDOW_MODE_FULLSCREEN
	else:
		fullscreen = DisplayServer.WINDOW_MODE_WINDOWED
		
	DisplayServer.window_set_mode(fullscreen)
	

func set_scale(value):
	scale = value
	SignalManager.emit_signal("ui_scale_change", value)
