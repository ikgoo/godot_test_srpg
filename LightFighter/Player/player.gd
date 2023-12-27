extends CharacterBody2D

const MAX_SPEED : float = 100.0
const SPEED : float = 500.0

@onready var interactable_zone = $interactable_zone
@onready var interact_labels : Control = $interactable_labels

var current_interactable

func _ready():
	SignalManager.connect("item_dropped", _on_item_dropped)

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction.x == 0:
		velocity.x = move_toward(velocity.x, 0, SPEED * delta)
	else:
		velocity.x = move_toward(velocity.x, direction.x * MAX_SPEED, SPEED * delta)
	
	if direction.y == 0:
		velocity.y = move_toward(velocity.y, 0, SPEED * delta)
	else:
		velocity.y = move_toward(velocity.y, direction.y * MAX_SPEED, SPEED * delta)

	move_and_slide()

func _process(_delta):
	if not current_interactable:
		var overlapping_area = interactable_zone.get_overlapping_areas()
		
		if overlapping_area.size() > 0:
			if overlapping_area[0].has_method("interact"):
				current_interactable = overlapping_area[0]
				interact_labels.display(current_interactable)

func _input(event : InputEvent):
	if event.is_action_pressed("interact") and current_interactable:
		current_interactable.interact()
		interact_labels.hide()

func _on_interactable_zone_area_exited(area):
	if current_interactable == area:
		if current_interactable.has_method("out_of_range"):
			current_interactable.out_of_range()
			
		interact_labels.hide()
		current_interactable = null

func _on_item_dropped(item):
	var floor_item = ResourceManager.tscn.floor_item.instantiate()
	floor_item.item = item
	get_parent().add_child(floor_item)
	floor_item.position = position


