
extends Node

const SLOT_SIZE = 64

var char_database
var wpn_database
var item_database

var screen_size
var window_size

var active_units = []
var barracks_units = []

class unit:
	var id
	var name
	var wpn_vector = []
	var item_vector = []


func _ready():
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()

	char_database = get_node("/root/character_database")
	wpn_database = get_node("/root/weapon_database")
	item_database = get_node("/root/item_database")

	instance_unit(0, "Party")
	instance_unit(0, "Party")
	instance_unit(0, "Party")
	get_node("UnitManagement/ActiveParty").set_max_columns(3)
	for unit in active_units:
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
	
	instance_unit(1, "Barracks")
	instance_unit(0, "Barracks")
	get_node("UnitManagement/Barracks").set_max_columns(3)
	for unit in barracks_units:
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(unit.id), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)

	size_update()
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	#print(get_node("UnitManagement/ActiveParty").get_selected_items().size())
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 or get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		get_node("UnitManagement/Swap").set_disabled(false)
	else:
		get_node("UnitManagement/Swap").set_disabled(true)
# Função temporaria de teste
func instance_unit(id, path):
	var unit_instance = unit.new()
	unit_instance.id = id
	unit_instance.name = char_database.get_char_name(id)

	if path == "Party":
		active_units.append(unit_instance)
	elif path == "Barracks":
		barracks_units.append(unit_instance)

func size_update():
	OS.set_window_resizable(0)
	set_size(window_size)
	get_node("UnitManagement/ActiveParty").set_size(Vector2(window_size.x/2, window_size.y/2))
	get_node("UnitManagement/Barracks").set_size(Vector2(window_size.x/2, window_size.y/2))

# #################################### #
# ##### UNIT MANAGEMENT FUNCTIONS #### # 
# #################################### #

func swap_units():
	# Active and Barracks units selected
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 and get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		var a_unit = active_units[get_node("UnitManagement/ActiveParty").get_selected_items()[0]]
		var a_local_id = get_node("UnitManagement/ActiveParty").get_selected_items()[0]
		var b_unit = barracks_units[get_node("UnitManagement/Barracks").get_selected_items()[0]]
		var b_local_id = get_node("UnitManagement/Barracks").get_selected_items()[0]
		active_units.append(b_unit)
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.append(a_unit)
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		get_node("UnitManagement/ActiveParty").remove_item(a_local_id)
		barracks_units.remove(b_local_id)
		get_node("UnitManagement/Barracks").remove_item(b_local_id)
		
	# Only Active unit selected // vai ter tamanho maximo de barracks?
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() != 0 and get_node("UnitManagement/Barracks").get_selected_items().size() == 0):
		var a_unit = active_units[get_node("UnitManagement/ActiveParty").get_selected_items()[0]]
		var a_local_id = get_node("UnitManagement/ActiveParty").get_selected_items()[0]
		barracks_units.append(a_unit)
		get_node("UnitManagement/Barracks").add_item(char_database.get_char_name(a_unit.id), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		get_node("UnitManagement/ActiveParty").remove_item(a_local_id)
	# Only Barracks unit selected
	if (get_node("UnitManagement/ActiveParty").get_selected_items().size() == 0 and get_node("UnitManagement/Barracks").get_selected_items().size() != 0):
		var b_unit = barracks_units[get_node("UnitManagement/Barracks").get_selected_items()[0]]
		var b_local_id = get_node("UnitManagement/Barracks").get_selected_items()[0]
		active_units.append(b_unit)
		get_node("UnitManagement/ActiveParty").add_item(char_database.get_char_name(b_unit.id), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.remove(b_local_id)
		get_node("UnitManagement/Barracks").remove_item(b_local_id)
	
func _on_Swap_pressed():
	swap_units()
