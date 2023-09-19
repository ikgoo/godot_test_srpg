extends TextureRect

signal SelectImage(sctDate)


var curDate : String
var curData : Variant


func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		emit_signal("SelectImage", curDate)
