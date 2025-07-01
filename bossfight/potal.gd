extends Node2D
@onready var animation_player: AnimationPlayer = $CanvasLayer/screen_change/AnimationPlayer
@export_file("*.tscn") var scene_path : String
var start = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if start == 0:
		animation_player.play("start")
		start = 1


func _on_area_2d_area_entered(area: Area2D) -> void:
	animation_player.play("change")
	
func change():
	get_tree().change_scene_to_file(scene_path)
