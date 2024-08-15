extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	ghosting()

func ghosting():
	var tween = get_tree().create_tween()
	
	tween.tween_property(self,"self_modulate",Color(1,1,1,0),0.5)
	
	await tween.finished
	
	queue_free()
func g_ready(g_pos,g_scale):
	position = g_pos
	scale = g_scale
