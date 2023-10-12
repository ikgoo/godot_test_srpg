class_name BullWithServer

extends Sprite2D

const SHAPE = preload("res://Bullet/bullet_collisiion_shape.tscn")

var query = PhysicsShapeQueryParameters2D.new()
@onready var direct_space_state = get_world_2d().direct_space_state

var max_range = 1200.0
var speed = 75.0

var _travelled_distance = 0.0

func _init():
	query.shape = SHAPE
	query.collide_with_bodies = true
	

func _process(delta):
	var distance = speed * delta
	var motion = transform.x * speed * delta
	position += motion
	
	_travelled_distance += distance

	query.transform = global_transform
	
	var result = direct_space_state.intersect_shape(query, 1)
	if result or _travelled_distance > max_range:
		hide()
		set_process(false)
	
func fire(new_global_transform : Transform2D, random_rotation : float = 0.0) -> void:
	transform = new_global_transform
	rotation += randf_range(-random_rotation / 2.0, random_rotation / 2.0)
	_travelled_distance = 0.0

#
#func is_colliding() -> bool:
#	var query = PhysicsShapeQueryParameters2D.new()
#	var direct_space_state = get_world_2d().direct_space_state
#	query.shape = preload("res://Area/hit_box.tscn")
#	query.collide_with_bodies = true
#	query.transform = global_transform
#	var result = direct_space_state.intersect_shape(query, 1)
#	return not result.is_empty()
