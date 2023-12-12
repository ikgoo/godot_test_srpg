extends CharacterBody2D
class_name Player

# https://www.youtube.com/watch?v=pMjXUkX3eh0&list=PL9FzW-m48fn16W1Sz5bhTd1ArQQv4f-Cm&index=13
enum { MOVE, CLIMB }

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var ladder_check = $LadderCheck
@export var moveData : PlayerMovementData
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var remote_transform_2d = $RemoteTransform2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 250
var state = CLIMB
var direction
var double_jump = 1
var buffered_jump = false
var coyote_jump = false

func powerup():
	moveData = load("res://FastPlayerMovementData.tres")

func player_die():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal('play_die')

func _physics_process(delta):
	
	var direction = Vector2.ZERO
	direction.x = Input.get_axis("ui_left", "ui_right")
	direction.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(direction, delta)
		CLIMB: climb_state(direction, delta)
		
	if velocity.x > 0:
		animated_sprite_2d.flip_h = true
	elif velocity.x < 0:
		animated_sprite_2d.flip_h = false
		
	move_and_slide()

func move_state(direction, delta):
	
	if is_on_ladder() and Input.is_action_pressed("ui_up"):
		state = CLIMB
	
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		double_jump = moveData.DOUBLE_JUMP_COUNT
		if Input.is_action_just_pressed("ui_up") and not buffered_jump:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -63:
			velocity.y = -63
			
		if Input.is_action_just_pressed("ui_up") and double_jump > 0:
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.JUMP_VELOCITY
			double_jump -= 1
			
		if Input.is_action_just_pressed("ui_up"):
			buffered_jump = true
			jump_buffer_timer.start()
	
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

	
func climb_state(direction, delta):
	if not is_on_ladder():
		state = MOVE
	print(direction.length())
	if direction.length() != 0:
		animated_sprite_2d.animation = "Run"
	else:
		animated_sprite_2d.animation = "Idle"
		
	velocity = direction * moveData.CLIMB_SPEED * delta
	#velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * direction.x, moveData.SPEED)
	#velocity.y = move_toward(velocity.y, moveData.MAX_SPEED * direction.y, moveData.SPEED)
	#velocity.y *= direction.y * 50
	

func is_on_ladder():
	if not ladder_check.is_colliding(): return false
	var  collider = ladder_check.get_collider()
	if not collider is Ladder: return false
	return true

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, moveData.SPEED * 1.3)
	
func apply_acceleration(direction):
	velocity.x = move_toward(velocity.x, moveData.MAX_SPEED * direction.x, moveData.SPEED)

func connect_camera(camera : Camera2D):
	var camera_path = camera.get_path()
	remote_transform_2d.remote_path = camera_path

func _on_jump_buffer_timer_timeout():
	buffered_jump = false
