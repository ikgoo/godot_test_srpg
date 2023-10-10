extends Node2D


@export var player : CharacterBody2D

var slash = preload("res://Attacks/slash.tscn")
var weapon_list : Dictionary = {
	"slash" : preload("res://Attacks/slash.tscn")
}

var use_weapon_list : Array = []

func _ready():
	var ins : calss_attack = weapon_list["slash"].instantiate()
	ins.init(player)
	add_child(ins)
	
	use_weapon_list.append(ins)
	
	

func _process(delta):
	pass
