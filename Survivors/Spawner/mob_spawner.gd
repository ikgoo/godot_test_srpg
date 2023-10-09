extends Node2D

@export var player : CharacterBody2D
@export var camera : Camera2D

var mob_list : Dictionary = {
	"eye" : {
		"isBoss" : false,
		"obj" : preload("res://Entity/Mob/mob_eye.tscn"),
	},
	"goblin" : {
		"isBoss" : false,
		"obj" : preload("res://Entity/Mob/mob_goblin.tscn"),
	},
	"slime" : {
		"isBoss" : false,
		"obj" : preload("res://Entity/Mob/mob_slime.tscn"),
	},
}

# 스폰 방향
var spawnerDirection : Array = ["TOP", "LEFT", "RIGHT", "BOTTOM"]
var spawnPoint : Vector2 = Vector2.ZERO

var mob_keys : Array = []
var mob_count : int = 0

func _ready():
	randomize()
	
	mob_keys = mob_list.keys()
	mob_count = mob_keys.size()

func RunSpawner(mob_name : String):
	
	var ins = mob_list[mob_name]["obj"].instantiate()

	# 카메라의 위치와 크기를 얻습니다.
	var camera_pos = camera.get_global_position()
	var camera_size = camera.get_viewport_rect().size


	var spawnerDir = randi_range(0, spawnerDirection.size()-1)
	match spawnerDirection[spawnerDir]:
		"TOP":
			spawnPoint.x = randi_range(camera_pos.x, camera_pos.x + camera_size.x)
			spawnPoint.y = randi_range(camera_pos.y - camera_size.y / 4 - 100, camera_pos.y - 100)
		"LEFT":
			spawnPoint.x = randi_range(camera_pos.x - camera_size.x / 4 - 100, camera_pos.x - 100)
			spawnPoint.y = randi_range(camera_pos.y, camera_pos.y - camera_size.y)
		"RIGHT":
			spawnPoint.x = randi_range(camera_pos.x + camera_size.x + 100, camera_pos.x + camera_size.x + (camera_size.x / 4) + 100)
			spawnPoint.y = randi_range(camera_pos.y, camera_pos.y - camera_size.y)
		"BOTTOM":
			spawnPoint.x = randi_range(camera_pos.x, camera_pos.x + camera_size.x)
			spawnPoint.y = randi_range(camera_pos.y + camera_size.y + 100, camera_pos.y + camera_size.y + (camera_size.y / 4) + 100)
		
	
	ins.global_position = spawnPoint
	ins.spawn(player)
	get_tree().current_scene.add_child(ins)

func _on_timer_timeout() -> void:
	var pick_number = randi_range(0, mob_count-1)
	RunSpawner(mob_keys[pick_number])
