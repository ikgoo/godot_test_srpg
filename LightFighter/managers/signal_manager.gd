extends Node

# Inventory
signal inventory_opened(inventory : Inventory)
signal inventory_closed(inventory : Inventory)
signal inventory_ready(inventory : Inventory)
signal player_inventory_ready(invnetories : Array[Inventory])
signal item_dropped(item)

# Interactabl
signal item_picked(item : Item, sender)

# UI
signal ui_scale_change(value : float)



func _ready():
	pass
