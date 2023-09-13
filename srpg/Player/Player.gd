extends CharacterBody2D

@export var ACCELERATION : float = 500
@export var MAX_SPEED : float = 80
@export var FRICTION : float = 750
@export var ROLL_SPEED : float = 125

@onready var animationPlayer : AnimationPlayer = $AnimationPlayer
@onready var animationTree : AnimationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var hit_box = $Marker2D/HitBox

# 입력 방향
var inputDirection = Vector2.DOWN
var lastDirection = Vector2.DOWN
var rollDirection = Vector2.ZERO

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
		animationTree.set("parameters/Attack/blend_position", lastDirection)
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", false)
		animationTree.set("parameters/conditions/attack", true)
		animationTree.set("parameters/conditions/is_roll", false)
	elif state == PlayerState.MOVE:
		animationTree.set("parameters/Run/blend_position", lastDirection)
		animationTree.set("parameters/conditions/is_run", true)
		animationTree.set("parameters/conditions/idle", false)
		animationTree.set("parameters/conditions/attack", false)
		animationTree.set("parameters/conditions/is_roll", false)
	elif state == PlayerState.IDLE:
		animationTree.set("parameters/Idle/blend_position", lastDirection)
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", true)
		animationTree.set("parameters/conditions/attack", false)
		animationTree.set("parameters/conditions/is_roll", false)
	elif state == PlayerState.ROLL:
		animationTree.set("parameters/Roll/blend_position", lastDirection)
		animationTree.set("parameters/conditions/is_run", false)
		animationTree.set("parameters/conditions/idle", false)
		animationTree.set("parameters/conditions/attack", false)
		animationTree.set("parameters/conditions/is_roll", true)
		

		


func _ready():
	animationTree.active = true
	hit_box.knockback_vector = lastDirection


func _process(delta):
	match state:
		PlayerState.MOVE:
			move_state(delta)
		PlayerState.IDLE:
			move_state(delta)
		PlayerState.ATTACK:
			attack_state(delta)
		PlayerState.ROLL:
			roll_state(delta)
		
func move_state(delta : float):	
	inputDirection = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if(inputDirection != Vector2.ZERO):
		lastDirection = inputDirection
		hit_box.knockback_vector = lastDirection
	

	if Input.is_action_pressed("Attack"):
		change_state(PlayerState.ATTACK)
	elif Input.is_action_pressed("roll"):
		rollDirection = lastDirection
		change_state(PlayerState.ROLL)
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
	velocity = Vector2.ZERO

func roll_state(delta : float):
	velocity = rollDirection * ROLL_SPEED
	move_and_slide()
	

func roll_animation_finished():
	velocity = velocity * 0.7
	move_and_slide()
	change_state(PlayerState.IDLE)	
	
func attack_animation_finished():
	change_state(PlayerState.IDLE)