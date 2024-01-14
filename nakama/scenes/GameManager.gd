extends Control

var player: PackedScene = preload("res://player.tscn")
var players = {}
var alivePlayers = {}
var readyPlayers = {}
signal GameOver

func _get_custom_rpc_methods():
	return [
		"SetupGame",
		"FinishedSetup",
	]
func _ready():
	pass
	
	
func StartGame(players):
	OnlineMatch.custom_rpc_sync(self, "SetupGame", [players])
	
func SetupGame(_players):
	players = _players
	alivePlayers = _players

	for id in players:
		var currentPlayer = player.instantiate()
		currentPlayer.name = str(id)
	
		$PlayersSpawnUnder.add_child(currentPlayer)
		currentPlayer.set_multiplayer_authority(id)
		currentPlayer.position = get_node("Player Spawn Points/Player" + str(id)).position
		
		currentPlayer.PlayerHasDied.connect(onPlayerDeath.bind(id))
		
		
	var myID = OnlineMatch.get_network_unique_id()
	var player = $PlayersSpawnUnder.get_node(str(myID))
	player.playerControlled = true
	
	OnlineMatch.custom_rpc_id_sync(self, 1, "FinishedSetup", [myID])
	get_tree().get_nodes_in_group("GameWorld")[0].HideMatchMakeInterface()

func FinishedSetup(id):
	readyPlayers[id] = players[id]
	if readyPlayers.size() == players.size():
		get_tree().get_nodes_in_group("GameWorld")[0].StartGame()

func onPlayerDeath(id):
	alivePlayers.erase(id)
	if alivePlayers.size() <= 1:
		emit_signal("GameOver", alivePlayers)
