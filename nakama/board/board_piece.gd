@tool
extends Area2D

@onready var piece = $piece

var tt : int = 0

func _ready():
	tt = tt + 1
	print(tt)


func _process(delta):
	pass
