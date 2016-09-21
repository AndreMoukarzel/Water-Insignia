
extends Node

const SLOT_SIZE = 64

var last_selected_party = -1
var last_selected_barracks = -1

var item_swap_mode = 0 # 0 = barracks, 1 = storage

var char_database
var wpn_database
var item_database

var screen_size
var window_size

var active_units = []
var barracks_units = []

#var active_unit_weapons = []
#var barracks_unit_weapons = []

var storage_weapons = []
var storage_items = []

var current_screen 

class unit:
	var id
	var name
	var wpn_vector = []
	var item_vector = []

class weapon:
	var id
	var name
	var durability


func _ready():
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()

	char_database = get_node("/root/character_database")
	wpn_database = get_node("/root/weapon_database")
	item_database = get_node("/root/item_database")

	# instance testing, will be replaced
	instance_unit(1, "Barracks")
	instance_unit(0, "Barracks")

	for unit in barracks_units:
		if unit.name == "bat":
			instance_weapon("Bat Fangs", unit)
			instance_weapon("Bat Wings", unit)
		if unit.name == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
	
	#settings for itemlists
	get_node("UnitManagement/ActiveParty").set_max_columns(3)
	get_node("UnitManagement/Barracks").set_max_columns(3)
	get_node("ItemManagement/ActiveParty").set_max_columns(3)
	get_node("ItemManagement/Barracks").set_max_columns(3)
	get_node("ItemManagement/ActivePartyWeapons").set_max_columns(4)
	get_node("ItemManagement/ActivePartyItems").set_max_columns(4)
	get_node("ItemManagement/BarracksWeapons").set_max_columns(4)
	get_node("ItemManagement/BarracksItems").set_max_columns(4)
	
	#populating character lists
	for unit in active_units:
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		get_node("ItemManagement/ActiveParty").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
	
	for unit in barracks_units:
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		get_node("ItemManagement/Barracks").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)

	size_update()
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	var party = get_node("UnitManagement/ActiveParty")
	var barracks = get_node("UnitManagement/Barracks")
	# Unit management
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 or get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		if (get_node("UnitManagement/ActiveParty").get_selected_items().size() == 0):
			if (get_node("UnitManagement/ActiveParty").get_item_count() != 4):
				get_node("UnitManagement/Swap").set_disabled(false)
			else:
				get_node("UnitManagement/Swap").set_disabled(true)
		else:
			if (get_node("UnitManagement/ActiveParty").get_item_count() != 1):
				get_node("UnitManagement/Swap").set_disabled(false)
			else:
				get_node("UnitManagement/Swap").set_disabled(true)
	else:
		get_node("UnitManagement/Swap").set_disabled(true)
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 and get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		get_node("UnitManagement/Swap").set_disabled(false)
		
	# Item management
	if (get_node("ItemManagement/ActiveParty").get_selected_items().size() != 0):
		#populate and show weapons list for active party member
		if (last_selected_party != get_node("ItemManagement/ActiveParty").get_selected_items()[0]):
			get_node("ItemManagement/ActivePartyWeapons").clear()
			for weapon in active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]].wpn_vector:
				get_node("ItemManagement/ActivePartyWeapons").add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
				get_node("ItemManagement/ActivePartyWeapons").set_item_tooltip(get_node("ItemManagement/ActivePartyWeapons").get_item_count() - 1, weapon.name)
			last_selected_party = get_node("ItemManagement/ActiveParty").get_selected_items()[0]
	# Vai precisar da condição do mode tambem (ser o modo de trocar com os membros das barracks, não com o storage)
	if (get_node("ItemManagement/Barracks").get_selected_items().size() != 0):
		#populate and show weapons list for barracks member
		if (last_selected_barracks != get_node("ItemManagement/Barracks").get_selected_items()[0]):
			get_node("ItemManagement/BarracksWeapons").clear()
			for weapon in barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]].wpn_vector:
				get_node("ItemManagement/BarracksWeapons").add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
				get_node("ItemManagement/BarracksWeapons").set_item_tooltip(get_node("ItemManagement/BarracksWeapons").get_item_count() - 1, weapon.name)
			last_selected_barracks = get_node("ItemManagement/Barracks").get_selected_items()[0]
	
	# Condições do botão de swap
	if (item_swap_mode == 0 and get_node("ItemManagement/ActiveParty").get_selected_items().size() != 0 and get_node("ItemManagement/Barracks").get_selected_items().size() != 0):
		if (get_node("ItemManagement/ActivePartyWeapons").get_selected_items().size() != 0 or get_node("ItemManagement/BarracksWeapons").get_selected_items().size() != 0):
			get_node("ItemManagement/SwapItems").set_disabled(false)
	else:
		get_node("ItemManagement/SwapItems").set_disabled(true)

