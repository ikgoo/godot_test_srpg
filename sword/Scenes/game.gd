extends Node2D


@onready var sprite_2d = $Sprite2D
@onready var area_2d = $Sprite2D/Area2D

var tter : PhysicsPointQueryParameters2D = PhysicsPointQueryParameters2D.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	tter.collide_with_areas = true
	tter.collide_with_bodies = false
#	tter.collision_mask = 1
#	tter.exclude = []
	

	pass # Replace with function body.

var i = 0
func _physics_process(delta):
	var space = get_world_2d().direct_space_state
	var mousePos = get_global_mouse_position()
	var collision_mask = area_2d.collision_layer # 충돌 레이어 1만 검사
	tter.position = mousePos
	tter.collision_mask = collision_mask
	
	var ss = space.intersect_point(tter)
	if ss:
		for n in ss:
			var dd : Area2D = n.collider
			var pp : ssss = dd.get_parent()
			pp.ttt
			var iii = 0
		i += 1
		print("true" + str(i))

