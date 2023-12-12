extends Node2D

@onready var camera_2d = $Camera2D
@onready var player : Player = $Player
@onready var timer = $Timer

var player_spawn_location = Vector2.ZERO
const playerScene = preload("res://playerBlueSkin.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player.connect_camera(camera_2d)
	player_spawn_location = player.global_position
	
	Events.connect("play_die", _on_player_die)
	Events.connect("hit_checkpoint", _on_checkpoint)

func _on_player_die():
	timer.start(1.0)
	await  timer.timeout
	var player_scene = playerScene.instantiate()
	player_scene.global_position = player_spawn_location
	add_child(player_scene)
	player_scene.connect_camera(camera_2d)

func _on_checkpoint(position):
	player_spawn_location = position
