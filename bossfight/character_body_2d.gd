extends CharacterBody2D

const DASHGHOST = preload("res://dashghost.tscn")

@onready var dashtimer = $dashtimer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var dir = "left"
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var dash = false
var dash_per = 0
var DASH_PER_M = 8
var jump = 2
var wall_run = false
var r_wall = false
var l_wall = false
var attack = true
var gwan = 0
func _physics_process(delta):
	if dir == "left":
		sprite_2d.flip_h = true
	elif dir == "right":
		sprite_2d.flip_h = false
	velocity.x = 0
	velocity.x += gwan
	if is_on_floor():
		gwan = 0
	if gwan > 0:
		gwan -= 40
		
	if gwan < 0:
		gwan += 40
		
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if is_on_floor():
		jump = 2
	if Input.is_action_just_pressed("ui_accept") and jump >= 1:
		jump -= 1
		velocity.y = JUMP_VELOCITY
		
	if Input.is_action_just_pressed("dash"):
		dash = true
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dash == false:
		
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x += direction * SPEED
			print(velocity)
			if direction < 0:
				
				dir = "left"
			else:
				dir = "right" 
		else:
			velocity.x += move_toward(velocity.x, 0, SPEED)
	if Input.is_action_just_pressed("attack"):
		if dir == "left":
			animation_player.play("r_attack")
		if dir == "right":
			animation_player.play("l_attack")
		
	elif dash:
		jump = 1
		dashtimer.start()
		velocity.y = 0
		if dash_per < DASH_PER_M:
			if dir == "left":
				velocity.x += -1000
			elif dir == "right":
				velocity.x += 1000
			dash_per += 1
		elif dash_per >= DASH_PER_M:
			dash = false
			dash_per = 0
	if wall_run == true:
		if l_wall:
			velocity.y = 0
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				gwan = 500
				wall_run = false
				jump += 1
			
		if r_wall:
			velocity.y = 0
			if Input.is_action_just_pressed("ui_accept"):
				velocity.y = JUMP_VELOCITY
				gwan = -500
				wall_run = false
				jump += 1
	
	move_and_slide()


func _on_dashtimer_timeout():
	var dash_g = DASHGHOST.instantiate()
	dash_g.g_ready(position,scale)
	get_tree().current_scene.add_child(dash_g)


func _on_area_2d_area_entered(area):
	wall_run = true
	l_wall = true


func _on_area_2d_area_exited(area):
	wall_run = false
	l_wall = false


func _on_area_2d_2_area_entered(area):
	wall_run = true
	r_wall = true


func _on_area_2d_2_area_exited(area):
	wall_run = false
	r_wall = false


func _on_area_2d_3_area_entered(area):
	pass # Replace with function body.
