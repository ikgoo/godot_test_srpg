class_name Bullet
extends Area2D

var max_range = 1200.0
var speed = 75.0

var _travelled_distance = 0.0

func _physics_process(delta):
	var distance = speed * delta
	var motion = transform.x * speed * delta
	
	position += motion
	
	_travelled_distance += distance
	if _travelled_distance > max_range:
		set_process(false)
		hide()
		
	
func fire(new_global_transform : Transform2D, random_rotation : float = 0.0) -> void:
	transform = new_global_transform
	rotation += randf_range(-random_rotation / 2.0, random_rotation / 2.0)
	
