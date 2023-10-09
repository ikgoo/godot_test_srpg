extends CharacterBody2D

class_name Class_Mob

@export var mob : AnimatedSprite2D
@export var isBoss : bool = false

@export var ACCELERATION = 300
@export var MAX_SPEED = 15

@export var target : CharacterBody2D

func spawn(target):
	self.target = target
	mob.play("Run")

func _process(delta):
	var posi = target.global_position
	var direction = global_position.direction_to(posi)
	velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
	
	if velocity.x > 0:
		mob.flip_h = false
	else:
		mob.flip_h = true
		
	move_and_slide()
