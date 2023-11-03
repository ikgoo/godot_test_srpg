extends Control

signal SelectImage(name, sctDate, globalPosition, localPosition)

@onready var clear_img = $ClearImg
@onready var icon = $icon

@onready var game_image = $Mask/GameImage
@onready var animation_player = $AnimationPlayer
@onready var select_ok_image = $SelectOkImage
@onready var select_ok_color_rect = $SelectOkColorRect


# 현재 날짜
var curDate : int = 0
#현재 날짜의 정보
var curData : Variant = null

# 메인 게임중이면 이미지의 타입을 넘겨줌
var img_type : String = "NONE"

# 틀린 그림의 경우 해당 번호 정보
var diff_idx : int = -1


# 화면에 표현될 이미지 받기
var texture_normal : Texture2D = null

var is_clear : bool = false : set = SetIsClear
func SetIsClear(value):
	is_clear = value

func _ready():
	
	# Global.clear_mst_id
	if is_clear == true:
		clear_img.visible = true
		icon.visible = true
	elif curDate > Global.clear_mst_id+1:
		clear_img.visible = true
		
	if game_image != null:
		game_image.texture_normal = texture_normal

#func _on_game_image_pressed():
#	if is_clear == true or curDate != Global.clear_mst_id+1:
#		return
#
#	if name.find("Diff") >= 0:
#		emit_signal("SelectImage", name + str(diff_idx), curDate, get_global_mouse_position(), get_parent().get_local_mouse_position())
#	else:
#		emit_signal("SelectImage", name, curDate, get_global_mouse_position(), get_local_mouse_position())

#func _on_gui_input(event):
#	print('click01')
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT :
#		print('click02')
#		#var gPosition = get_global_transform_with_canvas().affine_inverse().basis_xform(event.global_position)
#		var gPosition = get_global_transform() * event.position
#
#
#		emit_signal("SelectImage", img_type, curDate, gPosition, event.position, event)


func _on_mouse_entered():
	if curDate == Global.clear_mst_id+1:
		select_ok_color_rect.visible = true
		animation_player.play("zoomin")
		


func _on_mouse_exited():
	if curDate == Global.clear_mst_id+1:
		select_ok_color_rect.visible = false
		animation_player.play("zoomout")




func _on_select_ok_image_pressed():
	if is_clear == true or curDate != Global.clear_mst_id+1:
		return
		
	if name.find("Diff") >= 0:
		emit_signal("SelectImage", name + str(diff_idx), curDate, get_global_mouse_position(), get_parent().get_local_mouse_position())
	else:
		emit_signal("SelectImage", name, curDate, get_global_mouse_position(), get_local_mouse_position())
