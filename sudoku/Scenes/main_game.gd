# https://github.com/kairess/mnist_sudoku_generator/blob/master/Generator.py
# https://fclipse.tistory.com/26
# https://semtax.tistory.com/50
extends Node

var board_size = 9
var board = []

func _ready():
	initialize_board()
	if fill_board(0, 0):
		print_board()
	else:
		print("Failed to solve the Sudoku")

func initialize_board():
	board = []
	for i in range(board_size):
		board.append([0] * board_size) # 9x9 보드를 0으로 초기화

func fill_board(row, col):
	if col == board_size: # 열의 끝에 도달했다면 다음 행으로 넘어갑니다.
		col = 0
		row += 1
		if row == board_size: # 모든 칸이 채워졌다면 완료입니다.
			return true
	
	if board[row][col] == 0: # 현재 칸이 비어 있다면
		for num in range(1, board_size + 1): # 1부터 9까지 시도합니다.
			if is_safe(row, col, num): # 규칙에 맞는지 확인합니다.
				board[row][col] = num
				if fill_board(row, col + 1): # 다음 칸으로 넘어갑니다.
					return true
				board[row][col] = 0 # 백트래킹: 실패했다면 다시 0으로 설정합니다.
	else: # 이미 숫자가 있는 경우 다음 칸으로 넘어갑니다.
		return fill_board(row, col + 1)
	
	return false # 해결할 수 없는 경우

func is_safe(row, col, num):
	# 같은 행, 열, 3x3 그리드에 같은 숫자가 없는지 확인합니다.
	for x in range(board_size):
		if board[row][x] == num or board[x][col] == num:
			return false
	
	var start_row = (row / 3) * 3
	var start_col = (col / 3) * 3
	for i in range(3):
		for j in range(3):
			if board[i + start_row][j + start_col] == num:
				return false
	return true

func print_board():
	for i in range(board_size):
		var line = ""
		for j in range(board_size):
			line += str(board[i][j]) + " "
		print(line)
