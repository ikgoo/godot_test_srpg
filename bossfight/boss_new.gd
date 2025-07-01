extends Node2D
@onready var attack_timer: Timer = $attack_timer
@onready var ice: Timer = $ice
var hp = 100
var random_number
var ice1
var ice2
var ice3
var ice4
var pattern = 0
@onready var health_bar: ProgressBar = $health_bar
const FIRE_ATTACK = preload("res://fire_attack.tscn")
const ICE_ATTACK = preload("res://ice_attack.tscn")

@onready var wind_t: Timer = $wind_t
@onready var wind: Node2D = $wind

@onready var marker_2d_1: Marker2D = $Marker2D
@onready var marker_2d_2: Marker2D = $Marker2D2
@onready var marker_2d_3: Marker2D = $Marker2D3
@onready var marker_2d_4: Marker2D = $Marker2D4

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attack_timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_attack_timer_timeout() -> void:
	if pattern == 0:
		falling_attack()
		pattern += 1
	if pattern == 1:
		wind_attack()
		pattern = 0
func falling_attack():
	random_number = randi() % 2
	if random_number == 1:
		ice2 = FIRE_ATTACK.instantiate()
	else:
		ice2 = ICE_ATTACK.instantiate()
	random_number = randi() % 2
	if random_number == 1:
		ice3 = FIRE_ATTACK.instantiate()
	else:
		ice3 = ICE_ATTACK.instantiate()

	add_child(ice2)
	add_child(ice3)

	ice2.global_scale = Vector2(2,2)
	ice3.global_scale = Vector2(2,2)

	ice2.global_position = marker_2d_2.global_position
	ice3.global_position = marker_2d_3.global_position
	ice.start()

func wind_attack():
	wind.visible = true
	wind_t.start()
	
func _on_ice_timeout() -> void:
	random_number = randi() % 2
	if random_number == 1:
		ice1 = FIRE_ATTACK.instantiate()
	else:
		ice1 = ICE_ATTACK.instantiate()
		
	random_number = randi() % 2
	if random_number == 1:
		ice4 = FIRE_ATTACK.instantiate()
	else:
		ice4 = ICE_ATTACK.instantiate()
	add_child(ice1)
	add_child(ice4)
	
	ice1.global_scale = Vector2(2,2)
	ice4.global_scale = Vector2(2,2)
	
	ice1.global_position = marker_2d_1.global_position
	ice4.global_position = marker_2d_4.global_position
	
func set_health_go():
	health_bar._set_health(hp)


func _on_wind_timeout() -> void:
	wind.visible = false
	attack_timer.start()
