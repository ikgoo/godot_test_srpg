extends TextureButton

signal SelectImage(name, sctDate, globalPosition, localPosition)

# 현재 날짜
var curDate : int = 0
#현재 날짜의 정보
var curData : Variant = null

# 메인 게임중이면 이미지의 타입을 넘겨줌
var img_type : String = "NONE"

# 틀린 그림의 경우 해당 번호 정보
var diff_idx : int = -1


func _on_pressed():
	if name.find("Diff") >= 0:
		emit_signal("SelectImage", name + str(diff_idx), curDate, get_global_mouse_position(), get_parent().get_local_mouse_position())
	else:
		emit_signal("SelectImage", name, curDate, get_global_mouse_position(), get_local_mouse_position())
	

#func _on_gui_input(event):
#	print('click01')
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT :
#		print('click02')
#		#var gPosition = get_global_transform_with_canvas().affine_inverse().basis_xform(event.global_position)
#		var gPosition = get_global_transform() * event.position
#
#
#		emit_signal("SelectImage", img_type, curDate, gPosition, event.position, event)
