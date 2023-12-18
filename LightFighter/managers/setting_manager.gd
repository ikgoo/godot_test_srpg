extends Node

var fullscreen : DisplayServer.WindowMode = DisplayServer.WINDOW_MODE_FULLSCREEN : set = set_fullscreen
var scale : float = 1.0 : set = set_scale

func _ready():
	pass

func set_fullscreen(value):
	fullscreen = value
	

func set_scale(value):
	scale = value
	SignalManager.emit_signal("ui_scale_change", value)
