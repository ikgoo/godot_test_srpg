extends Node

@onready var items : Dictionary = {
	"tree" : preload("res://items/data/tree.tscn"),
	"stone_brick" : preload("res://items/data/stone_brick.tscn"),
	"gold" : preload("res://items/data/gold.tscn"),
	"crystal" : preload("res://items/data/crystal.tscn"),
}

@onready var placeholders : Dictionary = {
	GameEnums.EQUIPMENT_TYPE.HEAD : preload("res://inventory/sprite/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST : preload("res://inventory/sprite/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.MAIN_HAND : preload("res://inventory/sprite/placeholder_main_hand.png"),
	GameEnums.EQUIPMENT_TYPE.OFFHAND : preload("res://inventory/sprite/placeholder_offhand.png"),
	}

func get_item(id : String):
	return items[id].instantiate()

func get_placeholder(id):
	return placeholders[id]
