extends TextureRect

class_name InventorySlot

@onready var item_container = $item_container

var item : Item : set = set_item

func _ready():
	if item:
		item_container.add_child(item)
		
func set_item(new_item):
	item = new_item

func pick_item():
	item_container.remove_child(item)
	item = null
	
func put_item(new_item : Item):
	item = new_item	
	item_container.add_child(item)

