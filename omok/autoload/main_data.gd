extends Node


enum PLAYTYPE {
	OFFLINE,
	AI,
	ONLINE,
}
var play_type = PLAYTYPE.OFFLINE

var players = {}

enum GameState {
	NONE,
	WAIT,
	READY,
	PLAY,
	GAMEOVER,
}
var currentGameState: GameState = GameState.NONE

var currentTrue = 0

# 플레이어의 순번(온라인 게임의 경우)
var online_my_id = 0
