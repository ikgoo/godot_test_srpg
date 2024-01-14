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
	
	timer.wait_time = 2
	timer.start()
	await timer.timeout
	
	SendPlayerTurn()
	MainData.currentGameState = MainData.GameState.PLAY
	game_board.inspacter.show()

func SendPlayerTurn():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.is_myturn = true
		else:
			player.is_myturn = false
	

func _process(delta):
	pass



func _on_game_board_player_win():
	pass # Replace with function body.


func _on_game_board_player_next_turn():
	MainData.currentTrue = (MainData.currentTrue + 1) % players.size()
	SendPlayerTurn()
	
