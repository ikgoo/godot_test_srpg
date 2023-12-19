extends DragableControl

@onready var inventory_container = $inventory_container
@onready var equipment = $inventory_container/equipment
@onready var inventory_left = $inventory_container/inventory_left
@onready var inventory_right = $inventory_container/inventory_right

func _ready():
	super._ready()
	pass
	
