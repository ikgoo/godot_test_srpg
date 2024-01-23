extends Node2D
# size : 720 * 1280
@onready var game_board : GameBoard = $GamePlay/GameBoard
@onready var player_info_01: PlayerInfo = $GamePlay/PlayerInfo01
@onready var player_info_02: PlayerInfo = $GamePlay/PlayerInfo02
@onready var timer: Timer = $Timer
@onready var game_over = $Control/GameOver/GameOver
@onready var main_menu = $Control/MainMenu

@onready var animation_menu_move = $Control/MainMenu/NinePatchRect/MidArea/MenuArea/AnimationMenuMove


var player01
var player02

enum GameState {
	WAIT,
	READY,
	PLAYING,
	GAMEOVER,
}

var players: Array = []

func _get_custom_rpc_methods():
	return [
		"NKM_PlayerTurn",
		"PlayerTimeout",
		"NKM_PlayerWin"
	]
	
func _ready():
	$GamePlay.hide()
	main_menu.PlayMainMenu("show")
	main_menu.show()
	
	OnlineMatch.connect("player_joined", PlayerJoined)
	OnlineMatch.connect("player_left", PlayerLeft)
	OnlineMatch.connect("player_status_changed", PlayerStatusChanged)
	OnlineMatch.connect("match_ready", MatchReady)
	OnlineMatch.connect("match_not_rady", MatchNotReady)	
	OnlineMatch.connect("matchmaker_matched", OnMatchFound)
	
	game_board.BoardRender()
	
func NKM_PlayerTurn(userTrun):
	print('my_id:' + str(MainData.online_my_id) + ' / userTrun:' + str(userTrun))
	MainData.currentTrue = userTrun
	SendPlayerTurn()
	
func SendPlayerTurn():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.is_myturn = true
			if MainData.play_type == MainData.PLAYTYPE.ONLINE:
				if MainData.online_my_id == MainData.currentTrue:
					player.button.disabled = true
					player.button.show()
			else:
				player.button.disabled = true
				player.button.show()
				
		else:
			player.is_myturn = false
			player.button.hide()
	
	game_board.CheckRule()
	print('MainData.currentTrue:' + str(MainData.currentTrue))
	

func _process(delta):
	pass


# 플레이어 승리시
func _on_game_board_player_win():
	for player in players:
		player.GameOver()
	
	print(str(MainData.currentTrue) + '님 승리' )
	var tmpName = tr("xxWIN") % MainData.players[MainData.currentTrue].name
	$Control/GameOver/NinePatchRect/Label.text = tmpName
	game_over.play("open")

# 다음 턴 처리
func _on_game_board_player_next_turn():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		if MainData.online_my_id == 0:
			MainData.currentTrue = (MainData.currentTrue + 1) % 2
			OnlineMatch.custom_rpc_sync(self, "NKM_PlayerTurn", [MainData.currentTrue])
	else:
		MainData.currentTrue = (MainData.currentTrue + 1) % 2
		SendPlayerTurn()
	

# 보드 클릭시
func _on_game_board_board_piece_click():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.button.disabled = false


func _on_player_info_set_rall():
	game_board.onCommitclick()




func _on_withfriend_pressed():
	$GamePlay.show()
	main_menu.hide()
	
	game_over.play("RESET")
	game_board.BoardRender()
	
	MainData.play_type = MainData.PLAYTYPE.OFFLINE
	MainData.players[0] = {
		"id" : 0,
		"name": 'Player01',
	}
	MainData.players[1] = {
		"id" : 1,
		"name": 'Player02'
	}
	
	StartGame()

func PlayerJoined(player):
	print("PlayerJoined")
	pass

func PlayerLeft(player):
	print("PlayerLeft")
	pass

func PlayerStatusChanged(player, status):
	print("PlayerStatusChanged")
	pass

func MatchReady(player):
	print("MatchReady")
	pass

func MatchNotReady(player):
	print("MatchNotReady")
	pass
	
# 온라인 게임 메치
func OnMatchFound(players):
	if MainData.currentGameState != MainData.GameState.PLAY:
		MainData.play_type = MainData.PLAYTYPE.ONLINE
		$Control/MainMenu/NinePatchRect/Matching.hide()
		$GamePlay.show()
		main_menu.hide()
		
		game_over.play("RESET")
		
		var idx = 0
		MainData.players = {}
		for player in players:
			MainData.players[idx] = {
				"id" : idx,
				"name": players[player].username,
			}

			if OnlineMatch.get_my_session_id() == player:
				MainData.online_my_id = idx

			idx = idx + 1
			
		
		StartGame()

func StartGame():
	player_info_01.SetPlayerInfo(MainData.players[0])
	player_info_02.SetPlayerInfo(MainData.players[1])
	if players.size() == 0:
		players.append(player_info_01)
		players.append(player_info_02)
	
	timer.wait_time = 1
	timer.start()
	await timer.timeout
	
	MainData.currentGameState = MainData.GameState.PLAY
	MainData.currentTrue = 0
	
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		if MainData.online_my_id == 0:
			OnlineMatch.custom_rpc_sync(self, "NKM_PlayerTurn", [MainData.online_my_id])
	else:
		SendPlayerTurn()


func _on_player_info_timeout():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		MainData.currentTrue = (MainData.currentTrue+1) % 2
		OnlineMatch.custom_rpc_sync(self, "NKM_PlayerWin", [MainData.currentTrue])
		_on_game_board_player_win()
	else:
		MainData.currentTrue = (MainData.currentTrue+1) % 2
		_on_game_board_player_win()

func NKM_PlayerWin(currentTrue):
	MainData.currentTrue = currentTrue
	_on_game_board_player_win()


func _on_go_main_pressed():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		OnlineMatch.leave()
	
	MainData.currentGameState = MainData.GameState.GAMEOVER
	$GamePlay.hide()
	main_menu.PlayMainMenu("show")
	main_menu.show()
