
extends Node2D

var master

func _ready():
	var database = get_node("/root/character_database")

	var hp_max = database.get_hp(master.id, master.level)
	var mp_max = database.get_mp(master.id, master.level)

	get_node("LifeBar").set_size(Vector2(hp_max * 3, 16))
	get_node("LifeBar").set_max(hp_max)
	get_node("LifeBar").set_value(master.hp_current)

	get_node("ManaBar").set_size(Vector2(mp_max * 3, 16))
	get_node("ManaBar").set_max(mp_max)
	get_node("ManaBar").set_value(master.mp_current)

func update():
	get_node("LifeBar").set_value(master.hp_current)
	get_node("ManaBar").set_value(master.mp_current)