extends Camera2D

@export var TopLeftLimit : Marker2D
@export var BottomRight : Marker2D

func _ready():
	limit_top = TopLeftLimit.global_position.y
	limit_left = TopLeftLimit.global_position.x
	limit_right = BottomRight.global_position.x
	limit_bottom = BottomRight.global_position.y

