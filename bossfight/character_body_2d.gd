extends CharacterBody2D

const DASHGHOST = preload("res://dashghost.tscn")

@onready var dashtimer = $dashtimer

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dir = "left"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash = false
var dash_per = 0
var DASH_PER_M = 8
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash"):
		dash = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dash == false:
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
			if direction < 0:
				
				dir = "left"
			else:
				dir = "right"
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
	elif dash:
		velocity.y = 0
		if dash_per < DASH_PER_M:
			if dir == "left":
				velocity.x += -7000 * delta
			elif dir == "right":
				velocity.x += 7000 * delta
			dash_per += 1
		elif dash_per >= DASH_PER_M:
			dash = false
			dash_per = 0
	

	move_and_slide()


func _on_dashtimer_timeout():
	var dash_g = DASHGHOST.instantiate()
	dash_g.g_ready(position,scale)
