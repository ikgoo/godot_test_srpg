extends Node2D

var frame : int : set = SetFrame
@onready var animation_player = $AnimationPlayer


func SetFrame(value):
	frame = value
	$Rall.frame = frame
