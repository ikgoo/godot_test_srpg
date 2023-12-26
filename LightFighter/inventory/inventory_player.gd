extends DragableControl

#@onready var inventory_container = $inventory_container
@onready var equipment : Inventory = $inventory_container/equipment
@onready var inventory_left : Inventory = $inventory_container/inventory_left
@onready var inventory_right : Inventory = $inventory_container/inventory_right

func _ready():
	super._ready()
	var inventories : Array[Inventory] = [equipment, inventory_left, inventory_right]
	SignalManager.emit_signal("player_inventory_ready", inventories)
	
	
