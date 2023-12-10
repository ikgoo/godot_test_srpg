extends CharacterBody2D
class_name Player

enum { MOVE, CLIMB }

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ladder_check = $LadderCheck


# https://www.youtube.com/watch?v=XIBrsZ3O29g&list=PL9FzW-m48fn16W1Sz5bhTd1ArQQv4f-Cm&index=9
@export var moveData : PlayerMovementData

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 250
var state = MOVE
var direction

func powerup():
	moveData = load("res://FastPlayerMovementData.tres")

func _physics_process(delta):
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")

	if is_on_ladder():
		climb_state(direction, delta)
	else:
		move_state(direction, delta)
	
	
	
	if state == MOVE: move_state(direction, delta)
	elif state == CLIMB: climb_state(direction, delta)
	
		
	move_and_slide()

func move_state(direction, delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = moveData.JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -63:
			velocity.y = -63
	
	if not is_on_floor():
		$AnimatedSprite2D.play("Jump")
	elif direction.x == 0:
		#$AnimatedSprite2D.animation = "Idle"
		$AnimatedSprite2D.play("Idle")
	else:
		#$AnimatedSprite2D.animation = "Run"
		$AnimatedSprite2D.play("Run")
	
	
	if direction:
		apply_acceleration(direction)
	else:
		apply_friction()

	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = false
	
func climb_state(direction, delta):
	#velocity.y *= direction.y * 50
	pass
	

func is_on_ladder():
	if not ladder_check.is_colliding(): return false
	var  collider = ladder_check.get_collider()
	if not collider is Ladder: return false
	return true

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.SPEED * 1.3)
	
func apply_acceleration(direction):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * direction.x, moveData.SPEED)
