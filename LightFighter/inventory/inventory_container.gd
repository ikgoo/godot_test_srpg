extends DragableControl

@onready var inventory_container : BoxContainer = $inventory_container

var current_inventories : Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	SignalManager.connect("inventory_opened", _on_inventory_opened)
	SignalManager.connect("inventory_closed", _on_inventory_closed)

func close():
	for i in current_inventories:
		inventory_container.remove_child(i)
		i.is_open = false
		
	current_inventories  = []
	hide()
	

func _on_inventory_opened(inventory : Inventory):
	inventory.is_open = true
	if current_inventories.size() == 0:
		size.y = 20
	
	if  current_inventories.has(inventory):
		return
		
	inventory_container.add_child(inventory)
	current_inventories.append(inventory)
	size.y += inventory.size.y + inventory_container.get_theme_constant("separation")
	show()

func _on_inventory_closed(inventory : Inventory):
	inventory.is_open = false
	inventory_container.remove_child(inventory)
	current_inventories.remove_at(current_inventories.find(inventory))
	size.y -= inventory.size.y + inventory_container.get_theme_constant("separation")
	
	if current_inventories.size() == 0:
		hide()
	
	
func _on_close_pressed():
	close()
