extends Control

@onready var hp_bar : ProgressBar = $HP

func _ready():
	GameManager.connect("ChangeMaxHP", ChangeMaxHP)
	GameManager.connect("InitHP", InitHP)
	GameManager.connect("ChangeHp", ChangeHp)


func ChangeMaxHP(max_hp):
	hp_bar.max_value = max_hp
	
func InitHP(hp):
	hp_bar.value = hp
	
func ChangeHp(change_hp, demage):
	hp_bar.value = change_hp
