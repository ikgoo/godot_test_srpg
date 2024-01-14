extends Node


var is_local_game: bool = true
var is_pvp: bool = true
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
