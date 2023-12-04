extends Node2D

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var obj_start_pos = $ObjStartPos
@onready var spawn = $Spawn
@onready var audio_stream_player_2d = $AudioStreamPlayer2D
@onready var object_pooling = $ObjectPooling

@onready var timer = $Timer

var currentObj

# 떨어트릴수 있는 오프젝트
var obj_list = ['pineapple', 'pineapple', 'apple']

func _ready():
	timer.start(0)


func _process(delta):
	audio_stream_player_2d.play()
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
	var r = obj_list[randi_range(0, obj_list.size()-1)]
	
	currentObj = object_pooling.get_from_pool_name(r)
	
	currentObj.connect("drop_collision", drop_collision)
	currentObj.connect
	currentObj.gravity_scale = 0
	obj_start_pos.add_child(currentObj)

func drop_collision(obj_name, obj_idx, pos, obj, obj2):
	obj.is_on = true
	object_pooling.add_to_pool_name(obj_name, obj)
	obj2.is_on = true
	object_pooling.add_to_pool_name(obj_name, obj2)
	
	# 최대 이상으로 되지 않음
	if obj_list.size()-1 > obj_idx:
		obj_idx = obj_idx + 1
	
	var currentObj_new = object_pooling.get_from_pool_number(obj_idx)
	currentObj_new.global_position = pos
	add_child(currentObj_new)
