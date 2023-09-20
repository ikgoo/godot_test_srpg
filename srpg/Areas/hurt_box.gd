extends Area2D

signal HurtEvent(area)
signal invincibility_started(area)
signal invincibility_ended

@export var show_hit : bool = true
@export var invincibillity_time : float = 1.0
@onready var collision_shape_2d = $CollisionShape2D
@onready var timer = $Timer


const HitEffect = preload("res://Areas/hit_effect.tscn")

var invincible : bool = false : set = set_invincible
func set_invincible(value):
	invincible = value
	if invincible == true:
		emit_signal("invincibility_started")
	else:
		emit_signal("invincibility_ended")


func _ready():
	timer.wait_time = invincibillity_time

func create_hit_effect():	
	if show_hit == true:
		var effect = HitEffect.instantiate()
		var main = get_tree().current_scene
		main.add_child(effect)
		effect.global_position = global_position
	
 
func _on_timer_timeout():
	print('무적 해지')
	invincible = false


func start_invicibility(duration):
	invincible = true
	timer.start(duration)

func _on_invincibility_ended():
	collision_shape_2d.disabled = false

func _on_area_entered(area):
	if invincible == false:
		collision_shape_2d.set_deferred("disabled", true)
		print("충돌")
		emit_signal("HurtEvent", area)		# 피격 이벤트 발생
	
