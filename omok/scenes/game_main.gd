extends Node2D

@onready var game_board : GameBoard = $GameBoard
@onready var player_info_01: PlayerInfo = $PlayerInfo01
@onready var player_info_02: PlayerInfo = $PlayerInfo02
@onready var timer: Timer = $Timer

var player01
var player02

enum GameState {
	WAIT,
	READY,
	PLAYING,
	GAMEOVER,
}

var players: Array = []

func _ready():
	game_board.BoardRender()
	
	if MainData.is_local_game:
		if MainData.is_pvp:
			MainData.players[0] = {
				"id" : 0,
				"name": 'Player01',
			}
			MainData.players[1] = {
				"id" : 1,
				"name": 'Player02'
			}
			
			player_info_01.SetPlayerInfo(MainData.players[0])
			players.append(player_info_01)
			player_info_02.SetPlayerInfo(MainData.players[1])
			players.append(player_info_02)
		else:
			pass
	
	timer.wait_time = 1
	timer.start()
	await timer.timeout
	
	SendPlayerTurn()
	MainData.currentGameState = MainData.GameState.PLAY

func SendPlayerTurn():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.is_myturn = true
			player.button.disabled = true
			player.button.show()
		else:
			player.is_myturn = false
			player.button.hide()
	
	game_board.CheckRule()
	

func _process(delta):
	pass


# 플레이어 승리시
func _on_game_board_player_win():
	print(str(MainData.currentTrue) + '님 승리' )

# 다음 턴 처리
func _on_game_board_player_next_turn():
	MainData.currentTrue = (MainData.currentTrue + 1) % players.size()
	SendPlayerTurn()
	

# 보드 클릭시
func _on_game_board_board_piece_click():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.button.disabled = false


func _on_player_info_set_rall():
	game_board.onCommitclick()


