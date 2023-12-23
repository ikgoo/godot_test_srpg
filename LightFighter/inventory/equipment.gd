extends Inventory

@onready var head = $slot_container/equipment_head
@onready var chest = $slot_container/equipment_chest
@onready var offhead = $slot_container/equipment_offhead
@onready var main_head = $slot_container/equipment_main_head


func _ready():
	slots.append(head)
	slots.append(chest)
	slots.append(offhead)
	slots.append(main_head)
	
	SignalManager.emit_signal("inventory_ready", self)
	
func set_inventory_size(value):
	slot_size = value

func set_title():
	pass
	
