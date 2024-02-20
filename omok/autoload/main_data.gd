extends Node


enum PLAYTYPE {
	OFFLINE,
	AI,
	ONLINE,
}
var play_type = PLAYTYPE.OFFLINE

var players = {}

enum GameState {
	NONE,		# 상태 없음
	WAIT,		# 대기
	READY,		# 준비
	PLAY,		# 플레이
	GAMEOVER,	# 게임 오버
}
var currentGameState: GameState = GameState.NONE

var WHITE_DOL = 1		# 흰색돌
var BLOCK_DOL = -1		# 검은색돌
var currentTrue = 1		# 현재 턴(돌 색)

# 플레이어의 순번(온라인 게임의 경우)
var online_my_id = 0
