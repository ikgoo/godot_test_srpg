extends Node2D
class_name PlayerInfo

signal Timeout
signal SetRall

@onready var player_name = $PlayerName
@onready var progress_bar = $ProgressBar
@onready var profile_front = $Profile/Profile_Front
@onready var rall = $Profile/Rall
@onready var button = $Button


var maxValue = 20	# 20초

enum TrunEndType {
	TURNEND,
	TIMEOUT
}
var is_myturn = false : set = SetMyTrun 
func SetMyTrun(value):
	is_myturn = value
	if is_myturn:
		profile_front.frame = 1
	else:
		profile_front.frame = 0
	
	if !is_myturn:
		if tween:
			tween.kill()
		progress_bar.value = 0
	else:
		tween = create_tween()
		tween.tween_property(progress_bar, "value", maxValue, maxValue)
		tween.tween_callback(timeOverATurnEnd)

var tween : Tween
var playerInfo

func _ready():
	progress_bar.value = 0
	progress_bar.max_value = maxValue

func SetPlayerInfo(_playerInfo):
	playerInfo = _playerInfo
	print(playerInfo['name'])
	player_name.text = playerInfo['name']
	rall.frame = playerInfo['id']
	
func timeOverATurnEnd():
	emit_signal("Timeout")

func GameOver():
	if tween:
		tween.kill()
		
	progress_bar.value = 0
	button.hide()
	


func _on_button_pressed():
	emit_signal("SetRall")
