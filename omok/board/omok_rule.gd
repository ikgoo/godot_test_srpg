extends Node
class_name OmokRule

var BOARD_SIZE = 19
var rallMap: Array

# 승리체크
func check_victory(x, y, player):
	for dir in [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, -1)]:
		var cnt1 = count_stones(x, y, dir, player)
		var cnt2 = count_stones(x, y, -dir, player)
		if cnt1 + cnt2 - 1 == 5:
			return true
	
	return false

func count_stones(x, y, dir, player):
	var count = 0
	var check_x = x
	var check_y = y

	while is_in_bounds(check_x, check_y) and rallMap[check_x][check_y] == player:
		count += 1
		check_x += dir.x
		check_y += dir.y

	return count

func check_three_three(x, y, player):
	return count_open_sequences(x, y, player, 3) >= 2

func check_four_four(x, y, player):
	return count_open_sequences(x, y, player, 4) >= 2

func count_open_sequences(x, y, player, sequence_length):
	var count = 0
	for dir in [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, -1)]:
		if is_open_sequence(x+dir.x, y+dir.y, dir, player, sequence_length):
			count += 1
	return count

func is_open_sequence(x, y, dir, player, sequence_length):
	var open_start = is_empty_or_border(x - dir.x, y - dir.y)

	var empty_count = 0
	var ral_count = 0
	var check_x = x
	var check_y = y
	for i in range(sequence_length):
		check_x = x + dir.x * i
		check_y = y + dir.y * i
		if not is_in_bounds(check_x, check_y) or (rallMap[check_x][check_y] != player and rallMap[check_x][check_y] != -1):
			return false
			
		if rallMap[check_x][check_y] == player:
			ral_count = ral_count + 1
		if ral_count == sequence_length-1:
			break
			
		if rallMap[check_x][check_y] == -1:
			empty_count = empty_count + 1
		if empty_count > 1:
			return false

	var open_end = is_empty_or_border(check_x + dir.x, check_y + dir.y)

	return open_start and open_end

func is_in_bounds(x, y):
	return x >= 0 and y >= 0 and x < BOARD_SIZE and y < BOARD_SIZE

func is_empty_or_border(x, y):
	return not is_in_bounds(x, y) or rallMap[x][y] == -1

func check_overline(x, y, player):
	for dir in [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, -1)]:
		var xy : Array = is_overline(x, y, dir, player)
		if xy:
			return xy
	return []

func is_overline(x, y, dir, player):
	var empty_count = 0
	var empty_xy : Array = []
	var ral_count = 0
	var count = 0
	for i in range(6):  # 6목 이상 체크
		var check_x = x + dir.x * i
		var check_y = y + dir.y * i
		if not is_in_bounds(check_x, check_y) or (rallMap[check_x][check_y] != player and rallMap[check_x][check_y] != -1):
			break
		if rallMap[check_x][check_y] == player:
			ral_count = ral_count + 1
		if rallMap[check_x][check_y] == -1:
			empty_xy.append(check_x)
			empty_xy.append(check_y)
			empty_count = empty_count + 1
	#if empty_count > 0 and ral_count > 0:
		#print('empty_count:' + str(empty_count) + " / ral_count:" + str(ral_count))
	
	if empty_count == 1 and ral_count >= 5:
		return empty_xy
	else:
		return []

# 금수 체크
func find_forbidden_positions(player) -> Array:
	var forbidden_positions = []
	for x in range(BOARD_SIZE):
		for y in range(BOARD_SIZE):
			if rallMap[x][y] == -1 and (check_three_three(x, y, player) or check_four_four(x, y, player)):
				forbidden_positions.append(Vector2(x, y))
			if rallMap[x][y] == player:
				var xy : Array = check_overline(x, y, player)
				if xy.size() != 0:
					forbidden_positions.append(Vector2(xy[0], xy[1]))

	return forbidden_positions


