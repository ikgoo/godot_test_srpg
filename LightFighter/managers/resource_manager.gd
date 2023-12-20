extends Node
class_name Resource_Manager

const STAT_PATH = "res://items/data/stats.json"

var sprites = {
	"chestplate" : preload("res://items/sprites/chestplate.png"),
	"crystal" : preload("res://items/sprites/crystal.png"),
	"gold_coin" : preload("res://items/sprites/gold_coin.png"),
	"helmet" : preload("res://items/sprites/helmet.png"),
	"iron_sword" : preload("res://items/sprites/iron_sword.png"),
	"magic_orb" : preload("res://items/sprites/magic_orb.png"),
	"shield" : preload("res://items/sprites/shield.png"),
	"stone_brick" : preload("res://items/sprites/stone_brick.png"),
	"tshirt" : preload("res://items/sprites/tshirt.png"),
	"wood" : preload("res://items/sprites/wood.png"),
	"wooden_sword" : preload("res://items/sprites/wooden_sword.png"),
}

var fonts = {
	8: preload("res://font/font_8.tres")
}

var colors = {
	"normal": Color("905c32") 
}

var tscn = {
	"splitter" : preload("res://ui/splitter.tscn"),
	"hotbar_slot" : preload("res://inventory/hotbar_slot.tscn") 
}

var stat_info = {}

func _ready():
	var file = FileAccess.open(STAT_PATH, FileAccess.READ)
	var json = JSON.new()
	var data = json.parse_string(file.get_as_text())
	
	for stat in data:
		stat_info[GameEnums.STAT[stat]] = data[stat]
	
	file.close()
	
