extends Node2D

@onready var camera_2d = $Camera2D
@onready var player : Player = $Player


func _ready():
	RenderingServer.set_default_clear_color(Color.LIGHT_BLUE)
	player.connect_camera(camera_2d)

