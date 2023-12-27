extends ScaleControl

@onready var lbl_action : Label = $action
@onready var lbl_name : Label = $object_name

func display(interactable):
	lbl_action.text = "Press 'e' to " + interactable.action
	lbl_name.text = interactable.object_name
	show()
