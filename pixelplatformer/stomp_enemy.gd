extends Node2D

enum { HOVER, FALL, LAND, RISE }
var state = HOVER

@onready var start_position = global_position
@onready var timer = $Timer
@onready var ray_cast_2d = $RayCast2D

func _physics_process(delta : float):
	match state:
		HOVER: hover_state()
		FALL: fall_state(delta)
		LAND: land_state()
		RISE: rise_state(delta)

func hover_state():
	state = FALL
		
func fall_state(delta : float):
	position.y += 100 * delta
	if ray_cast_2d.is_colliding():
		var collistion_position = ray_cast_2d.get_collision_point()
		position.y = collistion_position.y
		state = LAND
		
func land_state():
	state = RISE
	
func rise_state(delta):
	position.y = move_toward(position.y, start_position.y, 10 * delta)
	if position.y == start_position.y:
		state = HOVER
	
