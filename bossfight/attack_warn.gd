extends Node2D
@onready var warn_time: Timer = $warn_time
@onready var player: CharacterBody2D = $"../../player"
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D
const BOSS_ATTACK = preload("res://boss_attack.tscn")
var attack = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	warn_time.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_warn_time_timeout() -> void:
	attack = BOSS_ATTACK.instantiate()
	get_parent().add_child(attack)
	attack.global_position = global_position
	audio_stream_player_2d.playing = true
	modulate = Color(0,0,0,0)
	await audio_stream_player_2d.finished
	queue_free()
