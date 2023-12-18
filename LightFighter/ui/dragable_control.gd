extends ScaleControl
class_name DragableControl

var dragging : bool = false
var offset : Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	gui_input.connect(_on_gui_input.bind())
	
func _process(delta):
	if dragging:
		global_position = get_viewport().get_mouse_position() - offset

func _on_gui_input(event : InputEvent):
	if not dragging and event.is_action_pressed("left_click"):
		var mouse_position = get_viewport().get_mouse_position()
		#offset = size
		dragging = true
		
		get_viewport().set_input_as_handled()
		move_to_front()
	
	elif dragging and event.is_action_released("left_click"):
		dragging = false
		get_viewport().set_input_as_handled()
