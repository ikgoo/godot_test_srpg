extends Area2D

signal HurtEvent

@export var show_hit : bool = true
@export var invincibillity_time : float = 1.0
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer


const HitEffect = preload("res://Areas/hit_effect.tscn")

func _ready():
	timer.wait_time = invincibillity_time

func _on_area_entered(area):
	collision_shape_2d.set_deferred("disabled", true)
	
	if show_hit == true:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
	
	emit_signal("HurtEvent")
	timer.start()
 


func _on_timer_timeout():
	collision_shape_2d.set_deferred("disabled", false)
	print('무적 해지')
