extends Node2D
@onready var player: CharacterBody2D = $"../player"
var my_p = null
@onready var timer: Timer = $Timer
var fly_a = null
const ATTACK_FLY = preload("res://attack_fly.tscn")
@onready var marker_2d: Marker2D = $"../Marker2D"
@onready var marker_2d_2: Marker2D = $"../Marker2D2"
@onready var line_2d: Line2D = $Line2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if player: 
		look_at(player.position)
		line_2d.visible = true


func _on_timer_timeout() -> void:
	fly_a = ATTACK_FLY.instantiate()
	fly_a.rotation += rotation
	if my_p == 0:
		fly_a .position = marker_2d.position
	elif my_p == 1:
		fly_a.position = marker_2d_2.position
	print(str(fly_a.position) + "DDJJSDFHJSFDJKSFDJK")
	get_parent().add_child(fly_a)
	queue_free()
