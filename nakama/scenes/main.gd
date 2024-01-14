extends Node2D
#https://www.youtube.com/watch?v=D-lgqp9USlY
@onready var ready_screen = $Control/ReadyScreen
@onready var find_match = $Control/FindMatch
@onready var login = $Control/Login
@onready var players = $Players

var readyPlayers = {}

func _get_custom_rpc_methods():
	return [
		"PlayerIsReady",
		"DetermineWinner",
	]

func _ready():
	ready_screen.connect("PlayerReady", PlayerReady)
	players.connect("GameOver", onGameOver)
	
	login.show()
	find_match.hide()
	ready_screen.hide()
	$Control.show()


func PlayerReady():
	OnlineMatch.custom_rpc_sync(self, "PlayerIsReady", [OnlineMatch.get_my_session_id()])

func PlayerIsReady(id):
	ready_screen.setReadyStatus(id, "Ready")
	
	if OnlineMatch.is_network_server():
		readyPlayers[id] = true
		if readyPlayers.size() == OnlineMatch.players.size():
			OnlineMatch.start_playing()
			$Players.StartGame(OnlineMatch.get_player_names_by_peer_id())
			#StartGame()

func StartGame():
	print("All Players Are Ready Lets Start the Game!")
	$Control.hide()

func HideMatchMakeInterface():
	$Control.hide()

func onGameOver(alivePlayers):
	OnlineMatch.custom_rpc_sync(self, "DetermineWinner", [alivePlayers])

func DetermineWinner(alivePlayers: Dictionary):
	print(alivePlayers)
	$Control2.show()
	if OnlineMatch.get_network_unique_id() in alivePlayers:
		$Control2/Label.text = 'I lose'
	else:
		$Control2/Label.text = 'I Win'
