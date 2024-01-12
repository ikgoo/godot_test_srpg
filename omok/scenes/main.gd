extends Node2D

@onready var ready_screen = $Control/ReadyScreen
@onready var find_match = $Control/FindMatch
@onready var login = $Control/Login

var readyPlayers = {}

func _get_custom_rpc_methods():
	return [
		"PlayerIsReady",
	]

func _ready():
	ready_screen.connect("PlayerReady", PlayerReady)
	
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
