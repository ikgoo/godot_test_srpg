extends Control

func _ready():
	OnlineMatch.connect("matchmaker_matched", OnMatchFound)
	
	
func OnMatchFound(players):
	print(players)
	pass


func _on_find_match_pressed():
	$"Find Match".hide()
	
	if not Online.is_nakama_socket_connected():
		Online.connect_nakama_socket()
		await Online.socket_connected

	print("looking for a Match....")
	
	var data = {
		min_count = 2
	}
	OnlineMatch.start_matchmaking(Online.nakama_socket, data)
