extends Node2D

signal ChangeMaxHP(max_hp)
signal InitHP(hp)
signal ChangeHp(change_hp, demage)
signal DiePlayer()

var max_hp : int = 100 : set = SetMaxHP
func SetMaxHP(value):
	max_hp = value
	emit_signal("ChangeMaxHP", max_hp)
	
var hp : int = 100

func Init():
	max_hp = 100
	hp = 100
	emit_signal("InitHP", hp)

func Demage(demage):
	hp = hp - demage
	emit_signal("ChangeHp", hp, demage)
