extends Node


@export var item_in_hand_path : NodePath
@onready var item_in_hand_node : Control = get_node(item_in_hand_path)
@export var item_info_path : NodePath
@onready var item_info : ItemInfo = get_node(item_info_path)

var inventories : Array = []
var item_in_hand : Item = null
var item_offset = Vector2.ZERO

func _ready():
	SignalManager.connect("inventory_ready", _on_inventory_ready)
	
func _on_inventory_ready(inventory : Inventory):
	inventories.append(inventory)
	
	for slot in inventory.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited.bind())
		slot.gui_input.connect(_on_gui_input_slot.bind(slot))

func _input(event : InputEvent):
	if event is InputEventMouseMotion and item_in_hand:
		item_in_hand.global_position = event.position - item_offset

func _process(delta):
	pass
	#if item_in_hand:
		#item_in_hand.global_position = get_viewport().get_mouse_position() - item_offset

func _on_mouse_entered_slot(slot : InventorySlot):
	if slot.item:
		item_info.dispaly(slot)
		
		
func _on_mouse_exited():
	item_info.hide()

func _on_gui_input_slot(event : InputEvent, slot : InventorySlot):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if item_in_hand:
			if slot is EquipmentSlot and item_in_hand.equipment != slot.type:
				return			
			
			item_in_hand_node.remove_child(item_in_hand)
			
			if slot.item:
				var temp_item = slot.item
				slot.pick_item()
				temp_item.global_position = event.global_position# - item_offset
				slot.put_item(item_in_hand)
				item_in_hand = temp_item
				item_in_hand_node.add_child(item_in_hand)
				
			else:
				slot.put_item(item_in_hand)
				item_in_hand = null
				
				
		elif slot.item:
			item_in_hand = slot.item
			item_offset = item_in_hand.size / 2
			#item_in_hand.global_position = event.position - item_offset
			#item_in_hand.global_position = event.position
			slot.pick_item()
			item_info.hide()
			item_in_hand_node.add_child(item_in_hand)
			item_in_hand.global_position = get_viewport().get_mouse_position() - item_offset
			
