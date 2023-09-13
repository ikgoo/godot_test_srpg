extends Node2D


var GrassEffect : Resource = preload("res://World/grass_effect.tscn")

func _on_hurt_box_area_entered(area):
	var grassEffect : Node2D = GrassEffect.instantiate()
	get_parent().add_child(grassEffect)
	grassEffect.global_position = global_position
	queue_free()
