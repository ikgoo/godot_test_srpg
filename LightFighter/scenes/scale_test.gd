extends Button

@export var scale_val : float

func _on_pressed():
	SignalManager.emit_signal("ui_scale_change", scale_val)
