
extends Node

var menu_scn = preload("res://scenes/MainMenu.tscn")
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
	var id
	var name
	var level 
	var wpn_vector = []
	var item_vector = []


func _ready():
	var level = menu_scn.instance()
	get_node("Music").set_stream(load("res://resources/sounds/bgm/Battle.ogg"))
	get_node("Music").set_loop(true)
	get_node("Music").play()
	
	level.set_name("level")
	add_child(level)


func start_game():
	var level = combat_scn.instance()
	get_node("level").set_name("old")
	level.set_name("level")
	add_child(level)
	get_node("old").queue_free()


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
	save_game()

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
	var total_units = []
	# O vetor abaixo indica o tamanho do vetor de armas,
	# sequencialmente, para cada unidade do vetor de   
	# unidades total, e o vetor de armas total tem todas
	# as armas sequencialmente, na ordem do total_units
	var weapons_vector_size_per_unit = []
	var total_weapons = []
	var items_vector_size_per_unit = []
	var total_items = []
	
	for unit in units_vector:
		total_units.append(unit)
	for unit in barracks:
		total_units.append(unit)
	
	for unit in total_units:
		for weapon in unit.wpn_vector:
			total_weapons.append(weapon)
		for item in unit.item_vector:
			total_items.append(item)
	
	var units = []
	var weapons = []
	var items = []
	
	var storage_weapons = []
	var storage_items = []
	
	for unit in total_units:
		# O numero de armas e items de cada unidade esta guardado ai mesmo
		units.append( { id = unit.id, level = unit.level, wpn_num = unit.wpn_vector.size(), item_num = unit.item_vector.size() })
	for weapon in total_weapons:
		weapons.append( { id = weapon.id, durability = weapon.durability })
	for item in total_items:
		items.append( { id = item.id, amount = item.amount })
	
	for weapon in storage_wpn:
		storage_weapons.append( { id = weapon.id, durability = weapon.durability })
	for item in storage_itm:
		items.append( { id = item.id, amount = item.amount })
		
	# Begin dictionary
	var savedict = {
		newgame = 0,
		first_play = first_play,
		stage = stage,
		quesha = quesha,
		
		active_units_size = units_vector.size(),
		barracks_units_size = barracks.size(),
		
		units = units,
		weapons = weapons,
		items = items,
		
		storage_weapons = storage_weapons,
		storage_items = storage_items
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