extends ScaleControl
class_name HotBar

@export var slot_size : int

@onready var slot_container = $slot_container

var slots : Array[InventorySlot] = []

func _ready():
	super._ready()
	for s in  slot_size:
		var slot : Hotbar_Slot = ResourceManager.tscn.hotbar_slot.instantiate()
		slot.key = str(s+1)
		slot_container.add_child(slot)
		slots.append(slot)
		
	SignalManager.emit_signal("inventory_ready", self)
	
	

