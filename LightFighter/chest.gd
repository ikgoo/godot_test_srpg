extends Button

@export var slot_size : int = 1
@export var inventory_name : String = "Chest"

var inventory : Inventory

func _init():
	inventory = preload("res://inventory/inventory.tscn").instantiate()

func _ready():
	inventory.slot_size = slot_size
	inventory.inventory_name = inventory_name
	
	var tt : PackedScene = load("res://items/data/gold.tscn")
	inventory.addItem( tt.instantiate() )
		
	


func _on_pressed():
	SignalManager.emit_signal("inventory_opened", inventory)
