extends Node2D
@onready var marker_2d = $Marker2D


func _process(delta):
	marker_2d.look_at(get_global_mouse_position())
	
