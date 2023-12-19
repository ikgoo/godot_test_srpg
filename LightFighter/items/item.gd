extends TextureRect

class_name Item

@export var id : String
@export var item_name : String
@export var equipment : GameEnums.EQUIPMENT_TYPE

func pick_item():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
func put_item():
	mouse_filter = Control.MOUSE_FILTER_PASS
