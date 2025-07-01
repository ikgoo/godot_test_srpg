extends Node2D
var objects = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for i in objects:
		i.position.x -= 30
		


func _on_area_2d_area_entered(area: Area2D) -> void:
	objects.append(area.get_parent())
