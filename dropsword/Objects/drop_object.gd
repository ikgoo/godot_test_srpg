extends RigidBody2D

class_name DropObject

signal drop_collision(obj_name, obj_idx, pos, obj);
var obj_name : String = ""
var obj_idx : int = 0
var is_on : bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	is_on = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_body_entered(body):
#	print(body)
#
#
#func _on_area_2d_area_entered(area : Area2D):
#	if is_on == true and area.get_parent().is_on == true:
#		is_on = false
#		area.get_parent().is_on = false
#		#area.get_parent().queue_free()
#		# 물체간 중간위치
#		var mid = (global_position + area.global_position) / 2
#		emit_signal("drop_collision", obj_name, obj_idx, mid, self, area.get_parent())
#		#is_on = true
##		queue_free()
#	#	var upgrade_fruit = spawner.upgrade(int(obj_name))
#	#	get_parent().add_child(upgrade_fruit)
#
	
	
