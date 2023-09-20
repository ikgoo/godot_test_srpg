extends TextureRect

signal SelectImage(sctDate)


var curDate : String
var curData : Variant


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT :
		emit_signal("SelectImage", curDate)
