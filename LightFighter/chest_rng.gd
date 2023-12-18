extends Chest

@export var number_of_items : int

func set_items():
	for nb in number_of_items:
		inventory.add_item(ItemManager.get_item( items[ randi() % items.size() ]))

