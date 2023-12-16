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
@onready var solt_container = $solt_container

var inventory_slot_res = preload("res://inventory/inventory_slot.tscn")
var slots : Array  = []

func _ready():
	for s in slots:
		

