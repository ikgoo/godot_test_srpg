extends NinePatchRect
class_name ItemInfo

@export var item_name_path : NodePath
@onready var item_name : Label = get_node(item_name_path)

func dispaly(slot : InventorySlot):
	global_position = slot.global_position + slot.size
	item_name.text = slot.item.item_name
	show()
