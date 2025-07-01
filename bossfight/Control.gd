extends Control
@onready var hp = $HP
@onready var node_2d = $Node2D

var cam
var player

# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if GameManage:
		hp.text = "hp : " + str(GameManage.hp)

				
