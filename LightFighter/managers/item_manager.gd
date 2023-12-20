extends Node


@onready var items : Dictionary = {}
@onready var placeholders : Dictionary = {
	GameEnums.EQUIPMENT_TYPE.HEAD : preload("res://inventory/sprite/placeholder_head.png"),
	GameEnums.EQUIPMENT_TYPE.CHEST : preload("res://inventory/sprite/placeholder_chest.png"),
	GameEnums.EQUIPMENT_TYPE.MAIN_HAND : preload("res://inventory/sprite/placeholder_main_hand.png"),
	GameEnums.EQUIPMENT_TYPE.OFFHAND : preload("res://inventory/sprite/placeholder_offhand.png"),
}

const ITEM_PATH = "res://items/data/items.json"

func _ready():
	var file = FileAccess.open(ITEM_PATH, FileAccess.READ)
	var json = JSON.new()
	var error : Error = json.parse(file.get_as_text())
	if error == OK:
		items = json.data
	else:
		pass
	
	file.close()
	pass
	

func get_item(id : String):
	return Item.new(id, items[id])

func get_placeholder(id):
	return placeholders[id]
