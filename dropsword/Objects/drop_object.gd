extends RigidBody2D

signal drop_collision(obj_name);
var fruits_upgrade = []
@export var obj_name : String = ""
@onready var spawner = preload("res://Objects/spawn.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	spawner = spawner.instantiate()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	print(body)


func _on_area_2d_area_entered(area : Area2D):
	var upgrade_fruit = spawner.upgrade(int(obj_name))
	get_parent().add_child(upgrade_fruit)
	area.queue_free()
	queue_free()
