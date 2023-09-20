extends Node2D

@export var backMusicList : Array[AudioStream]

@onready var http_request = $HTTPRequest
@onready var find_group = $FindGroup
@onready var random_audio_player = $RandomAudioPlayer


## Called when the node enters the scene tree for the first time.
func _ready():
	find_group.connect("StageEnd", StageEnd)
	randomize()
	random_audio_player.stream = backMusicList[randi_range(0, backMusicList.size()-1)]
	random_audio_player.play()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_texture_rect_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		pass # Replace with function body.


func StageEnd():
	get_tree().change_scene_to_file("res://Scenes/select_image.tscn")
