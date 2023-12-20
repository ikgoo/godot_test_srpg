extends ScaleControl
class_name SplitStack

signal stack_splitted

@onready var qty_slider : HSlider = $"main panel/scale/quantity_slider"
@onready var lbl_orignal : Label = $"main panel/scale/orignal_qty"
@onready var lbl_new : Label = $"main panel/scale/new_qty2"

var quantity : int
var new_quantity : int
var inventory_slot : InventorySlot

func display(slot : InventorySlot):
	quantity = slot.item.quantity
	inventory_slot = slot
	qty_slider.max_value = quantity - 1
	qty_slider.min_value = 1
	qty_slider.step = 1
	qty_slider.value = int( round(quantity / 2))
	
	set_value()
	show()
	
func set_value():
	lbl_orignal.text = str(qty_slider.value)
	new_quantity = quantity - qty_slider.value
	lbl_new.text = str(new_quantity)


func _on_close_pressed():
	hide()


func _on_quantity_slider_value_changed(value):
	set_value()


func _on_btn_split_pressed():
	emit_signal("stack_splitted", inventory_slot, qty_slider.value)
	hide()
