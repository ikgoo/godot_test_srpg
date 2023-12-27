extends Node


@export var item_in_hand_path : NodePath
@onready var item_in_hand_node : Control = get_node(item_in_hand_path)
@export var item_info_path : NodePath
@onready var item_info : ItemInfo = get_node(item_info_path)
@onready var split_stack : SplitStack = $"../../ui/ui_container/split_stack"
@onready var item_void = $"../../ui/item_void"


var player_inventories : Array = []
var inventories : Array = []
var item_in_hand : Item = null
var item_offset = Vector2.ZERO

func _ready():
	SignalManager.connect("item_picked", _on_item_picked)
	SignalManager.connect("inventory_ready", _on_inventory_ready)
	SignalManager.connect("player_inventory_ready", _on_player_inventory_ready)
	split_stack.connect("stack_splitted", _on_stack_splitted)
	item_void.connect("gui_input", _on_void_gui_input)
	
func _on_inventory_ready(inventory : Inventory):
	inventories.append(inventory)
	
	for slot in inventory.slots:
		slot.mouse_entered.connect(_on_mouse_entered_slot.bind(slot))
		slot.mouse_exited.connect(_on_mouse_exited.bind())
		slot.gui_input.connect(_on_gui_input_slot.bind(slot))


func _input(event : InputEvent):
	if event is InputEventMouseMotion and item_in_hand:
		set_hand_position(get_viewport().get_mouse_position())
		#item_in_hand.global_position = (get_viewport().get_mouse_position() - (item_offset * SettingManager.scale))

func _on_void_gui_input(event : InputEvent):
	if event is InputEventMouseButton:
		event = event as InputEventMouseButton
		if event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT:
			SignalManager.emit_signal("item_dropped", item_in_hand)
			item_in_hand_node.remove_child(item_in_hand)
			item_in_hand = null
			set_item_void_filter()
		
	 	

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
	if slot.item and slot.item.quantity > 1 and item_in_hand == null and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_RIGHT and Input.is_key_pressed(KEY_SHIFT):
		if slot.item.quantity == 2:
			_on_stack_splitted(slot, 1)
		else:
			split_stack.display(slot)
	
	elif event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var had_empty_hand = item_in_hand == null
		
		if item_in_hand:
			item_in_hand_node.remove_child(item_in_hand)

		item_in_hand = slot.put_item(item_in_hand)
		
		if item_in_hand:
			if had_empty_hand:
				var t1 = get_viewport().get_mouse_position()
				var t2 = slot.global_position
				
				item_offset = get_viewport().get_mouse_position() - slot.global_position
				#print(item_offset)
				
			item_in_hand_node.add_child(item_in_hand)
			
		set_hand_position(get_viewport().get_mouse_position())

func set_hand_position(pos):
	set_item_void_filter()
	
	if item_in_hand:
		item_in_hand.global_position = (pos - item_offset) / SettingManager.scale
		#item_in_hand.global_position = (pos-item_offset) / SettingManager.scale

func set_item_void_filter():
	item_void.mouse_filter = Control.MOUSE_FILTER_STOP if item_in_hand else Control.MOUSE_FILTER_IGNORE

func _on_stack_splitted(slot : InventorySlot, new_quantity : int):
	slot.item.quantity -= new_quantity
	var new_item : Item = ItemManager.get_item(slot.item.id)
	new_item.quantity = new_quantity
	item_in_hand = new_item
	item_in_hand.global_position = get_viewport().get_mouse_position()
	item_in_hand_node.add_child(item_in_hand)
	set_hand_position(slot.global_position)

func _on_item_picked(item : Item, sender):
	for i : Inventory in player_inventories:
		item = i.add_item(item)
		if not item:
			sender.item_picked()
			return

func _on_player_inventory_ready(inv : Array[Inventory]):
	player_inventories = inv

