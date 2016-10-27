
extends Node

var combat_scn = preload("res://scenes/CombatNode.tscn")
var management_scn = preload("res://scenes/ManagementNode.tscn")
var scn

var first_play = 1

var victory = 0
var stage = 0
# gd = going down, implying we are not to increment the level counter once the battle is over
var gd = 0
var quesha = 1000

var units_vector = []
var barracks = []
var storage_wpn = []
var storage_itm = []

# Unit class - for instancing an enemy or ally
class unit:
	var id # Unit ID in the character database
	var name
	var level 
	var wpn_vector = [] # Array containing the unit's available weapons, be it natural or not
	var item_vector = [] # Array containing the unit's available items


func _ready():
	var level = management_scn.instance()
	get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
	get_node("Music").play()
	
	level.set_name("level")
	add_child(level)


# Assumes it will always be changing scenes, not reloading the same
func set_level(mode):
	if mode == "combat":
		scn = combat_scn
		get_node("Music").set_stream(load("res://resources/sounds/bgm/Battle.ogg"))
		get_node("Music").play()
		units_vector = get_node("level").active_units
		barracks = get_node("level").barracks_units
		storage_wpn = get_node("level").storage_weapons
		storage_itm = get_node("level").storage_items
	elif mode == "management":
		scn = management_scn
		get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
		get_node("Music").play()
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
	elif mode == "management":
		level.active_units = units_vector
		level.barracks_units = barracks
		level.storage_weapons = storage_wpn
		level.storage_items = storage_itm
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
	var savedata = {}
	savedata.parse_json(savegame.get_as_text())
	savegame.close()