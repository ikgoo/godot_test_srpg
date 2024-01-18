extends Control

@onready var black_rall = $NinePatchRect/BlackRall
@onready var white_rall = $NinePatchRect/WhiteRall
@onready var animation_player = $AnimationPlayer


func PlayMainMenu(playNmae):
	animation_player.play(playNmae)
