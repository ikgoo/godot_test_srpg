extends Control

signal ChangeValue(val)

@onready var progress_bar_back = $ProgressBar_Back
@onready var progress_bar_front = $ProgressBar_Front

@export var value : float = 0 : set = setValue
func setValue(val):
	value = val
	progress_bar_front.size.x = (max_width_size / max_value * val) + min_width_size
	emit_signal("ChangeValue", val)
@export var max_value : float = 0

var max_width_size : float
var min_width_size : float = 0

var tween : Tween = null

func _ready():
	max_width_size = progress_bar_back.size.x
	min_width_size = progress_bar_front.size.x
	
	
func MoveValue(val):
	if tween != null and tween.is_running():
		tween.kill()
		
	var tmp_width_size = max_width_size / max_value * val
	tween.tween_property(progress_bar_front, "value", tmp_width_size, 0.5)
