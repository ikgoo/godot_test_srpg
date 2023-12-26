extends CharacterBody2D

const MAX_SPEED : float = 100.0
const SPEED : float = 500.0
const JUMP_VELOCITY : float = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, direction.x * MAX_SPEED, SPEED * delta)
	
	if direction.y == 0:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	else:
		velocity.y = move_toward(velocity.y, direction.y * MAX_SPEED, SPEED * delta)

	move_and_slide()
