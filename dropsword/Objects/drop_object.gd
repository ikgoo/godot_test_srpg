extends RigidBody2D

signal drop_collision(obj_name, obj_idx, pos);
var fruits_upgrade = []
@export var obj_name : String = ""
@export var obj_idx : int = 0
var is_on : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print(body)


func _on_area_2d_area_entered(area : Area2D):
	if is_on == true:
		area.get_parent().is_on = false
		area.get_parent().queue_free()
		is_on = false
		# 물체간 중간위치
		var mid = (global_position + area.global_position) / 2
		emit_signal("drop_collision", obj_name, obj_idx, mid)
		queue_free()
	#	var upgrade_fruit = spawner.upgrade(int(obj_name))
	#	get_parent().add_child(upgrade_fruit)
