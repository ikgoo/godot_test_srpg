extends Node2D
@onready var attack_timing: Timer = $attack_timing
const ice = preload("res://ice_bullet.tscn")
@onready var animation_player: AnimationPlayer = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animation_player.play("attack")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func ice_in():
	var bullet = ice.instantiate()
	get_parent().add_child(bullet)
	bullet.global_position = global_position
