extends Node2D
class_name GameBoard

signal PlayerWin
signal PlayerNextTurn

var TscnRall: PackedScene = preload("res://board/rall.tscn")
var TscnBoardPiece : PackedScene = preload("res://board/board_piece.tscn")

var ralldrop01 = preload("res://assets/Sounds/ralldrop01.mp3")
var ralldrop02 = preload("res://assets/Sounds/ralldrop02.mp3")
var ralldrop03 = preload("res://assets/Sounds/ralldrop03.mp3")
var ralldrops = [ralldrop01, ralldrop02, ralldrop03]


@onready var board_start_pos = $BoardStartPos
@onready var inspacter = $Inspacter

var base_size = 34

# 646 * 646
# 보드 모양
var board : Array = [
	[0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 4, 4, 4, 9, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[3, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 4, 5],
	[6, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 7, 8],
]
var currentYX = []

#알위치
var rallMap: Array = [
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
	[-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1],
]

func _ready():
	inspacter.play()

func BoardRender():
	for row in range(len(board)) :
		for col in range(len(board[row])):
			
			var tmpBoardPiece : BoardPiece = TscnBoardPiece.instantiate()
			board_start_pos.add_child(tmpBoardPiece)
			tmpBoardPiece.SetBoardPosition(row, col)
			tmpBoardPiece.pieceType = board[row][col]
			tmpBoardPiece.position = Vector2(col * base_size, row * base_size)
			tmpBoardPiece.connect("PieceOver", onPieceOver)
			tmpBoardPiece.connect("PieceClick", onPieceClick)

func ChanchInspacter(b):
	if b:
		inspacter.show()
	else:
		inspacter.hide()

func onPieceOver(boardPosition):
	#print(boardPosition)
	currentYX = boardPosition
	var xpos = board_start_pos.position.x + (boardPosition[1] * base_size) + (base_size/2)
	var ypos = board_start_pos.position.y + (boardPosition[0] * base_size) + (base_size/2)
	inspacter.position = Vector2(xpos, ypos)

func onPieceClick(boardPosition):
	if MainData.currentGameState == MainData.GameState.PLAY:
		# 이미 돌이 있는 경우
		if rallMap[boardPosition[0]][boardPosition[1]] != -1:
			return
		
		# 규칙 위반 체크(쌍삼, 쌍사)
		var is_validity = check_validity(boardPosition[1], boardPosition[0], MainData.currentTrue, rallMap)
		print("체크 : " + str(is_validity))
		
		# 승리 체크
		var is_victory = check_victory(boardPosition[1], boardPosition[0], MainData.currentTrue, rallMap)
		if is_victory:
			print("승리 : " + str(MainData.currentTrue))
		
		
		var r = randi_range(0, ralldrops.size()-1)
		
		$AudioStreamPlayer.stream = ralldrops[r]
		$AudioStreamPlayer.play()
		
		
		rallMap[boardPosition[0]][boardPosition[1]] = MainData.currentTrue

		var tmpRall = TscnRall.instantiate()
		$RallPos.add_child(tmpRall)
		var xpos = board_start_pos.position.x + (boardPosition[1] * base_size) + (base_size/2)
		var ypos = board_start_pos.position.y + (boardPosition[0] * base_size) + (base_size/2)
		tmpRall.position = Vector2(xpos, ypos)
		tmpRall.frame = MainData.currentTrue
		
		if 1 == 0:		# 승리
			emit_signal("PlayerWin")
		else:				# 다음턴
			emit_signal("PlayerNextTurn")


# 위치 확인 함수
func at(board_clone, sx, sy):
	return board_clone[sy][sx] if sx >= 0 and sy >= 0 and sx < board_clone.size() and sy < board_clone[0].size() else -1

# 범위 내 체크
func inbound(board_clone, sx, sy):
	return sx >= 0 and sy >= 0 and sx < board_clone.size() and sy < board_clone[0].size()

# 연속된 돌 체크
func check(board_clone, criterion, x, y, a, b, c, d):
	var i = 0
	var j = 0
	while at(board_clone, x + a * i, y + b * i) == criterion and inbound(board_clone, x + a * i, y + b * i):
		i += 1
	while at(board_clone, x + c * j, y + d * j) == criterion and inbound(board_clone, x + c * j, y + d * j):
		j += 1
	
	#print(str(criterion) + ':' + str(i + j - 1))
	return i + j - 1 == 5 # 5개 연속 확인
	
# 돌을 놓았을 때 이겼는지 검사
func check_victory(x: int, y: int, stone_color: int, board: Array):
	var stone_color_value = stone_color # 백돌은 0, 흑돌은 1
	var board_clone = board.duplicate()
	
	board_clone[y][x] = stone_color_value
	
	# 기준 돌
	var criterion = at(board_clone, x, y)

	# 가로, 세로, 대각선 검사
	return check(board_clone, criterion, x, y, -1, 0, 1, 0) or check(board_clone, criterion, x, y, 0, -1, 0, 1) or check(board_clone, criterion, x, y, -1, -1, 1, 1) or check(board_clone, criterion, x, y, 1, -1, -1, 1)

	
	# 금수 조건 검사
func check_validity(x: int, y: int, stone_color: int, board: Array):
	var stone_color_value = stone_color # 백돌은 0, 흑돌은 1

	var board_clone = board.duplicate()
	board_clone[y][x] = stone_color_value

	# 삼삼과 사사 체크
	var not_double_three = not check_double_n(board_clone, x, y, stone_color_value, board_clone, 3)
	var not_double_four = not check_double_n(board_clone, x, y, stone_color_value, board_clone, 4)

	return not_double_three and not_double_four


# 방향별로 열림성 검사
func traverse(board_clone, opponent, x, y, a, b):
	var i = 0
	var stuck = true
	var spaces = []
	while true:
		if at(board_clone, x + a * i, y + b * i) == -1:
			spaces.append(Vector2(x + a * i, y + b * i))
		if not inbound(board_clone, x + a * (i + 1), y + b * (i + 1)) or at(board_clone, x + a * (i + 1), y + b * (i + 1)) == opponent:
			break
		if at(board_clone, x + a * (i + 1), y + b * (i + 1)) == -1 and at(board_clone, x + a * i, y + b * i) == -1:
			stuck = false
			break
		i += 1
	var t = {"length": i, "stuck": stuck, "spaces": spaces}
	#print(t)
	return t

# 열린 N 검사
func check_open_n(board_clone, criterion, opponent, x, y, n, a, b, c, d):
	var p = traverse(board_clone, opponent, x, y, a, b)
	var q = traverse(board_clone, opponent,x , y, c, d)
	var lsum = p.length + q.length
	var csum = p.spaces.size() + q.spaces.size() - 2

	if at(board_clone, x + a * p.length, y + b * p.length) == 0 and at(board_clone, x + c * q.length, y + d * q.length) == 0:
		if lsum == n + 1 and csum == 0:
			return (check_validity(p.spaces[0].x, p.spaces[0].y, criterion, board) or
					check_validity(q.spaces[0].x, q.spaces[0].y, criterion, board))
		elif lsum == n + 2 and csum == 1 and not (p.stuck and q.stuck):
			var target = p.spaces if  p.spaces.size() > 1 else q.spaces
			return check_validity(target[1].x, target[1].y, criterion, board)
	return false

# NN 체크 (열린 N과 쌍삼, 사사 등)
func check_double_n(board_clone, x, y, stone_color_value, board, n):

	var criterion = stone_color_value
	var opponent = 1 if criterion == 0 else 0
	
	# 모든 방향 체크
	var count = 0
	count += 1 if check_open_n(board_clone, criterion, opponent, x, y, n, -1, 0, 1, 0) else 0
	count += 1 if check_open_n(board_clone, criterion, opponent, x, y, n, 0, -1, 0, 1) else 0
	count += 1 if check_open_n(board_clone, criterion, opponent, x, y, n, -1, -1, 1, 1) else 0
	count += 1 if check_open_n(board_clone, criterion, opponent, x, y, n, 1, -1, -1, 1) else 0

	return count > 1		
