extends CanvasLayer

signal PlayFinished()

@onready var animation_player = $AnimationPlayer


func play_exit_scene():
	animation_player.play("ExitScene")
	
func play_enter_scene():
	animation_player.play("EnterScene")


func _on_animation_player_animation_finished(anim_name):
	emit_signal("PlayFinished")
