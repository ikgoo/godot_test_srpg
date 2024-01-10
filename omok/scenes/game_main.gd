extends Node2D

var rows = 19
var columns = 19
var cell_size = 15

var offset = 10

var loc = []

@onready var btn_room_make = $Control2/VBoxContainer/BtnRoomMake


func _ready():
	 #http://125.141.139.219:7351/
	pass


func _on_btn_room_make_pressed():
	NakamaInstance.CreateRoom('test')
	pass
