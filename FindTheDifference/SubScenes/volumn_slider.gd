extends HSlider

@export var bus_name : String

var bus_index : int

func _ready():
	bus_index = AudioServer.get_bus_index(bus_name)
	value_changed.connect(_value_changed)
	
func _value_changed(value):
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(value)
	)
