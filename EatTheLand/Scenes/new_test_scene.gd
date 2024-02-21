extends Node2D

const GRID_SIZE = 32 # 그리드 크기
var grid_width = 10 # 그리드 너비
var grid_height = 10 # 그리드 높이
var player_position = Vector2(10, 10) # 플레이어 위치
#var player_path = PoolVector2Array() # 플레이어가 이동한 경로
var player_inline_list = [] # 플레이어가 이동 가능한 라인 배열

@onready var sprite_2d = $Sprite2D

func _ready():
	var padding = 10
	player_inline_list.append(Vector2(padding, padding))
	player_inline_list.append(Vector2(get_viewport_rect().size.x-padding, padding))
	player_inline_list.append(Vector2(get_viewport_rect().size.x-padding, get_viewport_rect().size.y-padding))
	player_inline_list.append(Vector2(padding, get_viewport_rect().size.y-padding))
	player_inline_list.append(Vector2(padding, padding))
	sprite_2d.global_position = player_position


func _draw():
	draw_grid()

func _process(delta):
	# 플레이어의 키 입력 처리
	var movement = Vector2.ZERO
	if Input.is_action_pressed("ui_right"):
		movement.x += 1
	if Input.is_action_pressed("ui_left"):
		movement.x -= 1
	if Input.is_action_pressed("ui_down"):
		movement.y += 1
	if Input.is_action_pressed("ui_up"):
		movement.y -= 1
	
	# 플레이어의 위치 보정
	if movement == Vector2.ZERO:
		return
		
	player_position = get_closest_position_to_border(movement)
	sprite_2d.global_position = player_position

func draw_grid():
	for idx in len(player_inline_list):
		if idx + 1 == len(player_inline_list):
			break
			
		draw_line(Vector2(player_inline_list[idx].x, player_inline_list[idx].y), Vector2(player_inline_list[idx+1].x, player_inline_list[idx+1].y), Color.WHITE)

func get_closest_position_to_border(movement):
	var closest_position = position

	for i in range(player_inline_list.size() - 1):
		var line1 = player_inline_list[i]
		var line2 = player_inline_list[i + 1]
		
		position = is_between_lines(movement, line1, line2)
		if position != null:
			# 플레이어의 위치가 두 라인 사이에 있으면 해당 라인으로 보정
			var dist_to_line1 = abs(position.y - line1.y)
			var dist_to_line2 = abs(position.y - line2.y)
			
			if dist_to_line1 < dist_to_line2:
				closest_position = line1
			else:
				closest_position = line2
				
			break

	return closest_position

func is_between_lines(movement, line1, line2):
	var x1
	var y1
	
	var min_x = min(line1.x, line2.x)
	var max_x = max(line1.x, line2.x)
	var min_y = min(line1.y, line2.y)
	var max_y = max(line1.y, line2.y)
	
	if movement.x > 0:
		# 오른쪽 이동
		 x1 = movement.x
		
		pass
	elif movement.x < 0:
		# 왼쪽 이동
		pass
	elif movement.y > 0:
		# 위쪽 이동
		pass
	elif movement.y < 0:
		# 아래쪽 이동
		pass
		
	if point.y < min_y or point.y > max_y:
		return false
	
	if point.x < min_x or point.x > max_x:
		return false
	
	return true
