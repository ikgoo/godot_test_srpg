extends Node
class_name Stat_Range

var stat
var minimum : float
var maximum : float

func _init(data : Dictionary):
	stat = GameEnums.STAT[data.stat]
	minimum = data.minimum
	maximum = data.maximum
	
func get_value(scale, needed_stat):
	if stat == needed_stat:
		return round(lerp(minimum, maximum, scale))
		
	return 0
	
