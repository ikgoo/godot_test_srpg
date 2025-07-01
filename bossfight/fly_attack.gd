extends Node2D
@onready var player: CharacterBody2D = $player
@onready var ray : RayCast2D = $RayCast2D
@onready var line_2d: Line2D = $Line2D

#var velocity = 0
var speed = 2500
var player_t = false
var target
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:

	#velocity = Vector2(-sin(rotation),cos(rotation))
	var velocity = Vector2.RIGHT.rotated(rotation) * speed
	
	translate(velocity * delta)
	
	#position += velocity * speed * delta
	#print(position)
		#if position.x <= 70:
			#queue_free()
			#
		#if position.x >= 1500:
			#queue_free()
			#
		#if position.y >= 600:
			#queue_free()
			#
		#if position.y <= 50:
			#queue_free()
func _physics_process(delta: float) -> void:
	if ray.is_colliding():
		target = ray.get_collision_point()
		

func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area.get_parent() != Node2D:
		area.get_parent().mob_attack(10,self,true)
