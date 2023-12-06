extends Node2D

signal merge_go(obj_name, obj_idx, pos, object1, object2)

@onready var left_wall = $LeftWall
@onready var right_wall = $RightWall
@onready var obj_start_pos = $ObjStartPos
#@onready var spawn = $Spawn
@onready var audio_stream_player_2d = $AudioStreamPlayer2D

@onready var drop_object_group = $DropObjectGroup
@onready var object_pooling = $ObjectPooling

@onready var parical_object_group = $ParicalObjectGroup
@onready var paricle_object_pooling = $ParicleObjectPooling


@onready var wait_parical_timer = $WaitParicalTimer

@onready var timer = $Timer

var currentObj
var startPos : Vector2
func _ready():
	tween = create_tween()
	timer.start(0)
	startPos = obj_start_pos.global_position

func _physics_process(delta):
	# 두개 이상의 드롭 오브젝트가 생기면 충돌 체크 시작
	var childs = drop_object_group.get_children()
	if(childs.size() >= 2):
		for i in range(0, childs.size()):
			var colliding_bodies = childs[i].get_colliding_bodies()
			for body in colliding_bodies:
				if body is DropObject and body != childs[i] and body.obj_name == childs[i].obj_name and body.is_on == true and childs[i].is_on == true:
					body.is_on = false
					childs[i].is_on = false
					
					var gg = childs[i]
					var mid = (body.global_position + gg.global_position) / 2
					#emit_signal("merge_go", body.obj_name, body.obj_idx, mid, body, childs[i])
					merge_obj(body.obj_name, body.obj_idx, mid, body, childs[i])

var _obj_name
var _obj_idx
var _pos
var _object1
var _object2
# Tweener 생성
var tween

# 두 오브젝트 머지 애니메이션
func merge_obj(obj_name, obj_idx, pos, object1 : Node2D, object2):
	_obj_name = obj_name
	_obj_idx = obj_idx
	_pos = pos
	_object1 = object1
	_object2 = object2
	object1.linear_velocity = Vector2.ZERO
	object1.gravity_scale = 0
	object1.angular_velocity = 0
	object1.get_node("./CollisionShape2D").disabled = true
	object2.linear_velocity = Vector2.ZERO
	object2.gravity_scale = 0
	object2.angular_velocity = 0
	object2.get_node("./CollisionShape2D").disabled = true
	

	# 두 개의 오브젝트를 동시에 지정된 위치로 이동
	var target_position = pos # 이동할 위치
	var duration = 0.3 # 이동에 걸릴 시간 (초)

	tween = create_tween()
	tween.parallel().tween_property(object1, "position", target_position, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.parallel().tween_property(object2, "position", target_position, duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

	# 이동이 끝나면 특정 함수를 호출
#	tween.connect("tween_callback", _on_tween_all_completed(obj_name, obj_idx, pos, object1, object2))

	# 애니메이션 시작
	await tween.finished
	object1.visible = false
	object2.visible = false

	var tmp_obj_idx = drop_collision( obj_name, obj_idx, pos, object1, object2)
	
	# 합체 후 효과
	var o : GPUParticles2D = paricle_object_pooling.get_from_pool_number(tmp_obj_idx-1)
	#parical_object_group.add_child(o)
	add_child(o)
	

	o.paticle_start(pos)
	await o.finished
	
	
	wait_parical_timer.start(2)
	await wait_parical_timer.timeout
	#parical_object_group.remove_child(o)
	remove_child(o)
	paricle_object_pooling.add_to_pool_number(0, o)
	

func _on_tween_all_completed(obj_name, obj_idx, pos, object1, object2):
	drop_collision( obj_name, obj_idx, pos, object1, object2)
	print("The animation has completed.")
	
func _process(delta):
	#audio_stream_player_2d.play()
	if currentObj != null and button_down == true:
		var mouse_position : Vector2 = get_global_mouse_position()
		var start_pos_x : float = mouse_position.x
		if start_pos_x < left_wall.global_position.x:
			start_pos_x = left_wall.global_position.x
		if start_pos_x > right_wall.global_position.x:
			start_pos_x = right_wall.global_position.x
		
		currentObj.global_position = Vector2(start_pos_x, startPos.y)
	
var button_down = false
func _input(event : InputEvent):
	if event is InputEventMouseButton:
		if currentObj != null:
			event.button_mask
			if event.button_index == MOUSE_BUTTON_LEFT:
				if event.pressed:
					if currentObj != null:
						button_down = true
				else:
					button_down = false
					var pos = currentObj.global_position
					var parent_node = currentObj.get_parent()
					parent_node.remove_child(currentObj)
					append_child_obj_proc(currentObj, pos)
					currentObj = null
					
					timer.start()

func _on_timer_timeout():
	
	var r = object_pooling.object_names[randi_range(0, object_pooling.object_names.size()-1)]
	currentObj = object_pooling.get_from_pool_name(r)
	currentObj.gravity_scale = 0
	currentObj.is_on = false
	add_child(currentObj)
	#obj_start_pos.add_child(currentObj)
	currentObj.global_position = startPos

func drop_collision(obj_name, obj_idx, pos, obj, obj2):
	object_pooling.add_to_pool_name(obj.obj_name, obj)
	remove_child_proc(obj)
	object_pooling.add_to_pool_name(obj2.obj_name, obj2)
	remove_child_proc(obj2)
	
	# 최대 이상으로 되지 않음
	var s = object_pooling.object_names.size() 
	if s > obj_idx+1:
		obj_idx = obj_idx + 1
	
	append_child_number_proc(obj_idx, pos)
	
	return obj_idx
	
func append_child_number_proc(obj_idx : int, pos):
	var currentObj_new : DropObject = object_pooling.get_from_pool_number(obj_idx)
	append_child_obj_proc(currentObj_new, pos)
	
func append_child_obj_proc(obj : DropObject, pos):
	obj.show()
	drop_object_group.add_child(obj)
	obj.global_position = pos
#	obj.call_deferred("is_on", true)
#	obj.call_deferred("gravity_scale", 1)
#	obj.get_node("./CollisionShape2D").call_deferred("disabled", false)
	obj.is_on = true
	obj.gravity_scale = 1
	obj.get_node("./CollisionShape2D").disabled = false
	

func remove_child_proc(obj : DropObject):
	obj.hide()
	obj.is_on = false
	obj.gravity_scale = 0
	drop_object_group.remove_child(obj)
	
	
	
