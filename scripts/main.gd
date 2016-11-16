
extends Node

onready var char_database = get_node("/root/character_database")
onready var wpn_database = get_node("/root/weapon_database")
onready var item_database = get_node("/root/item_database")

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
class Unit:
	var id
	var name
	var level 
	var wpn_vector = []
	var item_vector = []

	func _init(id, level, db):
		self.id = id
		self.level = level
		self.name = db.get_char_name(id)

	func get_id():
		return id

	func get_level():
		return level

	func get_wpn_vector():
		return wpn_vector

	func get_item_vector():
		return item_vector


class weapon:
	var id # Weapon ID in the weapon database
	var name # Weapon name in the weapon database
	var durability # Weapon durability
	var type # Weapon type - sword, axe, spear or natural

	func _init(id, database):
		self.id = id
		self.name = database.get_wpn_name(id)
		self.durability = database.get_durability(id)
		self.type = database.get_wpn_type(id)
 
# GETTERS
	func get_id():
		return id

	func get_name():
		return name

	func get_durability():
		return durability

	func get_type():
		return type

	# SETTERS
	func set_durability(durability):
		self.durability = durability

	func decrease_durability():
		self.durability -= 1


class item:
	var id
	var name 
	var type # HP and/or Effect
	var hp # How much the HP will be affected by the item
	var status # Item's status effect (poison, speed up, ...)
	var max_amount # Item's total amount
	var amount

	func _init(id, database):
		self.id = id
		self.name = database.get_item_name(id)
		self.type = database.get_item_type(id)
		self.hp = database.get_item_hp(id)
		self.status = database.get_item_status(id)
		self.max_amount = database.get_item_stack(id)
		self.amount = self.max_amount

	func get_id():
		return id

	func get_name():
		return name

	func get_type():
		return type

	func get_hp():
		return hp

	func get_status():
		return status

	func get_max_amount():
		return max_amount

	func get_amount():
		return amount

	# SETTERS
	func set_amount(amount):
		self.amount = amount


func _ready():
	var level = menu_scn.instance()
	
	level.set_name("level")
	add_child(level)


func start_game():
	var level = combat_scn.instance()
	get_node("level").set_name("old")
	level.set_name("level")
	add_child(level)
	get_node("old").queue_free()
	get_node("Music").set_stream(load("res://resources/sounds/bgm/Battle.ogg"))
	get_node("Music").set_loop(true)
	get_node("Music").play()


# Assumes it will always be changing scenes, not reloading the same
func set_level(mode):
	if mode == "combat":
		scn = combat_scn
		get_node("Music").set_stream(load("res://resources/sounds/bgm/Battle.ogg"))
		get_node("Music").set_loop(true)
		get_node("Music").play()
		units_vector = get_node("level").active_units
		barracks = get_node("level").barracks_units
		storage_wpn = get_node("level").storage_weapons
		storage_itm = get_node("level").storage_items
	elif mode == "management":
		scn = management_scn
		get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
		get_node("Music").set_loop(true)
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

	first_play = savedata.first_play
	stage = savedata.stage
	quesha = savedata.quesha
	
	var wpns_iter
	var current_wpn = 0
	var items_iter
	var current_item = 0

	for i in range(0, savedata.active_units_size):
		wpns_iter = 0
		items_iter = 0
		
		var u = savedata.units[i]
		units_vector.append(Unit.new(u.id, u.level, char_database))
		while (wpns_iter < u.wpn_num):
			units_vector[i].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
			units_vector[i].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
			wpns_iter += 1
			current_wpn += 1
		while (items_iter < u.item_num):
			units_vector[i].item_vector.append(item.new(savedata.items[current_item].id, item_database))
			units_vector[i].item_vector[items_iter].amount = savedata.items[current_item].amount
			items_iter += 1
			current_item += 1
	
	for i in range(savedata.active_units_size, savedata.barracks_units_size):
		wpns_iter = 0
		items_iter = 0
		
		var u = savedata.units[i]
		barracks.append(Unit.new(u.id, u.level, char_database))
		while (wpns_iter < u.wpn_num):
			barracks[i].wpn_vector.append(weapon.new(savedata.weapons[current_wpn].id, wpn_database))
			barracks[i].wpn_vector[wpns_iter].durability = savedata.weapons[current_wpn].durability
			wpns_iter += 1
			current_wpn += 1
		while (items_iter < u.item_num):
			barracks[i].item_vector.append(item.new(savedata.items[current_item].id, item_database))
			barracks[i].item_vector[items_iter].amount = savedata.items[current_item].amount
			items_iter += 1
			current_item += 1
	
	if (current_wpn != savedata.weapons.size() or current_item != savedata.items.size()):
		#Error handler, did not load correctly
		print("Error loading data!")
	
	current_wpn = 0
	current_item = 0
	
	for weapon in savedata.storage_weapons:
		storage_wpn.append(weapon.new(weapon.id, wpn_database))
		storage_wpn[current_wpn].durability = weapon.durability
		current_wpn += 1
	for item in savedata.storage_items:
		storage_itm.append(item.new(item.id, item_database))
		storage_itm[current_item].amount = item.amount
		current_item += 1
	
	if (current_wpn != savedata.storage_weapons.size() or current_item != savedata.storage_items.size()):
		#Error handler, did not load correctly
		print("Error loading data!")
	
	print ("Finished loading data!")
	
	scn = management_scn
	get_node("Music").set_stream(load("res://resources/sounds/bgm/Management.ogg"))
	get_node("Music").set_loop(true)
	get_node("Music").play()
	
	var level = scn.instance()
	get_node("level").set_name("old")
	level.set_name("level")
	
	level.active_units = units_vector
	level.barracks_units = barracks
	level.storage_weapons = storage_wpn
	level.storage_items = storage_itm
	add_child(level)
	get_node("old").queue_free()
	# Continue population weapons and items, need more details on unit maybe