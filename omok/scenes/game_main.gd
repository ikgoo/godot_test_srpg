extends Node2D
# https://www.youtube.com/watch?v=xigPAOl3v7I
# https://www.youtube.com/watch?v=k60oT_8lyFw
# size : 720 * 1280
@onready var game_board : GameBoard = $GamePlay/GameBoard
@onready var player_info_01: PlayerInfo = $GamePlay/PlayerInfo01
@onready var player_info_02: PlayerInfo = $GamePlay/PlayerInfo02
@onready var timer: Timer = $Timer
@onready var game_over = $Control/GameOver/GameOver
@onready var main_menu = $Control/MainMenu

@onready var animation_menu_move = $Control/MainMenu/NinePatchRect/MidArea/MenuArea/AnimationMenuMove
@onready var http_request = $HTTPRequest

@onready var popup_game_rule = $Control/MainMenu/NinePatchRect/PopupGameRule
@onready var option_doll = $Control/MainMenu/NinePatchRect/PopupGameRule/MenuArea/MoveArea/Menu/OptionDoll


var player01
var player02

var players: Array = []

func _get_custom_rpc_methods():
	return [
		"NKM_PlayerTurn",
		"PlayerTimeout",
		"NKM_PlayerWin"
	]
	
func _ready():
	$GamePlay.hide()
	popup_game_rule.hide()
	
	main_menu.PlayMainMenu("show")
	main_menu.show()
	
	OnlineMatch.connect("player_joined", PlayerJoined)
	OnlineMatch.connect("player_left", PlayerLeft)
	OnlineMatch.connect("player_status_changed", PlayerStatusChanged)
	OnlineMatch.connect("match_ready", MatchReady)
	OnlineMatch.connect("match_not_rady", MatchNotReady)	
	OnlineMatch.connect("matchmaker_matched", OnMatchFound)
	
	http_request.connect("request_completed", OnHttpRequestCompleted)
	
	game_board.BoardRender()
	
# 메뉴 선택 =================================================================
# 친구와 하기 메뉴 선택
func _on_withfriend_pressed():
	$GamePlay.show()
	main_menu.hide()
	
	game_over.play("RESET")
	game_board.BoardRender()
	
	MainData.play_type = MainData.PLAYTYPE.OFFLINE
	MainData.players[0] = {
		"id" : 1,
		"name": 'Player01',
	}
	MainData.players[1] = {
		"id" : -1,
		"name": 'Player02'
	}
	
	StartGame()

# ai 메뉴선택
func _on_aibattle_pressed():
	popup_game_rule.show()

func OnAISelect():
	popup_game_rule.hide()
	
	$GamePlay.show()
	main_menu.hide()
	
	game_over.play("RESET")
	game_board.BoardRender()
	
	MainData.play_type = MainData.PLAYTYPE.AI
	MainData.online_my_id = 1 if option_doll.selected == 0 else -1
	if MainData.online_my_id == 1:
		MainData.players[0] = {
			"id" : -1,
			"name": 'Player02',
		}
		MainData.players[1] = {
			"id" : 1,
			"name": 'Player01'
		}
	else:
		MainData.players[0] = {
			"id" : 1,
			"name": 'Player01',
		}
		MainData.players[1] = {
			"id" : -1,
			"name": 'Player02'
		}
	
	
	StartGame()
	
# 온라인 게임 메치(접속 순서에 따른 랜덤 처리)
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
			
			#var player_num = 1 if idx == 0 else -1
			var player_num = 1
			if OnlineMatch.get_my_session_id() == player:
				MainData.online_my_id =  1 if idx == 0 else -1
				
			idx = idx + 1
			
		if MainData.online_my_id == 1:
			MainData.players[0] = {
				"id" : -1,
				"name": 'Player02',
			}
			MainData.players[1] = {
				"id" : 1,
				"name": 'Player01'
			}
		else:
			MainData.players[0] = {
				"id" : 1,
				"name": 'Player01',
			}
			MainData.players[1] = {
				"id" : -1,
				"name": 'Player02'
			}
		
		#MainData.players[idx] = {
			#"id" : player_num,
			#"name": players[player].username,
		#}

		
		StartGame()

# 메뉴 선택 =================================================================

func StartGame():
	player_info_01.SetPlayerInfo(MainData.players[0])
	player_info_02.SetPlayerInfo(MainData.players[1])
	if players.size() == 0:
		players.append(player_info_01)
		players.append(player_info_02)
	
	timer.wait_time = 0.5
	timer.start()
	await timer.timeout
	
	MainData.currentGameState = MainData.GameState.PLAY
	MainData.currentTrue = 1
	
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		if MainData.online_my_id == 1:
			OnlineMatch.custom_rpc_sync(self, "NKM_PlayerTurn", [1])
	else:
		SendPlayerTurn()


	
func NKM_PlayerTurn(userTrun):
	print('my_id:' + str(MainData.online_my_id) + ' / userTrun:' + str(userTrun))
	MainData.currentTrue = userTrun
	SendPlayerTurn()
	
