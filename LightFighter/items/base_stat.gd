extends Resource
class_name BaseStat

var stat_ranges = []
var scale : float

func _init(data, value):
	scale = value
	
	for stat_range in data:
		stat_ranges.append(Stat_Range.new(stat_range))
		
	
func get_lines():
	var lines = []
	for stat_range : Stat_Range in stat_ranges:
		
		var stat_info = ResourceManager.stat_info[stat_range.stat]
		var value = stat_range.get_value(scale, stat_range.stat)
		var text = stat_info.display.replace("#", str(value))
		lines.append(ItemInfoLine.new(text, "normal"))
		
	return lines;
