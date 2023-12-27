extends Area2D

@export var item_id : String

var item : Item
var action : String = "pickup"
var object_name : String = ""


func _ready():
	if not item:
		item = ItemManager.get_item(item_id)
	
	object_name = item.item_name


func interact():
	SignalManager.emit_signal("item_picked", item, self)
	
func item_picked():
	queue_free()
