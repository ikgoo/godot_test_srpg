extends Node2D
@onready var attack_timing: Timer = $attack_timing
const FIRE = preload("res://fire.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func fire_in():
	var bullet = FIRE.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
