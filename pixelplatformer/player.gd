extends CharacterBody2D

@onready var animated_sprite_2d = $AnimatedSprite2D

# https://www.youtube.com/watch?v=-9wDi3Y08GM&list=PL9FzW-m48fn16W1Sz5bhTd1ArQQv4f-Cm&index=4
@export var  SPEED = 10.0
@export var  MAX_SPEED = 80.0
@export var JUMP_VELOCITY = -280.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") - 250

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			velocity.y = JUMP_VELOCITY
	else:
		if Input.is_action_just_released("ui_up") and velocity.y < -63:
			velocity.y = -63
			

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction == 0:
		#$AnimatedSprite2D.animation = "Idle"
		$AnimatedSprite2D.play("Idle")
	elif not is_on_floor():
		$AnimatedSprite2D.play("Jump")
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
		
	move_and_slide()

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, SPEED * 1.3)
	
func apply_acceleration(direction):
	velocity.x = move_toward(velocity.x, MAX_SPEED * direction, SPEED)
