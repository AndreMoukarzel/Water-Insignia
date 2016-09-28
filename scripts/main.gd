
extends Node

var combat_scn = preload("res://scenes/CombatNode.tscn")
var management_scn = preload("res://scenes/ManagementNode.tscn")
var scn

var units_vector = []

# Unit class - for instancing an enemy or ally
class unit:
	var id # Unit ID in the character database
	var name
	var level 
	var wpn_vector = [] # Array containing the unit's available weapons, be it natural or not
	var item_vector = [] # Array containing the unit's available items


func _ready():
	var level = combat_scn.instance()

	level.set_name("level")
	add_child(level)


# Assumes it will always be changing scenes, not reloading the same
func set_level(mode):
	if mode == "combat":
		scn = combat_scn
		units_vector = get_node("level").active_units
	elif mode == "management":
		scn = management_scn
		units_vector = get_node("level").allies_vector

	var remove = 1
	while remove:
		remove = 0
		var i = 0
		for unit in units_vector:
			if unit == null:
				remove = 1
				units_vector.remove(i)
			i += 1

	var level = scn.instance()
	get_node("level").set_name("old")
	level.set_name("level")
	if mode == "combat":
		level.allies_vector = units_vector
	else:
		level.active_units = units_vector
	add_child(level)
	get_node("old").queue_free()


func save():
	var savedict = {
		newgame = 0,
		party = units_vector
		}
	return savedict


func save_game():
	var savegame = File.new()
	var savedata = save()
	savegame.open("user://savegame.save", File.WRITE)
	savegame.store_line(savedata.to_json())
	savegame.close()


func load_game():
	var savegame = File.new()
	if !savegame.file_exists("user://savegame.save"):
		return #Error!  We don't have a save to load

	savegame.open("user://savegame.save", File.READ)
	while (!savegame.eof_reached()):
		pass
	savegame.close()