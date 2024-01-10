extends Node

var client : NakamaClient
var session : NakamaSession
var socket : NakamaSocket
var account : NakamaAPI.ApiAccount
var room : NakamaRTAPI.Match
var friends_list
var online_friends = []

var device_id = OS.get_unique_id()


func _ready():
	client = Nakama.create_client("defaultkey", "125.141.139.219", 7350, "http")
	client.timeout = 10
	
	session = await client.authenticate_device_async(device_id)
	if session.is_exception():
		print("An error occurred: %s" % session)
		return
	print("Successfully authenticated: %s" % session)
		
	account = await client.get_account_async(session)
	print("username: " + account.user.username)
	
	# 소켓 생성
	socket = Nakama.create_socket_from(client)

	# 소켓 연결
	var connected : NakamaAsyncResult = await NakamaInstance.socket.connect_async(NakamaInstance.session)
	if connected.is_exception():
		print("An error occurred: %s" % connected)
		return
	print("Socket connected.")


# 룸 생성
func CreateRoom(roomName : String = ''):
	room = await socket.create_match_async(roomName)
	
# 친구 가져오기
func GetFriends():
	friends_list = await client.list_friends_async(session, 0, 100)
	for friend in friends_list.friends:
		var f = friend as NakamaAPI.ApiFriend
		if not f or not f.user.online:
			continue
		online_friends.append(f.user)
	

func SendMessageAll():

	if !room:
		var match_id =  room.match_id
		
		for f in online_friends:
			var content = {
				"message": "Hey %s, join me for a match!",
				"match_id": match_id,
			}
			var channel = await socket.join_chat_async(f.id, NakamaSocket.ChannelType.DirectMessage)
			var message_ack = await socket.write_chat_message_async(channel.id, content)
	
