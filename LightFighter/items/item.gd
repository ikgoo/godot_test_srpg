extends TextureRect

class_name Item

@export var item_name : String

var picked = false

func pick_item():
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	picked = true
	
func put_item():
	mouse_filter = Control.MOUSE_FILTER_PASS
	picked = false
