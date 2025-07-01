extends CharacterBody2D

signal shake_camera

const DASHGHOST = preload("res://dashghost.tscn")
@onready var paring_timer = $paring_timer
@onready var dashtimer = $dashtimer
@onready var animation_player = $AnimationPlayer
@onready var sprite_2d = $Sprite2D
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var audio_stream_player_2d_2 = $AudioStreamPlayer2D2
@onready var paring_cooldown = $paring_cooldown
@onready var area = $Area2D3
@onready var area_2 = $Area2D4
@onready var hurt: GPUParticles2D = $hurt
@onready var drum_t: Timer = $drum_t
@onready var audio_stream_player_2d_3: AudioStreamPlayer2D = $AudioStreamPlayer2D3
@onready var mouse_area: Area2D = $mouse_area
@onready var paring_jwung: GPUParticles2D = $paring_jwung
@onready var tick_tick_anime: AnimationPlayer = $tick_tick_anime
@onready var control_2: Control = $CanvasLayer/Control2
@onready var audio_stream_player_2d_4: AudioStreamPlayer2D = $AudioStreamPlayer2D4

var paring_g = false
const good_j = preload("res://New Piskel (3).png")
const bad_j = preload("res://New Piskel (2).png")
const miss_j = preload("res://New Piskel (1).png")
const perfect_j = preload("res://New Piskel.png")
const ASE_24 = preload("res://ase24.png")
const ICON = preload("res://icon.svg")
const TICK_J = preload("res://tick_j.tscn")
const TICK_ROUND = preload("res://tick_round'.tscn")
const PARING_JWUNG = preload("res://paring_jwung.tscn")
var motion = "idle"
var motion_p = "null"
var paring = false
const SPEED = 1500.0
const JUMP_VELOCITY = -2000.0
var dir = "left"
var mobs = []
var kill = 0
var paring_jwung_now
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 4
var dash = false
var dash_per = 0
var DASH_PER_M = 8
var jump = 2
var wall_run = false
var r_wall = false
var l_wall = false
var attack = true
var gwan = 0
var paring_time = false
var paring_ok = false
var area_mob = null
var paring_j_go = false
var round = []
var tick = []
	
func _ready() -> void:
	tick_anime_go()
	tick_tick_anime.speed_scale = 1
func _physics_process(delta):
	var mouse_pos = get_global_mouse_position()
	mouse_area.global_position = mouse_pos
	if motion == "jump":
		if not velocity.y < 0:
			motion = "idle"
	else:
		motion = "idle"
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

	# Handle jump.
	if is_on_floor():
		jump = 2
	if Input.is_action_just_pressed("ui_accept") and jump >= 1:
		jump -= 1
		velocity.y = JUMP_VELOCITY
		motion = "jump"
		motion_p = "null"
	
	if Input.is_action_just_pressed("paring"):
		if paring_ok == true:
			if paring_j_go == false:
				global_position = Vector2(get_global_mouse_position().x - 10,get_global_mouse_position().y)
				emit_signal("shake_camera")
				paring_j_go = true
				tick_tick_anime.play("gun")
		else:
			if paring_j_go == true:
				while round[0] == null:
					round.pop_front()
				print(round[0])
				if round[0].give_j() != "nothing":
					var tick_round = PARING_JWUNG.instantiate()
					tick_round.jwung = round[0].give_j()
					tick_round.mob = mobs[0]
					add_child(tick_round)
					tick_die()
					emit_signal("shake_camera")
			
	if Input.is_action_just_pressed("dash"):
		dash = true
		motion = "dashing"
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if dash == false:
		
		var direction = Input.get_axis("left", "right")
		if paring == true:
			velocity = Vector2(0,0)
		if paring == false:
			if not is_on_floor():
				velocity.y += gravity * delta
			if direction:
			
			
				velocity.x += direction * SPEED
				if direction < 0:
					
					dir = "left"
					if is_on_floor():
						motion = "walk"

				else:
					dir = "right"
					if is_on_floor():
						motion = "walk"
					
			else:
				velocity.x += move_toward(velocity.x, 0, SPEED)
				
			
	elif dash:
		motion = "dashing"
		dashtimer.start()
		velocity.y = 0
		if dash_per < DASH_PER_M:
			if dir == "left":
				velocity.x += -4000
			elif dir == "right":
				velocity.x += 4000
			dash_per += 1
		elif dash_per >= DASH_PER_M:
			dash = false
			dash_per = 0
	if paring == true:
		motion = "paring"
	if paring_j_go == true:
		velocity = Vector2(0,0)
	move_and_slide()
	
	if motion == "idle" and motion_p != "idle":
		animation_player.play("idle")
		motion_p = "idle"
	if motion == "dashing" and motion_p != "dashing":
		animation_player.play("dashing")
		motion_p = "dashing"
	if motion == "jump" and motion_p != "jump":
		animation_player.play("jump")
		motion_p = "jump"
	if motion == "walk" and motion_p != "walk":
		animation_player.play("walk")
		motion_p = "walk"
	if motion == "paring" and motion_p != "paring":
		animation_player.play("paring")
		motion_p = "paring"
