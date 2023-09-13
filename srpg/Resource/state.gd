extends Node

@export var max_health : int = 1
@onready var health : int = max_health : set = set_health

signal no_health

func set_health(value):
	health = value
	if health <= 0:
		emit_signal('no_health')
	


