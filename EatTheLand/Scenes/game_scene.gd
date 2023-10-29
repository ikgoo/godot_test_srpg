extends Node2D

@export var player_speed = 100

@onready var player = $Player

@onready var draw_line = $DrawLine
@onready var line_collision = $LineCollision


var path = PackedVector2Array()  # 플레이어의 경로를 저장합니다.
var last_path = Vector2.ZERO

func _process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var tmpPosition = player.global_position +  (direction * player_speed * delta)

	tmpPosition.x = clamp(tmpPosition.x, 0, get_viewport_rect().size.x)
	tmpPosition.y = clamp(tmpPosition.y, 0, get_viewport_rect().size.y)

	if(last_path != tmpPosition && line_collision.addLine(tmpPosition)):
		player.global_position = tmpPosition
		path.append(player.global_position)  # 플레이어의 현재 위치를 경로에 추가합니다.
#		collision_polygon_2d.polygon.append(player.global_position)
		draw_line.points = path




func _on_area_2d_area_entered(area):
	print('충돌')
