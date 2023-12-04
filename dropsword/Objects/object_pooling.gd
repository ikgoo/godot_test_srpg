extends Node2D

@export var objects : Array[PackedScene]
@export var pool_size : Array[int]

# 오브젝트 관리 배열
# [String, Array[Node2D]]
var object_pools : Dictionary = {}
# 오브젝트 이름 관리
var object_names : Array[String]

# Called when the node enters the scene tree for the first time.
func _ready():
	# objects 객체 수만큼 반복하여 object의 name으로 하위 node2d를 만들어 object를 쌓는다
	for i in range(0, objects.size()):
		for j in range(0, pool_size[i]):
			var o : PackedScene = objects[i]
			var object = o.instantiate()
			
			# 하위 노드 생성
			var node_name = object.name
			if !object_pools.has(node_name):
				var n : Array[Node2D] = []
				object_pools[node_name] = n
			
			var new_node = Node2D.new()
			new_node.name = node_name
			object_names.append(node_name)
			add_to_pool_name(node_name, object)
			
			#if !has_node("./" + node_name):
				#add_child(new_node)
				#
			#add_child(object)
			#add_to_pool(i, object)

# 오브젝트 되돌림(number)
func add_to_pool_number(idx : int, object : Node2D):
	add_to_pool_name(object_names[idx], object)
	
# 오브젝트 되돌림(name)
func add_to_pool_name(name : String, object : Node2D):
	object.visible = false
	object_pools[name].append(object)

# 오브젝트 풀에서 오브젝트를 가져오는 함수
func get_from_pool_number(idx : int):
	return get_from_pool_name(object_names[idx])

# 오브젝트 풀에서 오브젝트를 가져오는 함수
func get_from_pool_name(name : String):
	if object_pools[name].size() > 0:
		var object = object_pools[name].pop_front()
		object.visible = true
		return object
	else:
		return null
