extends Node2D
@onready var timer: Timer = $Timer
@onready var player: CharacterBody2D = $"../player"
@onready var player_follow: Timer = $player_follow
@onready var player_fly: Timer = $player_fly
var pattern = 3
const ATTACK_WARN = preload("res://attack_warn.tscn")
const FlyWarn = preload("res://fly_warn.tscn")
var attack_warn_i = null
var player_f_n
var player_fly_a = null
var player_fly_n = 0
var fly_n = 0
var doljin_await = false
var dolgin_p = false
var dolgin_line = true
var hp = 10
@onready var marker_2d: Marker2D = $"../Marker2D"
@onready var marker_2d_2: Marker2D = $"../Marker2D2"
@onready var line_2d: Line2D = $Line2D
@onready var doljintimer: Timer = $doljintimer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(hp)
	print(position)
	
	if dolgin_line:
		if player:
			line_2d.global_position.y = player.global_position.y
	if dolgin_p == true:
		position.x -= 5000 * delta
		if doljin_await == true:
			dolgin_p = false

func random_boss_phase():
	if pattern == 1:
		player_f_n = 0
		player_following_a()
	if pattern == 2:
		fly_n = 0
		player_udo()
	if pattern == 3:
		dolgin_p = false
		doljin_await = false
		linehart()

func _on_timer_timeout() -> void:
	random_boss_phase()
	
func player_following_a():
	attack_warn_i = ATTACK_WARN.instantiate()
	add_child(attack_warn_i)
	attack_warn_i.global_position = player.global_position
	player_follow.start()
func _on_player_follow_timeout() -> void:
	if player_f_n < 8:
		player_following_a()
		player_f_n += 1
	else:
		timer.start()
		pattern = 2

func player_udo():
	if fly_n < 5:
		player_fly_a = FlyWarn.instantiate()
		if player_fly_n == 0:
			player_fly_a.position = marker_2d.position
			player_fly_n = 1
			player_fly_a.my_p = 0
		elif player_fly_n == 1:
			player_fly_a.position = marker_2d_2.position
			player_fly_n = 0
			player_fly_a.my_p = 1
		get_parent().add_child(player_fly_a)
		player_fly.start()
	else:
		timer.start()
		pattern = 3


func _on_player_fly_timeout() -> void:
	fly_n += 1
	player_udo()
	
func linehart():
	line_2d.visible = true
	dolgin_line = false
	doljintimer.start()

func _on_doljintimer_timeout() -> void:
	position.x = 975
	global_position.y = line_2d.global_position.y
	line_2d.global_position.y = global_position.y
	line_2d.visible = false
	dolgin_p = true
	await doljin_await == false
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	doljin_await = true
	line_2d.visible = false
	position = Vector2(600,322)
	dolgin_line = true
	timer.start()
	pattern = 1


func _on_area_2d_2_area_entered(area: Area2D) -> void:
	area.get_parent().mob_attack(20,self,"boss")


func _on_area_2d_3_area_entered(area: Area2D) -> void:
	if area.get_parent().player_t == true:
		hp -= 1
		area.get_parent().queue_free()

#func fall_attack():
	#rng.randomize()
	#position.x = int(randi(266,951))
