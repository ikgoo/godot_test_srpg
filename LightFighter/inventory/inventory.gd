extends NinePatchRect

class_name Inventory

@export var inventory_name : String = ""
@export var slot_size : int = 0 : set = set_slot_size
func set_slot_size(value):
	slot_size = value
	custom_minimum_size.y = 40 + ( ceilf(slot_size / 5.0) - 1 ) * 22
	
	for s in slot_size:
		var new_slot = inventory_slot_res.instantiate()
		slots.append(new_slot)

@onready var title : Label = $TextureRect/Label
@onready var slot_container = $slot_container


var inventory_slot_res = preload("res://inventory/inventory_slot.tscn")
# slot 배경
var slots : Array[InventorySlot]  = []

func _ready():
	for s in slots:
		slot_container.add_child(s)
		
	set_title()
	SignalManager.emit_signal("inventory_ready", self)

func set_title():
	title.text = " - " + inventory_name + " - "

func add_item( item : Item):
	for s : InventorySlot in slots:
		if not s.item:
			s.item = item
			return

