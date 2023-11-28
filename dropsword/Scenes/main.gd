extends Node2D

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var obj_start_pos = $ObjStartPos
@onready var spawn = $Spawn

@onready var timer = $Timer

var currentObj

func _ready():
	timer.start(0)


func _process(delta):
	if currentObj != null:
		var mouse_position : Vector2 = get_global_mouse_position()
		var start_pos_x : float = mouse_position.x
		if start_pos_x < left_wall.global_position.x:
			start_pos_x = left_wall.global_position.x
		if start_pos_x > right_wall.global_position.x:
			start_pos_x = right_wall.global_position.x
		
		obj_start_pos.global_position = Vector2(start_pos_x, obj_start_pos.global_position.y)
	
func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if currentObj != null:
			if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
				var pos = currentObj.global_position
				var parent_node = currentObj.get_parent()
				parent_node.remove_child(currentObj)
				add_child(currentObj)
				currentObj.global_position = pos
				currentObj.gravity_scale = 1
				
				timer.start()

func _on_timer_timeout():
	currentObj = spawn.getObj(null)
	
	currentObj.connect("drop_collision", drop_collision)
	currentObj.connect
	currentObj.gravity_scale = 0
	obj_start_pos.add_child(currentObj)

func drop_collision(obj_name, obj_idx, pos, obj):
	obj.queue_free()
	var currentObj_new = spawn.getObj(obj_idx+1)
	currentObj_new.global_position = pos
	add_child(currentObj_new)
