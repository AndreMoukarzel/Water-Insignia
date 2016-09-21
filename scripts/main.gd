
extends Node

var mode = preload("res://scenes/CombatNode.tscn")

func _ready():
	var level = mode.instance()

	add_child(level)