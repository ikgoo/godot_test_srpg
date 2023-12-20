extends DragableControl

@onready var scale_slider = $setting_list/scale/HSlider

@onready var check_box = $setting_list/fullscreen/CheckBox
@onready var lbl_min = $setting_list/scale/min
@onready var lbl_max = $setting_list/scale/max


func _ready():
	super._ready()
	#check_box.set_pressed_no_signal()
	check_box.button_pressed = true
	check_box.emit_signal("toggled", true)
	lbl_min.text = "Min : %s" % scale_slider.min_value
	lbl_max.text = "Max : %s" % scale_slider.max_value
	

func _on_close_pressed():
	hide()


func _on_h_slider_gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
		SettingManager.set_scale(scale_slider.value)


func _on_check_box_toggled(toggled_on):
	SettingManager.set_fullscreen(toggled_on)


