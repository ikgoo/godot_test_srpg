extends Node2D




func _on_hurt_box_area_entered(area):
	var GrassEffect : Resource = load("res://World/grass_effect.tscn")
	var grassEffect : Node2D = GrassEffect.instantiate()
	var parentNode = get_node(".").get_parent()
	grassEffect.global_transform = global_transform
	parentNode.add_child(grassEffect)
	#world.add_child(grassEffect)
	queue_free()
