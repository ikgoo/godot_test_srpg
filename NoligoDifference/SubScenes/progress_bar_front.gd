extends NinePatchRect

signal change_size_x(val)

var currentPer = 70
var maxPer : float = (1066 - currentPer) * 1.0

var value : float = 0 : set = setVal

func setVal(val):
	value = val
	size.x = val
	
	emit_signal("change_size_x",val )
