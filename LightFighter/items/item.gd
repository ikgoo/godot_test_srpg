extends TextureRect

class_name Item

var id : String
var item_name : String
var equipment_type : GameEnums.EQUIPMENT_TYPE = GameEnums.EQUIPMENT_TYPE.NONE
var stack_size : int = 1
var quantity : int = 1 : set = set_quantity
var level : int = 1
var components : Dictionary = {}
var lbl_quantity : Label

func _init( item_id : String, data : Dictionary):
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	id = item_id
	item_name = data.name
	level = data.level
	texture = ResourceManager.sprites[id] 
	
	if data.has("stack_size"):
		stack_size = data.stack_size
	
	if data.has("type"):
		equipment_type = GameEnums.EQUIPMENT_TYPE[data.type]
		
	if data.has("base_stats"):
		components['base_stats'] = BaseStat.new(data.base_stats, randf())
	
func _ready():
	lbl_quantity = Label.new()
	lbl_quantity.label_settings = ResourceManager.fonts[8]
	lbl_quantity.label_settings.font_color = Color.BLACK
	add_child(lbl_quantity)
	set_quantity(quantity)

func set_quantity(value):
	quantity = value
	
	if lbl_quantity:
		lbl_quantity.text = str(quantity)
		lbl_quantity.visible = quantity > 1

func add_item_quantity(value):
	var remainder = quantity + value - stack_size
	quantity = min(quantity + value, stack_size)
	set_quantity(quantity)
	return remainder
	
#func pick_item():
	#mouse_filter = Control.MOUSE_FILTER_IGNORE
	#
#func put_item():
	#mouse_filter = Control.MOUSE_FILTER_PASS
