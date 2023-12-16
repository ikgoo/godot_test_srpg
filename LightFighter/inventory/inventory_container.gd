extends NinePatchRect

@onready var inventory_container : BoxContainer = $inventory_container

var current_inventories : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	SignalManager.connect("inventory_opened", _on_inventory_opened)

func close():
	for i in current_inventories:
		inventory_container.remove_child(i)
		
	current_inventories  = []
	

func _on_inventory_opened(inventory : Inventory):
	if current_inventories.size() == 0:
		size.y = 20
		
	
	if  current_inventories.has(inventory):
		return
		
	inventory_container.add_child(inventory)
	current_inventories.append(inventory)
	size.y += inventory.size.y + inventory_container.separation
	show()


func _on_close_pressed():
	close()
