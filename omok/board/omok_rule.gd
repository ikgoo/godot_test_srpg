extends Node
class_name OmokRule

var BOARD_SIZE = 19
var rallMap: Array


# 게임내 있는지 체크
func is_in_bounds(x, y):
	return x >= 0 and y >= 0 and x < BOARD_SIZE and y < BOARD_SIZE

# 위치에 없는지 체크
func is_empty_or_border(x, y):
	return not is_in_bounds(x, y) or rallMap[x][y] == 0

# 현재 위치에 해당 방향으로 돌이 몇개인지 확인
func count_stones(x, y, dir, player):
	var count = 0
	var check_x = x
	var check_y = y

	while is_in_bounds(check_x, check_y) and rallMap[check_x][check_y] == player:
		count += 1
		check_x += dir.x
		check_y += dir.y

	return count

# 승리체크
func check_victory(x, y, player):
	for dir in [Vector2(1, 0), Vector2(0, 1), Vector2(1, 1), Vector2(1, -1)]:
		var cnt1 = count_stones(x, y, dir, player)
		var cnt2 = count_stones(x, y, -dir, player)
		if cnt1 + cnt2 - 1 == 5:
			return true
	
	return false


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

# 방향
var dirs = [Vector2(1,0), Vector2(0,1), Vector2(1, 1), Vector2(1, -1)]

# 진행 방향과 역방향 합 계산 함수
# count_dol(돌수), count_space(공백수), count_colse(끝에 다른 플레이어나 보드 끝의 수), x, y
func count_stones_with_one_space(x, y, player):
	var counts_2 = []
	var counts_3 = []
	var counts_5 = []
	
	var count_dol
	var count_space
	var count_colse
	var dx
	var dy
	for dir in dirs:
		count_dol = 0
		count_space = 0
		count_colse = 0
		for i in range(2):
			var d = 1 if i == 0 else -1		# 0인 경우는 무시됨(역방향을 위함)
			var mdx = (dir.x * d)
			var mdy = (dir.y * d)
			dx = x
			dy = y
			while true:
				dx = dx + mdx
				dy = dy + mdy
				
				if is_in_bounds(dx, dy):		# 보드에서 벗어낫는지 체크
					if is_empty_or_border(dx, dy):		# 공백의 경우 처리
						# 한칸 진행을 더해서 같은 player돌인경우 space++, 한개만 인정
						if is_in_bounds(dx+mdx, dy+mdy) and rallMap[dx+mdx][dy+mdy] == player and count_space == 0:	
							count_space = count_space + 1
							
						# 한칸 진행을 했어도 공백이면 pass
						elif is_empty_or_border(dx+mdx, dy+mdy):
							break
					
					# 같은 플레이어면 진행
					elif rallMap[dx][dy] == player:
						count_dol = count_dol + 1
						
					# 다른 플레이어가 있으면 close카운팅 후 pass
					elif rallMap[dx][dy] != 0 and rallMap[dx][dy] != player:
						count_colse = count_colse + 1
						break
					
				else:	# 보드를 벗어나면 close 카운팅 후 pass
					count_colse = count_colse + 1
					break
		
		if count_dol > 1:
			counts_2
			if count_dol == 2 and count_colse == 0:	#3.3용
				counts_2.append({
					'count_dol': count_dol,
					'count_space': count_space,
					'count_colse': count_colse,
				})
			elif count_dol == 3 and count_colse < 2:	# 4.4용
				counts_3.append({
					'count_dol': count_dol,
					'count_space': count_space,
					'count_colse': count_colse,
				})
			elif count_dol >= 5: # 6이상
				counts_5.append({
					'count_dol': count_dol,
					'count_space': count_space,
					'count_colse': count_colse,
				})
		
	if len(counts_5) > 0:
		return 2
	elif len(counts_3) > 1:
		return 1
	elif len(counts_2) > 1:
		return 0
	else:
		return null

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
			var test_datas = count_stones_with_one_space(x, y, player)
			if test_datas != null:
				var tmp = Vector3(x, y, test_datas)
				forbidden_positions.append(tmp)
				
			#if rallMap[x][y] == -1 and (check_three_three(x, y, player) or check_four_four(x, y, player)):
				#forbidden_positions.append(Vector2(x, y))
			#if rallMap[x][y] == player:
				#var xy : Array = check_overline(x, y, player)
				#if xy.size() != 0:
					#forbidden_positions.append(Vector2(xy[0], xy[1]))

	return forbidden_positions


