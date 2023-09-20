extends Control

@onready var heart_empty_heart = $HeartEmptyHeart
@onready var heart_full_heart = $HeartFullHeart


var hearts : int = 4 : set = set_hearts
var max_hearts : int = 4 : set = set_max_hearts
var heart_min_w : int = 15

func set_hearts(value):
	hearts = clamp(value, 0, max_hearts)
	heart_full_heart.set_size(Vector2(heart_min_w * hearts, heart_full_heart.get_minimum_size().y))
#	if hear_ui_full != null:
#		hear_ui_full.set_size(Vector2(4, 4))
	
func set_max_hearts(value):
	max_hearts = max(value, 1)
	heart_empty_heart.set_size(Vector2(heart_min_w * max_hearts, heart_empty_heart.get_minimum_size().y))
	#heart_full_heart.set_size(heart_full_heart.get_minimum_size() * )
	
	


func _ready():
	self.max_hearts = PlayerStats.max_health
	self.hearts = PlayerStats.health
	PlayerStats.connect("health_changed", set_hearts)
