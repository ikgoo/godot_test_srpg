extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#RenderingServer.set_default_clear_color(Color.AQUA)
	pass

# 시작 버튼
func _on_btn_start_pressed():
	pass

# 게임 방법 버튼
func _on_btn_howto_pressed():
	TransitionScene.play_exit_scene()
	await TransitionScene.PlayFinished
	get_tree().change_scene_to_file("res://Scenes/howto_scene.tscn")
	TransitionScene.play_enter_scene()

# 게임 설정 버튼
func _on_btn_config_pressed():
	TransitionScene.play_exit_scene()
	await TransitionScene.PlayFinished
	get_tree().change_scene_to_file("res://Scenes/config_scene.tscn")
	TransitionScene.play_enter_scene()
