extends Node


@export var item_in_hand_path : NodePath
@onready var item_in_hand_node : Control = get_node(item_in_hand_path)
@export var item_info_path : NodePath
@onready var item_info : Control = get_node(item_info_path)

var inventories : Array = []
var item_in_hand = null

func _ready():
	SignalManager.connect("inventory_ready", _on_inventory_ready)
	
func _on_inventory_ready(inventory : Inventory):
	inventories.append(inventory)
	
	for slot in inventory.slots:
		slot.connect("mouse_entered", _on_mouse_entered_slot(slot))
		slot.connect("mouse_exited", _on_mouse_exited)
		slot.connect("gui_input", _on_gui_input_slot(slot))
		
func _on_mouse_entered_slot(slot : InventorySlot):
	if slot.item:

func _on_mouse_exited():
	pass

func _on_gui_input_slot(slot):
	pass