func SendPlayerTurn():
	var aiCall = false
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.is_myturn = true
			if MainData.play_type == MainData.PLAYTYPE.ONLINE:
				if MainData.online_my_id == MainData.currentTrue:
					player.button.disabled = true
					player.button.show()
			elif MainData.play_type == MainData.PLAYTYPE.AI:
				if MainData.currentTrue == MainData.online_my_id:
					player.button.disabled = true
					player.button.show()
				else:
					#game_board
					aiCall = true
				
			else:
				player.button.disabled = true
				player.button.show()
				
		else:
			player.is_myturn = false
			player.button.hide()
	
	game_board.CheckRule()
	print('MainData.currentTrue:' + str(MainData.currentTrue))
	
	if aiCall == true:
		var data = { "data": game_board.rallMap }  # 예시 데이터
		var json_data = JSON.stringify(data)
		
		var url = "http://gomoc.noligo.co.kr/gomocapi/"
		#var url = "http://127.0.0.1:8000/gomocapi/"
		var headers = ["Content-Type: application/json"]
		http_request.request(url, headers, HTTPClient.METHOD_POST, json_data)
		var response_data = await http_request.request_completed

func OnHttpRequestCompleted(result, response_code, headers, body):
	if(response_code == 200):
		var response_text = body.get_string_from_utf8()
		var result_json = JSON.parse_string(response_text)
		var result_data = result_json.prediction
		for r in range(19):
			for c in range(19):
				if(result_data[r][c] == 1 and game_board.rallMap[r][c] == 0):
					print(r, c)
					game_board.Commitclick([r, c], MainData.currentTrue)
					return
	

func _process(delta):
	pass


# 플레이어 승리시
func _on_game_board_player_win():
	for player in players:
		player.GameOver()
	
	MainData.currentGameState = MainData.GameState.GAMEOVER
	
	var p_no = 0
	for idx in range(len(MainData.players)):
		if MainData.players[idx].id == MainData.currentTrue:
			p_no = idx
			
	#if MainData.currentTrue == -1:
		#p_no = 1
	#else:
		#p_no = 0
	print(str(MainData.currentTrue) + '님 승리' )
	var tmpName = tr("xxWIN") % MainData.players[p_no].name
	$Control/GameOver/NinePatchRect/Label.text = tmpName
	game_over.play("open")

func GetNextTrue():
	if  MainData.currentTrue == 1:
		return -1
	else:
		return 1
		

# 다음 턴 처리
func _on_game_board_player_next_turn():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		if MainData.online_my_id == 1:
			MainData.currentTrue = GetNextTrue()
			OnlineMatch.custom_rpc_sync(self, "NKM_PlayerTurn", [MainData.currentTrue])
	elif MainData.play_type == MainData.PLAYTYPE.AI:
		MainData.currentTrue = GetNextTrue()
		SendPlayerTurn()
		
	else:
		MainData.currentTrue = GetNextTrue()
		SendPlayerTurn()



# 보드 클릭시
func _on_game_board_board_piece_click():
	for player in players:
		if player.playerInfo.id == MainData.currentTrue:
			player.button.disabled = false


func _on_player_info_set_rall():
	game_board.onCommitclick()



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
	


func _on_player_info_timeout():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		MainData.currentTrue = GetNextTrue()
		OnlineMatch.custom_rpc_sync(self, "NKM_PlayerWin", [MainData.currentTrue])
		_on_game_board_player_win()
	else:
		MainData.currentTrue = GetNextTrue()
		_on_game_board_player_win()

func NKM_PlayerWin(currentTrue):
	MainData.currentTrue = currentTrue
	_on_game_board_player_win()


func _on_go_main_pressed():
	if MainData.play_type == MainData.PLAYTYPE.ONLINE:
		OnlineMatch.leave()
	
	game_board.ChanchInspacter(false)
	$GamePlay.hide()
	main_menu.PlayMainMenu("show")
	main_menu.show()
	
	game_board.ClearBoard()	



# 끝내기
func _on_exit_pressed():
	get_tree().quit()	
	pass # Replace with function body.

# 메인으로 돌아가기
func _on_btn_back_pressed():
	$GamePlay.get_tree().paused = false
	$Control/PopupGameExit.hide()

	for player in players:
		player.GameOver()

	MainData.currentGameState = MainData.GameState.NONE
	
	_on_go_main_pressed()


func _input(event):
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		if $Control/MainMenu/NinePatchRect/PopupGameRule.is_visible_in_tree() == true:
			_on_btn_back_pressed()
		elif MainData.currentGameState == MainData.GameState.PLAY:
			if MainData.play_type != MainData.PLAYTYPE.ONLINE:
				# 일지 정지
				$Control/PopupGameExit.show()
				$GamePlay.get_tree().paused = true
			#


# 안드로이드 뒤로가기 버튼 이벤트
func _notification(what):
	if what == NOTIFICATION_WM_GO_BACK_REQUEST:
		if $Control/MainMenu/NinePatchRect/PopupGameRule.is_visible_in_tree() == true:
			_on_btn_back_pressed()



func _on_btn_gameplay_back_pressed():
	$Control/PopupGameExit.hide()
	$GamePlay.get_tree().paused = false
