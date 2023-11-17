extends CharacterBody2D

class_name Class_Mob

@export var mob : AnimatedSprite2D
@export var isBoss : bool = false

@export var ACCELERATION = 100
@export var MAX_SPEED = 1

@export var target : CharacterBody2D

func spawn(target):
	self.target = target
	mob.play("Run")

func _process(delta):
	var posi = target.global_position
	if global_position.distance_to(posi) < 1:
		velocity = Vector2.ZERO
	else:
		var direction = global_position.direction_to(posi)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)
#		velocity = direction * MAX_SPEED * delta
		
		if velocity.x > 0:
			mob.flip_h = false
		else:
			mob.flip_h = true
	
		global_position += velocity
		
	move_and_slide()
