extends NinePatchRect
class_name ItemInfo

@onready var item_name = $title/Label
@onready var line_container : VBoxContainer = $line_container

var type_names = {
	GameEnums.EQUIPMENT_TYPE.NONE: "Material",
	GameEnums.EQUIPMENT_TYPE.HEAD: "Head",
	GameEnums.EQUIPMENT_TYPE.CHEST: "Armor",
	GameEnums.EQUIPMENT_TYPE.OFFHAND: "Offhand",
	GameEnums.EQUIPMENT_TYPE.MAIN_HAND: "Weapon",
}

func dispaly(slot : InventorySlot):
	for c in line_container.get_children():
		line_container.remove_child(c)
		c.queue_free()
		
	size.x = 0
	global_position = slot.global_position + slot.size
	item_name.text = slot.item.item_name
	var line_type = ItemInfoLine.new(type_names[slot.item.equipment_type], "normal")
	line_container.add_child(line_type)

	var components : Dictionary = slot.item.components
	if components.has("base_stats"):
		line_container.add_child(ResourceManager.tscn.splitter.instantiate())
		var base_stat_lines = components.base_stats.get_lines()
		
		for line in base_stat_lines:
			line_container.add_child(line)
	
	show()
	
	get_tree().process_frame
	
	var max_width = 0
	var height = 0
	for c : Control in line_container.get_children():
		height += c.size.y + 3
		if c.size.x > max_width:
			max_width = c.size.x
	
	size = Vector2(max_width + 30, height + 8)