func size_update():
	OS.set_window_resizable(0)
	set_size(window_size)
	get_node("Selection").set_size(window_size)
	get_node("PartyMenu").set_size(window_size)
	
	get_node("UnitManagement/ActiveParty").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("UnitManagement/Barracks").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("UnitManagement/Barracks").set_pos((Vector2(window_size.x - 40 - get_node("UnitManagement/Barracks").get_size().x, 40)))

	get_node("ItemManagement/ActiveParty").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("ItemManagement/Barracks").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("ItemManagement/Barracks").set_pos((Vector2(window_size.x - 40 - get_node("ItemManagement/Barracks").get_size().x, 40)))

	get_node("ItemManagement/ActivePartyWeapons").set_size(Vector2(300, 73))
	get_node("ItemManagement/ActivePartyWeapons").set_pos(Vector2(40, 300))
	get_node("ItemManagement/ActivePartyItems").set_size(Vector2(300, 73))
	get_node("ItemManagement/ActivePartyItems").set_pos(Vector2(40, 400))
	get_node("ItemManagement/BarracksWeapons").set_size(Vector2(300, 73))
	get_node("ItemManagement/BarracksWeapons").set_pos(Vector2(get_node("ItemManagement/Barracks").get_pos().x, 300))
	get_node("ItemManagement/BarracksItems").set_size(Vector2(300, 73))
	get_node("ItemManagement/BarracksItems").set_pos(Vector2(get_node("ItemManagement/Barracks").get_pos().x, 400))
	
	get_node("ItemManagement/StorageWeapons").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("ItemManagement/StorageWeapons").set_pos((Vector2(window_size.x - 40 - get_node("ItemManagement/StorageWeapons").get_size().x, 40)))
	get_node("ItemManagement/StorageItems").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("ItemManagement/StorageItems").set_pos((Vector2(get_node("ItemManagement/Barracks").get_pos().x, get_node("ItemManagement/Barracks").get_pos().y + 220)))
# #################################### #
# ##### UNIT MANAGEMENT FUNCTIONS #### # 
# #################################### #

func _on_Swap_pressed():
	# Active and Barracks units selected
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 and get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		var a_unit = active_units[get_node("UnitManagement/ActiveParty").get_selected_items()[0]]
		var a_local_id = get_node("UnitManagement/ActiveParty").get_selected_items()[0]
		var b_unit = barracks_units[get_node("UnitManagement/Barracks").get_selected_items()[0]]
		var b_local_id = get_node("UnitManagement/Barracks").get_selected_items()[0]
		active_units.append(b_unit)
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		get_node("ItemManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.append(a_unit)
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		get_node("ItemManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		get_node("UnitManagement/ActiveParty").remove_item(a_local_id)
		get_node("ItemManagement/ActiveParty").remove_item(a_local_id)
		barracks_units.remove(b_local_id)
		get_node("UnitManagement/Barracks").remove_item(b_local_id)
		get_node("ItemManagement/Barracks").remove_item(b_local_id)
		
	# Only Active unit selected // vai ter tamanho maximo de barracks?
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 and get_node("UnitManagement/Barracks").get_selected_items().size() == 0):
		var a_unit = active_units[get_node("UnitManagement/ActiveParty").get_selected_items()[0]]
		var a_local_id = get_node("UnitManagement/ActiveParty").get_selected_items()[0]
		barracks_units.append(a_unit)
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		get_node("ItemManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		get_node("UnitManagement/ActiveParty").remove_item(a_local_id)
		get_node("ItemManagement/ActiveParty").remove_item(a_local_id)
	# Only Barracks unit selected
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() == 0 and get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		var b_unit = barracks_units[get_node("UnitManagement/Barracks").get_selected_items()[0]]
		var b_local_id = get_node("UnitManagement/Barracks").get_selected_items()[0]
		active_units.append(b_unit)
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		get_node("ItemManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.remove(b_local_id)
		get_node("UnitManagement/Barracks").remove_item(b_local_id)
		get_node("ItemManagement/Barracks").remove_item(b_local_id)
		
func _on_SwapItems_pressed():
	if (item_swap_mode == 0):
		# Active and Barracks weapons selected
		if (get_node("ItemManagement/ActivePartyWeapons").get_selected_items().size() != 0 and get_node("ItemManagement/BarracksWeapons").get_selected_items().size() != 0):
			var a_unit = active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[get_node("ItemManagement/ActivePartyWeapons").get_selected_items()[0]]
			var a_local_wpn_id = get_node("ItemManagement/ActivePartyWeapons").get_selected_items()[0]
			var b_unit = barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]]
			var b_wpn = b_unit.wpn_vector[get_node("ItemManagement/BarracksWeapons").get_selected_items()[0]]
			var b_local_wpn_id = get_node("ItemManagement/BarracksWeapons").get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]].wpn_vector.append(b_wpn)
			get_node("ItemManagement/ActivePartyWeapons").add_item("", load(str("res://resources/sprites/weapons/",b_wpn.name,".tex")), 1)
			get_node("ItemManagement/ActivePartyWeapons").set_item_tooltip(get_node("ItemManagement/ActivePartyWeapons").get_item_count() - 1, b_wpn.name)
			barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]].wpn_vector.append(a_wpn)
			get_node("ItemManagement/BarracksWeapons").add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			get_node("ItemManagement/BarracksWeapons").set_item_tooltip(get_node("ItemManagement/ActivePartyWeapons").get_item_count() - 1, a_wpn.name)
			active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			get_node("ItemManagement/ActivePartyWeapons").remove_item(a_local_wpn_id)
			barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]].wpn_vector.remove(b_local_wpn_id)
			get_node("ItemManagement/BarracksWeapons").remove_item(b_local_wpn_id)
			
		# Only Active unit weapon selected
		if (get_node("ItemManagement/ActivePartyWeapons").get_selected_items().size() != 0 and get_node("ItemManagement/BarracksWeapons").get_selected_items().size() == 0):
			var a_unit = active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[get_node("ItemManagement/ActivePartyWeapons").get_selected_items()[0]]
			var a_local_wpn_id = get_node("ItemManagement/ActivePartyWeapons").get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]].wpn_vector.append(a_wpn)
			get_node("ItemManagement/BarracksWeapons").add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			get_node("ItemManagement/BarracksWeapons").set_item_tooltip(get_node("ItemManagement/ActivePartyWeapons").get_item_count(), a_wpn.name)
			active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			get_node("ItemManagement/ActivePartyWeapons").remove_item(a_local_wpn_id)
		# Only Barracks unit weapon selected
		if (get_node("ItemManagement/ActivePartyWeapons").get_selected_items().size() == 0 and get_node("ItemManagement/BarracksWeapons").get_selected_items().size() != 0):
			var b_unit = barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]]
			var b_wpn = b_unit.wpn_vector[get_node("ItemManagement/BarracksWeapons").get_selected_items()[0]]
			var b_local_wpn_id = get_node("ItemManagement/BarracksWeapons").get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[get_node("ItemManagement/ActiveParty").get_selected_items()[0]].wpn_vector.append(b_wpn)
			get_node("ItemManagement/ActivePartyWeapons").add_item("", load(str("res://resources/sprites/weapons/",b_wpn.name,".tex")), 1)
			get_node("ItemManagement/ActivePartyWeapons").set_item_tooltip(get_node("ItemManagement/ActivePartyWeapons").get_item_count(), b_wpn.name)
			barracks_units[get_node("ItemManagement/Barracks").get_selected_items()[0]].wpn_vector.remove(b_local_wpn_id)
			get_node("ItemManagement/BarracksWeapons").remove_item(b_local_wpn_id)