func _on_dashtimer_timeout():
	var dash_g = DASHGHOST.instantiate()
	if dir == "left":
		dash_g.g_ready(position,scale,true)
	if dir == "right":
		dash_g.g_ready(position,scale,false)
	get_tree().current_scene.add_child(dash_g)

func mob_attack(dam,mob,what):
	if dash == false:
		if paring == true:
			animation_player.play("paring_go")
			paring = false
			paring_cooldown.stop()
			audio_stream_player_2d_2.play()
			if str(what) == "boss":
				GameManage.hp -= dam
			elif what == true:
				mob.look_at(get_global_mouse_position())
				mob.par = true
				velocity = Vector2.ZERO
				return false
			elif what == false:
				mob.hp -= 10
				
		elif paring == false:
			GameManage.hp -= dam
			

	
func get_mobs(mob):
	mobs.append(mob)
	
func delete_mobs(mob):
	mobs.erase(mob)
		
func _on_paring_cooldown_timeout():
	paring = false 
	paring_timer.start()
#
func p_perfect():
	paring_jwung.texture = perfect_j
	
func p_good():
	paring_jwung.texture = good_j
	

func p_bad():
	paring_jwung.texture = bad_j
	
func p_miss():
	paring_jwung.texture = miss_j
	
func paring_done():
	paring_j_go = false
	
func tick_in():
	audio_stream_player_2d_4.play()
	#var tick_j = TICK_J.instantiate()
	#add_child(tick_j)
	#tick.append(tick_j)
	
func tick_see():
	var tick_round = TICK_ROUND.instantiate()
	control_2.add_child(tick_round)
	round.append(tick_round)
	
func tick_die():
	if round[0]:
		round[0].queue_free()
		
func ok(tick_j_s):
	if tick[0] == tick_j_s:
		return true
	else:
		return false
		
func tick_anime_go():
	tick_tick_anime.play("gun")
#func _on_area_2d_2_body_entered(body):
	#wall_run = true
	#r_wall = true
#
#
#func _on_area_2d_2_body_exited(body):
	#wall_run = false
	#r_wall = false
#
#
#func _on_area_2d_body_entered(body):
	#wall_run = true
	#l_wall = true
#
#
#
#func _on_area_2d_body_exited(body):
	#wall_run = false
	#l_wall = false











func _on_area_2d_area_entered(area: Area2D) -> void:
	if area != Line2D:
		if not "boss" in area.get_parent().get_groups():
			area.get_parent().queue_free()


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	if area != Line2D:
		if not "boss" in area.get_parent().get_groups():
			area.get_parent().queue_free()


func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area != Line2D:
		if not "boss" in area.get_parent().get_groups():
			area.get_parent().queue_free()


func _on_area_2d_4_area_entered(area: Area2D) -> void:
	if area != Line2D:
		if not "boss" in area.get_parent().get_groups():
			area.get_parent().queue_free()


func _on_area_2d_5_body_entered(body: Node2D) -> void:
	mob_attack(10,null,"trap")
	hurt.emitting = true




func _on_mouse_area_area_entered(area: Area2D) -> void:
	area_mob = area.get_parent()


func _on_mouse_area_area_exited(area: Area2D) -> void:
	area_mob = null
