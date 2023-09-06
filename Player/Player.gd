extends CharacterBody2D

# https://www.youtube.com/watch?v=v75IMavnRUs&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=7
@export var ACCELERATION : float = 500
@export var MAX_SPEED : float = 80
@export var FRICTION : float = 2000

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

var inputDirection = Vector2.ZERO

func animationUpdate():
	if inputDirection != Vector2.ZERO:
		animationTree.set("parameters/Run/blend_position", inputDirection)
		animationTree.set("parameters/conditions/is_run", true)
		animationTree.set("parameters/conditions/idle", false)
	else:
		animationTree.set("parameters/Idle/blend_position", inputDirection)
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", true)


func _physics_process(delta):
	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	#velocity += velocity.move_toward(max_speed, acc * delta)
	if(inputDirection != Vector2.ZERO):
		velocity = velocity.move_toward(inputDirection * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
		
	animationUpdate()
	move_and_slide()
	print_debug(animationState)
	
	
