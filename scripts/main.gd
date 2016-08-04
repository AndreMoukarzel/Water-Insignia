
extends Node

var mode = preload("res://scenes/CombatNode.xscn")

func _ready():
	var level = mode.instance()

	add_child(level)