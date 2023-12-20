extends InventorySlot
class_name Hotbar_Slot

@onready var lbl_key : Label = $lbl_key

var key

func _ready():
	lbl_key.text = key
	
func _input(event : InputEvent):
	if event.is_action_pressed("hotbar_" + key):
		print("User hotbar slot :" , key)
