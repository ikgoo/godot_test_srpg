extends Control
class_name ScaleControl

var scale_val : float
var current_size

func _ready():
	SignalManager.connect("ui_scale_change", _ui_scale_change)
	connect("resized", _on_resize)
	#set_scale_val(1)
	current_size = get_viewport_rect().size
	
func set_scale_val(value):
	scale_val = value
	scale = Vector2(scale_val, scale_val)

func _ui_scale_change(value):
	set_scale_val(value)
	
func _on_resize():
	var new_size = get_viewport_rect().size
	pivot_offset = pivot_offset / current_size * new_size
	current_size = new_size
	
