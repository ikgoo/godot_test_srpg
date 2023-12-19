extends Control
class_name ScaleControl

var scale_val : float

func _ready():
	SignalManager.connect("ui_scale_change", _ui_scale_change)
	#set_scale_val(1)
	
func set_scale_val(value):
	scale_val = value
	scale = Vector2(scale_val, scale_val)

func _ui_scale_change(value):
	set_scale_val(value)
	
	
