extends Node2D
class_name GameBoard

signal PlayerWin
signal PlayerNextTurn
signal BoardPieceClick

@onready var omok_rule: OmokRule = $OmokRule

var TscnRall: PackedScene = preload("res://board/rall.tscn")
var TscnBoardPiece : PackedScene = preload("res://board/board_piece.tscn")

var ralldrop01 = preload("res://assets/Sounds/ralldrop01.mp3")
var ralldrop02 = preload("res://assets/Sounds/ralldrop02.mp3")
var ralldrop03 = preload("res://assets/Sounds/ralldrop03.mp3")
var ralldrops = [ralldrop01, ralldrop02, ralldrop03]

var currentInspacterPos
var impossibleRall: Array = []		# 금수 위치 값

@onready var board_start_pos = $BoardStartPos
@onready var inspacter = $Inspacter
@onready var impossible_rall = $ImpossibleRall


var base_size = 37

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
	ChanchInspacter(false)
	inspacter.play()

func BoardRender():
	for row in range(len(board)) :
		for col in range(len(board[row])):
			
			var tmpBoardPiece : BoardPiece = TscnBoardPiece.instantiate()
			board_start_pos.add_child(tmpBoardPiece)
			tmpBoardPiece.SetBoardPosition(row, col)
			tmpBoardPiece.pieceType = board[row][col]
			tmpBoardPiece.position = Vector2(col * base_size, row * base_size)
			#tmpBoardPiece.connect("PieceOver", onPieceOver)
			tmpBoardPiece.connect("PieceClick", onPieceClick)

func ChanchInspacter(b):
	if b:
		inspacter.show()
	else:
		inspacter.hide()

#func onPieceOver(boardPosition):
	##print(boardPosition)
	#currentYX = boardPosition
	#var xpos = board_start_pos.position.x + (boardPosition[1] * base_size) + (base_size/2)
	#var ypos = board_start_pos.position.y + (boardPosition[0] * base_size) + (base_size/2)
	#inspacter.position = Vector2(xpos, ypos)

# 좌표 클릭시
func onPieceClick(boardPosition):
	if MainData.currentGameState == MainData.GameState.PLAY:
		# 금수 위치를 선택했는지 확인
		for p in impossibleRall:
			if p.x == boardPosition[0] and p.y == boardPosition[1]:
				return false
		
		
		var xpos = board_start_pos.position.x + (boardPosition[1] * base_size) + (base_size/2)
		var ypos = board_start_pos.position.y + (boardPosition[0] * base_size) + (base_size/2)
		ChanchInspacter(true)
		inspacter.position = Vector2(xpos, ypos)
		currentInspacterPos = boardPosition
		
		emit_signal("BoardPieceClick")
		
# 착수 버튼 클릭시
func onCommitclick():
	ChanchInspacter(false)
	if MainData.currentGameState == MainData.GameState.PLAY:
		var boardPosition = currentInspacterPos
		# 이미 돌이 있는 경우
		if rallMap[boardPosition[0]][boardPosition[1]] != -1:
			return
		
		## 규칙 위반 체크(쌍삼, 쌍사)
		#var is_validity = check_validity(boardPosition[1], boardPosition[0], MainData.currentTrue, rallMap)
		
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
		
		if omok_rule.check_victory(boardPosition[0], boardPosition[1], MainData.currentTrue):		# 승리 체크
			emit_signal("PlayerWin")
		else:				# 다음턴
			emit_signal("PlayerNextTurn")


# 금수 체크하여 화면에 표시
func CheckRule():
	for child in impossible_rall.get_children():
		impossible_rall.remove_child(child)
		child.queue_free() # 메모리에서 해제	
		
	omok_rule.rallMap = rallMap
	
	# 기존에 금수 표현한 노트 제거
	
	# 금수 체크해서 노트에 표시
	impossibleRall = omok_rule.find_forbidden_positions(MainData.currentTrue)
	if impossibleRall.size() > 0:
		print(impossibleRall)
		for tmpBoardPos in impossibleRall:
			var tmpRall = TscnRall.instantiate()
			impossible_rall.add_child(tmpRall)
			var xpos = board_start_pos.position.x + (tmpBoardPos[1] * base_size) + (base_size/2)
			var ypos = board_start_pos.position.y + (tmpBoardPos[0] * base_size) + (base_size/2)
			tmpRall.position = Vector2(xpos, ypos)
			tmpRall.frame = 2
	


# ==============================================


