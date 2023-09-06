extends CharacterBody2D

# https://www.youtube.com/watch?v=v75IMavnRUs&list=PL9FzW-m48fn2SlrW0KoLT4n5egNdX-W9a&index=7
@export var ACCELERATION : float = 500
@export var MAX_SPEED : float = 80
@export var FRICTION : float = 750

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

# 입력 방향
var inputDirection = Vector2.ZERO

enum PlayerState {
	MOVE,
	ROLL,
	ATTACK,
	IDLE
}

var state : PlayerState = PlayerState.MOVE 
func change_state(chg_state : PlayerState) -> void:
	state = chg_state
	if state == PlayerState.ATTACK:
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", false)
		animationTree.set("parameters/conditions/attack", true)
		velocity = Vector2.ZERO
	elif state == PlayerState.MOVE:
		animationTree.set("parameters/Run/blend_position", inputDirection)
		animationTree.set("parameters/Idle/blend_position", inputDirection)
		animationTree.set("parameters/Attack/blend_position", inputDirection)
		animationTree.set("parameters/conditions/is_run", true)
		animationTree.set("parameters/conditions/idle", false)
		animationTree.set("parameters/conditions/attack", false)
	elif state == PlayerState.IDLE:
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", true)
		animationTree.set("parameters/conditions/attack", false)

		


func _ready():
	animationTree.active = true


func _process(delta):
	match state:
		PlayerState.MOVE:
			move_state(delta)
		PlayerState.IDLE:
			move_state(delta)
		PlayerState.ATTACK:
			attack_state(delta)
		PlayerState.ROLL:
			pass
		
func move_state(delta : float):	
	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	if Input.is_action_pressed("Attack"):
		change_state(PlayerState.ATTACK)
	elif inputDirection != Vector2.ZERO:
		change_state(PlayerState.MOVE)
	else:
		change_state(PlayerState.IDLE)
	
	if(inputDirection != Vector2.ZERO):
		velocity = velocity.move_toward(inputDirection * MAX_SPEED, ACCELERATION * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, FRICTION * delta)
	
	move_and_slide()
	
	
func attack_state(delta : float):
	pass

func attack_animation_finished():
	change_state(PlayerState.IDLE)
