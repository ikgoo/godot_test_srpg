extends Control



func _on_texture_rect_gui_input(event):
	SceneTransition.change_scene(SceneTransition.SceneName.MAIN, SceneTransition.TransType.Fade)
