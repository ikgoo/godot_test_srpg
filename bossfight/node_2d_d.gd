extends Node2D
@onready var timer: Timer = $Timer
const ICE_ATTACK = preload("res://ice_attack.tscn")
var rng = RandomNumberGenerator.new()
const LABEL = preload("res://label.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if GameManage.hp <= 0:
		get_tree().change_scene_to_file("res://label.tscn")


func _on_timer_timeout() -> void:
	rng.randomize()
	var ice_bullet = ICE_ATTACK.instantiate()
	ice_bullet.position.x = rng.randi_range(100,-2500)
	ice_bullet.position.y = -5540
	add_child(ice_bullet)