# Corrected unit stancing in ManagementNode
func _on_StorageBarracks_pressed():
	if (item_swap_mode == 0):
		get_node("ItemManagement/Barracks").hide()
		get_node("ItemManagement/BarracksWeapons").hide()
		get_node("ItemManagement/BarracksItems").hide()
		get_node("ItemManagement/StorageWeapons").show()
		get_node("ItemManagement/StorageItems").show()
		item_swap_mode = 1
	else:
		get_node("ItemManagement/Barracks").show()
		get_node("ItemManagement/BarracksWeapons").show()
		get_node("ItemManagement/BarracksItems").show()
		get_node("ItemManagement/StorageWeapons").hide()
		get_node("ItemManagement/StorageItems").hide()
		item_swap_mode = 0

# ################################ #
# ###### MENU FUNCTIONALITY ###### # 
# ################################ #


func _on_Units_pressed():
	get_node("Selection").hide()
	get_node("PartyMenu").show()


func _on_Repair_pressed():
	pass # replace with function body


func _on_Shop_pressed():
	pass # replace with function body


func _on_ManageUnits_pressed():
	get_node("PartyMenu").hide()
	get_node("UnitManagement").show()

	current_screen = "UnitManagement"


func _on_Return_pressed():
	get_node(current_screen).hide()
	if (current_screen == "UnitManagement" or current_screen == "ItemManagement"):
		get_node("PartyMenu").show()
		# Deselect when returning
		for unit in get_node("UnitManagement/ActiveParty").get_selected_items():
			get_node("UnitManagement/ActiveParty").unselect(unit)
		for unit in get_node("UnitManagement/Barracks").get_selected_items():
			get_node("UnitManagement/Barracks").unselect(unit)
		for item in get_node("ItemManagement/ActiveParty").get_selected_items():
			get_node("ItemManagement/ActiveParty").unselect(item)
		for item in get_node("ItemManagement/Barracks").get_selected_items():
			get_node("ItemManagement/Barracks").unselect(item)
		


func _on_ManageItems_pressed():
	get_node("PartyMenu").hide()
	get_node("ItemManagement").show()

	current_screen = "ItemManagement"
	
# Funções temporarias de teste
func instance_unit(id, path):
	var unit_instance = unit.new()
	unit_instance.id = id
	unit_instance.name = char_database.get_char_name(id)

	if path == "Party":
		active_units.append(unit_instance)
	elif path == "Barracks":
		barracks_units.append(unit_instance)

func instance_weapon(name, owner):
	
	var id = wpn_database.get_wpn_id(name)
	
	# Data instancing segment
	var wpn_instance = weapon.new()
	wpn_instance.id = id
	wpn_instance.name = name
	wpn_instance.durability = wpn_database.get_durability(id)
	owner.wpn_vector.append(wpn_instance)

# Funções temporarias de teste
