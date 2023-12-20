extends ScaleControl
class_name DragableControl

@export var safe_zone : int = 30

var dragging : bool = false
var offset : Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	#gui_input.connect(_on_gui_input.bind())
	
	
func _process(delta):
	if dragging:
		set_pos(get_viewport().get_mouse_position() - offset)

func set_scale_val(value):
	super.set_scale_val(value)
	
	set_pos(global_position)
	

func set_pos(pos : Vector2):
	var scaled_size = size * scale
	var screen_size = get_viewport().get_visible_rect().size
	pos.x = clampf(pos.x, -scaled_size.x + safe_zone, screen_size.x - safe_zone)
	pos.y = clampf(pos.y, -scaled_size.y + safe_zone, screen_size.y - safe_zone)
	global_position = pos
	

func _gui_input(event : InputEvent):
	
	
	if not dragging and event.is_action_pressed("left_click"):
		var mouse_position = get_viewport().get_mouse_position()
		offset = mouse_position - global_position
		dragging = true
		
		get_viewport().set_input_as_handled()
		move_to_front()
	
	elif dragging and event.is_action_released("left_click"):
		dragging = false
		get_viewport().set_input_as_handled()
