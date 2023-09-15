extends TextureRect

var bCheck : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("gui_input", _on_gui_input)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_gui_input(event):
	if event is InputEventMouseButton and event.pressed and bCheck == false:
		bCheck = true
		get_parent().findCount += 1
		
