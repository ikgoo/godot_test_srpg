extends ScaleControl

@export var inventory : Inventory

func _ready():
	super._ready()
	size.y = 20 + inventory.size.y
	
