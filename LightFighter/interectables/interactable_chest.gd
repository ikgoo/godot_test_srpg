extends Area2D
class_name Chest

@export var slot_size : int = 1
@export var inventory_name : String = "Chest"
@export var items : Array[String]

var inventory : Inventory
var action = "open"
var object_name = "Chest"

func _init():
	inventory = preload("res://inventory/inventory.tscn").instantiate()

func _ready():
	inventory.slot_size = slot_size
	inventory.inventory_name = inventory_name
	set_items()
	
func set_items():
	for i in items:
		inventory.add_item(ItemManager.get_item(i))


func interact():
	SignalManager.emit_signal("inventory_opened", inventory)

func out_of_range():
	if inventory.is_open:
		SignalManager.emit_signal("inventory_closed", inventory)
