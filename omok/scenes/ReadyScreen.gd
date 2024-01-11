extends Control
class_name ReadyScreen

var playerReady = preload("res://user_ready.tscn")
signal PlayerReady()

func _ready():
	OnlineMatch.connect("player_joined", PlayerJoined)
	OnlineMatch.connect("player_left", PlayerLeft)
	OnlineMatch.connect("player_status_changed", PlayerStatusChanged)
	OnlineMatch.connect("match_ready", MatchReady)
	OnlineMatch.connect("match_not_rady", MatchNotReady)
	OnlineMatch.connect("matchmaker_matched", AddPlayers)

func AddPlayers(players):
	for id in players:
		var userReady : UserReady = playerReady.instantiate()
		$VBoxContainer.add_child(userReady)
		userReady.setUsername(players[id]["username"])
		userReady.name = id
		

func PlayerJoined(player):
	pass

func PlayerLeft(player):
	pass

func PlayerStatusChanged(player, status):
	pass

func MatchReady(player):
	pass

func MatchNotReady(player):
	pass

func setReadyStatus(id, status):
	var statusObject: UserReady = $VBoxContainer.get_node_or_null(id)
	if statusObject:
		statusObject.setReady(status)

func _on_button_pressed():
	emit_signal("PlayerReady")
	
