extends Node2D


func _ready():
	pass # Replace with function body.


func _process(delta):
	if Input.is_action_pressed("Attack"):
		var GrassEffect = load("res://World/grass_effect.tscn")
		var grassEffect = GrassEffect.instance()
		var world = get_tree().current_scene
		world.add_child(grassEffect)
		queue_free()
