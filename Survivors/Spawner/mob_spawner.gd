extends Node2D

@export var camera : Camera2D
@onready var visible_on_screen_notifier_2d = $VisibleOnScreenNotifier2D

var mob_list : Dictionary = {
	"eye" : {
		"isBoss" : false,
		"obj" : preload("res://Entity/Mob/mob_eye.tscn"),
	}
}

var mob_size = [
	Rect2(-10, -10, 10, 10),
	Rect2(-20, -20, 20, 20),
]

// 스폰 방향
var spawnerDirection : Array = ["TOP", "LEFT", "RIGHT", "BOTTOM"]

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

	# 카메라의 범위 밖에 있는 랜덤한 위치를 생성합니다.
	visible_on_screen_notifier_2d.global_position = Vector2.ZERO

	if mob_list[mob_name]["isBoss"] == true:
		visible_on_screen_notifier_2d.rect = mob_size[1]
	else:
		visible_on_screen_notifier_2d.rect = mob_size[0]
	
	var spawnerDir = randi_range(0, spawnerDirection.size()-1)
	match spawnerDirection[spawnerDir]:
		
	
	
	# 생성한 위치가 카메라의 범위 안이면 다시 생성합니다.
	while visible_on_screen_notifier_2d.global_position == Vector2.ZERO or visible_on_screen_notifier_2d.is_on_screen():
		visible_on_screen_notifier_2d.global_position.x = randi_range(camera_pos.x - camera_size.x / 2 - 100, camera_pos.x + camera_size.x / 2 + 100)
		visible_on_screen_notifier_2d.global_position.y = randi_range(camera_pos.y - camera_size.y / 2 - 100, camera_pos.y + camera_size.y / 2 + 100)
		
		print(visible_on_screen_notifier_2d.global_position)
		print(visible_on_screen_notifier_2d.is_on_screen())
		
		var ttt = 0
	
	
	ins.global_position = visible_on_screen_notifier_2d.global_position
	
	get_tree().current_scene.add_child(ins)

func _on_timer_timeout() -> void:
	var pick_number = randi_range(0, mob_count-1)
	RunSpawner(mob_keys[pick_number])
