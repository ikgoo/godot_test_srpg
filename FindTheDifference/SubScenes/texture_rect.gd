extends TextureRect

signal SelectImage(sctDate, globalPosition, localPosition)

# 현재 날짜
var curDate : String
#현재 날짜의 정보
var curData : Variant

# 메인 게임중이면 이미지의 타입을 넘겨줌
var img_type : String = "NONE"

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT :
		#var gPosition = get_global_transform_with_canvas().affine_inverse().basis_xform(event.global_position)
		var gPosition = get_global_transform() * event.position


		emit_signal("SelectImage", img_type, curDate, gPosition, event.position, event)
