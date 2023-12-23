extends InventorySlot
class_name EquipmentSlot

@export var type : GameEnums.EQUIPMENT_TYPE

@onready var placeholder = $placeholder

# Called when the node enters the scene tree for the first time.
func _ready():
	placeholder.texture = ItemManager.get_placeholder(type)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_item(new_item):
	super.set_item(new_item)
	placeholder.hide()

func pick_item():
	super.pick_item()
	placeholder.show()
	
func put_item(new_item : Item):
	super.put_item(new_item)
	placeholder.hide()
