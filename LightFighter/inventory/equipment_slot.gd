extends InventorySlot
class_name EquipmentSlot

@export var type : GameEnums.EQUIPMENT_TYPE

@onready var placeholder = $placeholder

func _ready():
	super._ready()
	placeholder.texture = ItemManager.get_placeholder(type)

func try_put_item(new_item : Item) -> bool:
	return new_item.equipment_type == type and super.try_put_item(new_item)

func put_item(new_item : Item) -> Item:
	if new_item:
		if new_item.equipment_type != type:
			return new_item
		
		placeholder.hide()
	else:
		placeholder.show()
		
	return super.put_item(new_item)
