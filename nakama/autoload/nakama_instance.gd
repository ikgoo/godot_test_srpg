extends Node
# http://125.141.139.219:7351/#/matches
# https://heroiclabs.com/docs/nakama/client-libraries/godot/
# https://www.youtube.com/watch?v=D-lgqp9USlY
var client : NakamaClient
var session : NakamaSession
var socket : NakamaSocket
var account : NakamaAPI.ApiAccount
var room : NakamaRTAPI.Match
var friends_list
var online_friends = []

@onready var device_id = OS.get_unique_id()

func _ready():
	Init()

func Init(userName : String = ''):
	if not client:
		#client = Nakama.create_client("defaultkey", "125.141.139.219", 7350, "http")
		client = Nakama.create_client(
			"defaultkey", "125.141.139.219", 7350, "http",
			Nakama.DEFAULT_TIMEOUT,
			NakamaLogger.LOG_LEVEL.ERROR)		
		if not client:
			return false
	client.timeout = 10
	
	if not session:
		var vars = {
			"device_os" : OS.get_name,
			"device_model" : OS.get_model_name,
		}
		if userName and userName != '':
			vars['user_name'] = userName
			
		session = await client.authenticate_device_async(device_id, null, true, vars)
		if session.is_exception():
			print("An error occurred: %s" % session)
			return false
		print("Successfully authenticated: %s" % session)
		
	if not account:
		account = await client.get_account_async(session)
		if account.is_exception():
			return false
		print("username: " + account.user.username)
	
	# 소켓 생성
	if not socket:
		socket = Nakama.create_socket_from(client)
		if not socket:
			return false

	# 소켓 연결
	var connected : NakamaAsyncResult = await NakamaInstance.socket.connect_async(NakamaInstance.session)
	if connected.is_exception():
		print("An error occurred: %s" % connected)
		return false
	print("Socket connected.")
	
	return true

func CloseSession():
	if not session:
		return true
		
	await client.session_logout_async(session)
	return true

# 룸 생성
func CreateRoom(roomName : String = ''):
	room = await socket.create_match_async(roomName)
	print(room.get_ .get_host_address())
	GetFriends()
	return room

# id로 접속
func JoinRoomByID(match_id):
	if not socket:
		return null
	
	var match : NakamaRTAPI.Match = await socket.join_match_async(match_id)

	# 매치 참가 검사
	if match.is_exception():
		print("매치 참가에 실패했습니다: ", match.get_exception())
		return null

	# 성공적으로 매치에 참가한 경우, 매치 정보 반환
	room = match
	
	if room:
		return room.get_result()
	else:
		return null
		
# 빠른 매칭
func FastMatch(query : String = '', min_players : int = 2, max_players : int = 10):
	if not socket:
		return null

	var matchmaking_ticket : NakamaRTAPI.MatchmakerTicket = await socket.add_matchmaker_async(query, min_players, max_players)
	
	# 매치메이킹 티켓 검사
	if matchmaking_ticket.is_exception():
		print("매치메이킹에 실패했습니다: ", matchmaking_ticket.get_exception())
		return null

	# 매치 참가
	var matchRoom : NakamaRTAPI.Match = await socket.join_match_async(matchmaking_ticket.get_result())
	
	# 매치 참가 검사
	if matchRoom.is_exception():
		print("매치 참가에 실패했습니다: ", matchRoom.get_exception())
		return null

	# 성공적으로 매치에 참가한 경우, 매치 정보 반환
	room = matchRoom
	return matchRoom.get_result()

# 대전 리스트 가져오그
func GetMatchList(min_players : int = 2, max_players : int = 10, limit : int = 10, authoritative = true, label : String = "", query : String = ""):
	if not client or not session:
		return null
		
	var result : NakamaRTAPI.Match = await client.list_matches_async(session, min_players, max_players, limit, authoritative, label, query)
	
	return result
	#for m in result.matches:
		#print("%s: %s/10 players", match.match_id, match.size)


# 친구 가져오기
func GetFriends():
	if(!session):
		friends_list = await client.list_friends_async(session, 0, 100)
		for friend in friends_list.friends:
			var f = friend as NakamaAPI.ApiFriend
			if not f or not f.user.online:
				continue
			online_friends.append(f.user)
	
	return online_friends

# 내방에 오길 요청 하는 메시지 보내기
func SendJoinMessageAll():
	#if !room:
		#var match_id =  room.match_id
		#
		#for f in online_friends:
			#var content = {
				#"message": "Hey %s, join me for a match!",
				#"match_id": match_id,
			#}
			#var channel = await socket.join_chat_async(f.id, NakamaSocket.ChannelType.DirectMessage)
			#var message_ack = await socket.write_chat_message_async(channel.id, content)
			#
		#return true
	#return false
	#
	pass
