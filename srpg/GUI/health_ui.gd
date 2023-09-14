extends Control

@onready var heart_ui_empty = $HeartUIEmpty
@onready var hear_ui_full = $HearUIFull


var hearts : int = 4 : set = set_hearts
var max_hearts : int = 4 : set = set_max_hearts

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
#	if hear_ui_full != null:
#		hear_ui_full.set_size(Vector2(4, 4))
	
func set_max_hearts(value):
	max_hearts = max(value, 1)


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", set_hearts)
