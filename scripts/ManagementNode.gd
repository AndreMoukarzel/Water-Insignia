
extends Node

const SLOT_SIZE = 64

var last_selected_apunit = -1
var last_selected_bunit = -1
var last_selected_party = -1
var last_selected_barracks = -1
var populated_storage = 0
var last_selected_repair = -1
var last_selected_type = -1 # 0 = ap, 1 = barracks


var item_swap_mode = 0 # 0 = barracks, 1 = storage

# Nodes
onready var um_ap = get_node("UnitManagement/ActiveParty")
onready var um_b = get_node("UnitManagement/Barracks")
onready var um_s = get_node("UnitManagement/Swap")
onready var um_r = get_node("UnitManagement/Return")
onready var um_aps = get_node("UnitManagement/ActivePartyStatus")
onready var um_bs = get_node("UnitManagement/BarracksStatus")

onready var im_ap = get_node("ItemManagement/ActiveParty")
onready var im_apw = get_node("ItemManagement/ActivePartyWeapons")
onready var im_api = get_node("ItemManagement/ActivePartyItems")
onready var im_stw = get_node("ItemManagement/StorageWeapons")
onready var im_sti = get_node("ItemManagement/StorageItems")
onready var im_b = get_node("ItemManagement/Barracks")
onready var im_bw = get_node("ItemManagement/BarracksWeapons")
onready var im_bi = get_node("ItemManagement/BarracksItems")
onready var im_si = get_node("ItemManagement/SwapItems")
onready var im_sw = get_node("ItemManagement/SwapWeapons")
onready var im_r = get_node("ItemManagement/Return")

onready var rm_ap = get_node("RepairMenu/ActiveParty")
onready var rm_b = get_node("RepairMenu/Barracks")
onready var rm_w = get_node("RepairMenu/Weapons")

var char_database
var wpn_database
var item_database

var screen_size
var window_size

var active_units = []
var barracks_units = []

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

class item:
	var id # Item's ID in the item database
	var name # Item's name
	var type # Item's type - HP (damage or heal), status (buff or debuff) and dispell (removes buff and/or debuff)
	var durability # Item's initial amount when the battle begins
	var amount # Item's current amount
	var effect # Item's effect (how much it will heal/damage or amplify/reduce an attribute)
	var status # Item's status effect (poison, speed up, ...)


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
			instance_item("PAR Bomb", unit)
			instance_item("PAR Bomb", unit)
			instance_item("Potion", unit)
		if unit.name == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
			instance_item("PAR Bomb", unit)
			instance_item("Potion", unit)
			instance_item("PAR Bomb", unit)
			instance_item("PAR Bomb", unit)
	
	#settings for itemlists
	um_ap.set_max_columns(3)
	um_b.set_max_columns(3)
	im_ap.set_max_columns(3)
	im_b.set_max_columns(3)
	rm_ap.set_max_columns(3)
	rm_b.set_max_columns(3)
	im_apw.set_max_columns(4)
	im_api.set_max_columns(4)
	im_bw.set_max_columns(4)
	im_bi.set_max_columns(4)
	im_stw.set_max_columns(4)
	im_sti.set_max_columns(4)
	rm_w.set_max_columns(4)
	
	#populating character lists
	if (active_units == null):
		print ("Hey")
	#tests above
	for unit in active_units:
		um_ap.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		im_ap.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		rm_ap.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
	
	for unit in barracks_units:
		um_b.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		im_b.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)
		rm_b.add_item(char_database.get_char_name(unit.id).capitalize(), load(str(char_database.get_char_folder(unit.id),char_database.get_char_name(unit.id),"0000.tex")), 1)

	size_update()
	
	set_fixed_process(true)
	
func _fixed_process(delta):
	# Unit management
	if (um_ap.get_selected_items().size() != 0 or um_b.get_selected_items().size() != 0):
		if (um_ap.get_selected_items().size() != 0 and um_b.get_selected_items().size() != 0):
			# Ambos selecionados, exibe informações
			if (last_selected_apunit != um_ap.get_selected_items()[0]):
				um_aps.neutralize_node("Unit Status")
				um_aps.instance_animation(active_units[um_ap.get_selected_items()[0]].id)
				last_selected_apunit = um_ap.get_selected_items()[0]
				um_aps.get_node("Name").set_text(char_database.get_char_name(active_units[um_ap.get_selected_items()[0]].id).capitalize())
				um_aps.get_node("Class").set_text("Class PH")
				um_aps.get_node("Attack").set_text(str("ATK: ", char_database.get_attack(active_units[um_ap.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				um_aps.get_node("Defense").set_text(str("DEF: ", char_database.get_defense(active_units[um_ap.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
			if (last_selected_bunit != um_b.get_selected_items()[0]):
				um_bs.neutralize_node("Unit Status")
				um_bs.instance_animation(barracks_units[um_b.get_selected_items()[0]].id)
				last_selected_bunit = um_b.get_selected_items()[0]
				um_bs.get_node("Name").set_text(char_database.get_char_name(barracks_units[um_b.get_selected_items()[0]].id).capitalize())
				um_bs.get_node("Class").set_text("Class PH")
				um_bs.get_node("Attack").set_text(str("ATK: ", char_database.get_attack(barracks_units[um_b.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				um_bs.get_node("Defense").set_text(str("DEF: ", char_database.get_defense(barracks_units[um_b.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
			um_s.set_disabled(false)
		elif (um_ap.get_selected_items().size() == 0):
			# Selecionado membro da barracks, exibe informações
			if (last_selected_bunit != um_b.get_selected_items()[0]):
				um_bs.neutralize_node("Unit Status")
				um_bs.instance_animation(barracks_units[um_b.get_selected_items()[0]].id)
				last_selected_bunit = um_b.get_selected_items()[0]
				um_bs.get_node("Name").set_text(char_database.get_char_name(barracks_units[um_b.get_selected_items()[0]].id).capitalize())
				um_bs.get_node("Class").set_text("Class PH")
				um_bs.get_node("Attack").set_text(str("ATK: ", char_database.get_attack(barracks_units[um_b.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				um_bs.get_node("Defense").set_text(str("DEF: ", char_database.get_defense(barracks_units[um_b.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				
			um_aps.neutralize_node("Unit Status")
			last_selected_apunit = -1
			
			if (um_ap.get_item_count() != 4):
				um_s.set_disabled(false)
			else:
				um_s.set_disabled(true)
		else:
			# Selecionado membro da active party, exibe informações
			if (last_selected_apunit != um_ap.get_selected_items()[0]):
				um_aps.neutralize_node("Unit Status")
				um_aps.instance_animation(active_units[um_ap.get_selected_items()[0]].id)
				last_selected_apunit = um_ap.get_selected_items()[0]
				um_aps.get_node("Name").set_text(char_database.get_char_name(active_units[um_ap.get_selected_items()[0]].id).capitalize())
				um_aps.get_node("Class").set_text("Class PH")
				um_aps.get_node("Attack").set_text(str("ATK: ", char_database.get_attack(active_units[um_ap.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				um_aps.get_node("Defense").set_text(str("DEF: ", char_database.get_defense(active_units[um_ap.get_selected_items()[0]].id, 1))) #Precisa colocar o level da unidade aqui, como estamos instanciando as unidades das barracks ainda, colocamos 1 para não crashar
				
			um_bs.neutralize_node("Unit Status")
			last_selected_bunit = -1
				
			if (um_ap.get_item_count() != 1):
				um_s.set_disabled(false)
			else:
				um_s.set_disabled(true)
	else:
		#Tira todas as informações
		um_aps.neutralize_node("Unit Status")
		last_selected_apunit = -1
		um_bs.neutralize_node("Unit Status")
		last_selected_bunit = -1
		
		um_s.set_disabled(true)

	# Item management
	if (im_ap.get_selected_items().size() != 0):
		#populate and show weapons and items list for active party member
		if (last_selected_party != im_ap.get_selected_items()[0]):
			im_apw.clear()
			im_api.clear()
			for weapon in active_units[im_ap.get_selected_items()[0]].wpn_vector:
				im_apw.add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
				im_apw.set_item_tooltip(im_apw.get_item_count() - 1, weapon.name)
				if (wpn_database.get_lock(weapon.id) == 1):
						im_apw.set_item_selectable(im_apw.get_item_count() - 1, false)
			for item in active_units[im_ap.get_selected_items()[0]].item_vector:
				im_api.add_item("", load(str("res://resources/sprites/items/",item.name,".tex")), 1)
				im_api.set_item_tooltip(im_api.get_item_count() - 1, item.name)
			last_selected_party = im_ap.get_selected_items()[0]
			
	# Checagens para o modo managem barracks items
	if (item_swap_mode == 0):
		if (im_b.get_selected_items().size() != 0):
			#populate and show weapons list for barracks member
			if (last_selected_barracks != im_b.get_selected_items()[0]):
				im_bw.clear()
				im_bi.clear()
				for weapon in barracks_units[im_b.get_selected_items()[0]].wpn_vector:
					im_bw.add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
					im_bw.set_item_tooltip(im_bw.get_item_count() - 1, weapon.name)
					if (wpn_database.get_lock(weapon.id) == 1):
						im_bw.set_item_selectable(im_bw.get_item_count() - 1, false)
				for item in barracks_units[im_b.get_selected_items()[0]].item_vector:
					im_bi.add_item("", load(str("res://resources/sprites/items/",item.name,".tex")), 1)
					im_bi.set_item_tooltip(im_bi.get_item_count() - 1, item.name)
				last_selected_barracks = im_b.get_selected_items()[0]
	
		# Condições do botão de swap
		if (im_ap.get_selected_items().size() != 0 and im_b.get_selected_items().size() != 0):
			if (im_apw.get_selected_items().size() != 0 or im_bw.get_selected_items().size() != 0):
				if (im_apw.get_selected_items().size() == 0):
					if (im_apw.get_item_count() != 4):
						im_sw.set_disabled(false)
					else:
						im_sw.set_disabled(true)
				if (im_bw.get_selected_items().size() == 0):
					if (im_bw.get_item_count() != 4):
						im_sw.set_disabled(false)
					else:
						im_sw.set_disabled(true)
			else:
				im_sw.set_disabled(true)
			if (im_apw.get_selected_items().size() != 0 and im_bw.get_selected_items().size() != 0):
				im_sw.set_disabled(false)
				
			# Item conditions (tem que mudar as coisas, o antigo swap items era para mudar as armas, e o novo é swap weapons)
			if (im_api.get_selected_items().size() != 0 or im_bi.get_selected_items().size() != 0):
				if (im_api.get_selected_items().size() == 0):
					if (im_api.get_item_count() != 4):
						im_si.set_disabled(false)
					else:
						im_si.set_disabled(true)
				if (im_bi.get_selected_items().size() == 0):
					if (im_bi.get_item_count() != 4):
						im_si.set_disabled(false)
					else:
						im_si.set_disabled(true)
			else:
				im_si.set_disabled(true)
			if (im_api.get_selected_items().size() != 0 and im_bi.get_selected_items().size() != 0):
				im_si.set_disabled(false)
		else:
			im_sw.set_disabled(true)
			im_si.set_disabled(true)
	# Checagens para o modo manage storage items
	else:
		if (populated_storage == 0):
			for weapon in storage_weapons:
				im_stw.add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
				im_stw.set_item_tooltip(im_stw.get_item_count() - 1, weapon.name)
			for item in storage_items:
				im_sti.add_item("", load(str("res://resources/sprites/items/",item.name,".tex")), 1)
				im_sti.set_item_tooltip(im_sti.get_item_count() - 1, item.name)
			populated_storage = 1
		# Condições do botão de swap
		if (im_ap.get_selected_items().size() != 0):
			#weapons
			if (im_apw.get_selected_items().size() != 0 or im_stw.get_selected_items().size() != 0):
				if (im_apw.get_selected_items().size() == 0):
					if (im_apw.get_item_count() != 4):
						im_sw.set_disabled(false)
					else:
						im_sw.set_disabled(true)
				else:
					im_sw.set_disabled(false)
			else:
				im_sw.set_disabled(true)
			#items
			if (im_api.get_selected_items().size() != 0 or im_sti.get_selected_items().size() != 0):
				if (im_api.get_selected_items().size() == 0):
					if (im_api.get_item_count() != 4):
						im_si.set_disabled(false)
					else:
						im_si.set_disabled(true)
				else:
					im_si.set_disabled(false)
			else:
				im_si.set_disabled(true)
		else:
			im_si.set_disabled(true)
	# Repair menu
	if (rm_ap.get_selected_items().size() != 0 or rm_b.get_selected_items().size() != 0):
		#populate and show weapons for party member
		if (rm_ap.get_selected_items().size() != 0):
			#tem que clear a seleção do barracks
			if (last_selected_type == 1 or last_selected_repair != rm_ap.get_selected_items()[0]):
				for item in rm_b.get_selected_items():
					rm_b.unselect(item)
				rm_w.clear()
				for weapon in active_units[rm_ap.get_selected_items()[0]].wpn_vector:
					rm_w.add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
					rm_w.set_item_tooltip(rm_ap.get_item_count() - 1, weapon.name)
					if (wpn_database.get_durability(weapon.id) < 0):
						rm_w.set_item_selectable(rm_w.get_item_count() - 1, false)
				last_selected_repair = rm_ap.get_selected_items()[0]
				last_selected_type = 0
		#populate and show weapons for barracks member
		if (rm_b.get_selected_items().size() != 0):
			#tem que clear a seleção do party
			if (last_selected_type == 0 or last_selected_repair != rm_b.get_selected_items()[0]):
				for item in rm_ap.get_selected_items():
					rm_ap.unselect(item)
				rm_w.clear()
				for weapon in barracks_units[rm_b.get_selected_items()[0]].wpn_vector:
					rm_w.add_item("", load(str("res://resources/sprites/weapons/",weapon.name,".tex")), 1)
					rm_w.set_item_tooltip(rm_b.get_item_count() - 1, weapon.name)
					if (wpn_database.get_durability(weapon.id) < 0):
						rm_w.set_item_selectable(rm_w.get_item_count() - 1, false)
				last_selected_repair = rm_b.get_selected_items()[0]
				last_selected_type = 1
	
func size_update():
	OS.set_window_resizable(0)
	set_size(window_size)
	get_node("Selection").set_size(window_size)
	get_node("PartyMenu").set_size(window_size)
	
	um_ap.set_size(Vector2(window_size.x/3, window_size.y/3))
	um_b.set_size(Vector2(window_size.x/3, window_size.y/3))
	um_b.set_pos((Vector2(window_size.x - 40 - um_b.get_size().x, 40)))
	um_aps.adjust_size("Unit Status", window_size.x/3, window_size.y/3 - 40, um_aps.get_pos().x + 40, 270)
	um_bs.adjust_size("Unit Status", window_size.x/3, window_size.y/3 - 40, window_size.x - 40 - um_b.get_size().x, 270)

	im_ap.set_size(Vector2(window_size.x/3, window_size.y/3))
	im_b.set_size(Vector2(window_size.x/3, window_size.y/3))
	im_b.set_pos((Vector2(window_size.x - 40 - im_b.get_size().x, 40)))

	im_apw.set_size(Vector2(300, 73))
	im_apw.set_pos(Vector2(40, 300))
	im_api.set_size(Vector2(300, 73))
	im_api.set_pos(Vector2(40, 400))
	im_bw.set_size(Vector2(300, 73))
	im_bw.set_pos(Vector2(im_b.get_pos().x, 300))
	im_bi.set_size(Vector2(300, 73))
	im_bi.set_pos(Vector2(im_b.get_pos().x, 400))
	
	im_stw.set_size(Vector2(window_size.x/3, window_size.y/3))
	im_stw.set_pos((Vector2(window_size.x - 40 - im_stw.get_size().x, 40)))
	im_sti.set_size(Vector2(window_size.x/3, window_size.y/3))
	im_sti.set_pos((Vector2(im_b.get_pos().x, im_b.get_pos().y + 220)))

	get_node("RepairMenu/ActiveParty").set_size(Vector2(window_size.x/3, window_size.y/3))
	get_node("RepairMenu/Barracks").set_size(Vector2(window_size.x/3, window_size.y/2))
	get_node("RepairMenu/Barracks").set_pos(Vector2(40, get_node("RepairMenu/ActiveParty").get_size().y + 50))
	get_node("RepairMenu/Weapons").set_size(Vector2(300, 73))
	get_node("RepairMenu/Weapons").set_pos(Vector2(window_size.x - get_node("RepairMenu/Weapons").get_size().x - 40, 40))
# #################################### #
# ##### UNIT MANAGEMENT FUNCTIONS #### # 
# #################################### #

func _on_Swap_pressed():
	# Active and Barracks units selected
	if (um_ap.get_selected_items().size() != 0 and um_b.get_selected_items().size() != 0):
		var a_unit = active_units[um_ap.get_selected_items()[0]]
		var a_local_id = um_ap.get_selected_items()[0]
		var b_unit = barracks_units[um_b.get_selected_items()[0]]
		var b_local_id = um_b.get_selected_items()[0]
		active_units.append(b_unit)
		um_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		im_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		rm_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.append(a_unit)
		um_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		im_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		rm_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		um_ap.remove_item(a_local_id)
		im_ap.remove_item(a_local_id)
		rm_ap.remove_item(a_local_id)
		barracks_units.remove(b_local_id)
		um_b.remove_item(b_local_id)
		im_b.remove_item(b_local_id)
		rm_b.remove_item(b_local_id)
		
	# Only Active unit selected // vai ter tamanho maximo de barracks?
	if (um_ap.get_selected_items().size() != 0 and um_b.get_selected_items().size() == 0):
		var a_unit = active_units[um_ap.get_selected_items()[0]]
		var a_local_id = um_ap.get_selected_items()[0]
		barracks_units.append(a_unit)
		um_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		im_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		rm_b.add_item(char_database.get_char_name(a_unit.id).capitalize(), load(str(char_database.get_char_folder(a_unit.id),char_database.get_char_name(a_unit.id),"0000.tex")), 1)
		active_units.remove(a_local_id)
		um_ap.remove_item(a_local_id)
		im_ap.remove_item(a_local_id)
		rm_ap.remove_item(a_local_id)
	# Only Barracks unit selected
	if (um_ap.get_selected_items().size() == 0 and um_b.get_selected_items().size() != 0):
		var b_unit = barracks_units[um_b.get_selected_items()[0]]
		var b_local_id = um_b.get_selected_items()[0]
		active_units.append(b_unit)
		um_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		im_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		rm_ap.add_item(char_database.get_char_name(b_unit.id).capitalize(), load(str(char_database.get_char_folder(b_unit.id),char_database.get_char_name(b_unit.id),"0000.tex")), 1)
		barracks_units.remove(b_local_id)
		um_b.remove_item(b_local_id)
		im_b.remove_item(b_local_id)
		rm_b.remove_item(b_local_id)
	
	#Clear information boxes
	um_aps.neutralize_node("Unit Status")
	um_bs.neutralize_node("Unit Status")
	last_selected_apunit = -1
	last_selected_bunit = -1

func _on_SwapWeapons_pressed():
	if (item_swap_mode == 0):
		# Active and Barracks weapons selected
		if (im_apw.get_selected_items().size() != 0 and im_bw.get_selected_items().size() != 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[im_apw.get_selected_items()[0]]
			var a_local_wpn_id = im_apw.get_selected_items()[0]
			var b_unit = barracks_units[im_b.get_selected_items()[0]]
			var b_wpn = b_unit.wpn_vector[im_bw.get_selected_items()[0]]
			var b_local_wpn_id = im_bw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].wpn_vector.append(b_wpn)
			im_apw.add_item("", load(str("res://resources/sprites/weapons/",b_wpn.name,".tex")), 1)
			im_apw.set_item_tooltip(im_apw.get_item_count() - 1, b_wpn.name)
			barracks_units[im_b.get_selected_items()[0]].wpn_vector.append(a_wpn)
			im_bw.add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			im_bw.set_item_tooltip(im_apw.get_item_count() - 1, a_wpn.name)
			active_units[im_ap.get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			im_apw.remove_item(a_local_wpn_id)
			barracks_units[im_b.get_selected_items()[0]].wpn_vector.remove(b_local_wpn_id)
			im_bw.remove_item(b_local_wpn_id)
			
		# Only Active unit weapon selected
		if (im_apw.get_selected_items().size() != 0 and im_bw.get_selected_items().size() == 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[im_apw.get_selected_items()[0]]
			var a_local_wpn_id = im_apw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			barracks_units[im_b.get_selected_items()[0]].wpn_vector.append(a_wpn)
			im_bw.add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			im_bw.set_item_tooltip(im_apw.get_item_count(), a_wpn.name)
			active_units[im_ap.get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			im_apw.remove_item(a_local_wpn_id)
		# Only Barracks unit weapon selected
		if (im_apw.get_selected_items().size() == 0 and im_bw.get_selected_items().size() != 0):
			var b_unit = barracks_units[im_b.get_selected_items()[0]]
			var b_wpn = b_unit.wpn_vector[im_bw.get_selected_items()[0]]
			var b_local_wpn_id = im_bw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].wpn_vector.append(b_wpn)
			im_apw.add_item("", load(str("res://resources/sprites/weapons/",b_wpn.name,".tex")), 1)
			im_apw.set_item_tooltip(im_apw.get_item_count(), b_wpn.name)
			barracks_units[im_b.get_selected_items()[0]].wpn_vector.remove(b_local_wpn_id)
			im_bw.remove_item(b_local_wpn_id)
	# Storage management
	else:
		# Active and Storage weapons selected
		if (im_apw.get_selected_items().size() != 0 and im_stw.get_selected_items().size() != 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[im_apw.get_selected_items()[0]]
			var a_local_wpn_id = im_apw.get_selected_items()[0]
			var st_wpn = storage_weapons[im_stw.get_selected_items()[0]]
			var st_local_wpn_id = im_stw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].wpn_vector.append(st_wpn)
			im_apw.add_item("", load(str("res://resources/sprites/weapons/",st_wpn.name,".tex")), 1)
			im_apw.set_item_tooltip(im_apw.get_item_count() - 1, st_wpn.name)
			storage_weapons.append(a_wpn)
			im_stw.add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			im_stw.set_item_tooltip(im_apw.get_item_count() - 1, a_wpn.name)
			active_units[im_ap.get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			im_apw.remove_item(a_local_wpn_id)
			storage_weapons.remove(st_local_wpn_id)
			im_stw.remove_item(st_local_wpn_id)
			
		# Only Active unit weapon selected
		if (im_apw.get_selected_items().size() != 0 and im_stw.get_selected_items().size() == 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_wpn = a_unit.wpn_vector[im_apw.get_selected_items()[0]]
			var a_local_wpn_id = im_apw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			storage_weapons.append(a_wpn)
			im_stw.add_item("", load(str("res://resources/sprites/weapons/",a_wpn.name,".tex")), 1)
			im_stw.set_item_tooltip(im_apw.get_item_count(), a_wpn.name)
			active_units[im_ap.get_selected_items()[0]].wpn_vector.remove(a_local_wpn_id)
			im_apw.remove_item(a_local_wpn_id)
		# Only Storage weapon selected
		if (im_apw.get_selected_items().size() == 0 and im_stw.get_selected_items().size() != 0):
			var st_wpn = storage_weapons[im_stw.get_selected_items()[0]]
			var st_local_wpn_id = im_stw.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].wpn_vector.append(st_wpn)
			im_apw.add_item("", load(str("res://resources/sprites/weapons/",st_wpn.name,".tex")), 1)
			im_apw.set_item_tooltip(im_apw.get_item_count(), st_wpn.name)
			storage_weapons.remove(st_local_wpn_id)
			im_stw.remove_item(st_local_wpn_id)

func _on_SwapItems_pressed():
	if (item_swap_mode == 0):
		# Active and Barracks items selected
		if (im_api.get_selected_items().size() != 0 and im_bi.get_selected_items().size() != 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_item = a_unit.item_vector[im_api.get_selected_items()[0]]
			var a_local_item_id = im_api.get_selected_items()[0]
			var b_unit = barracks_units[im_b.get_selected_items()[0]]
			var b_item = b_unit.item_vector[im_bi.get_selected_items()[0]]
			var b_local_item_id = im_bi.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].item_vector.append(b_item)
			im_api.add_item("", load(str("res://resources/sprites/items/",b_item.name,".tex")), 1)
			im_api.set_item_tooltip(im_api.get_item_count() - 1, b_item.name)
			barracks_units[im_b.get_selected_items()[0]].item_vector.append(a_item)
			im_bi.add_item("", load(str("res://resources/sprites/items/",a_item.name,".tex")), 1)
			im_bi.set_item_tooltip(im_api.get_item_count() - 1, a_item.name)
			active_units[im_ap.get_selected_items()[0]].item_vector.remove(a_local_item_id)
			im_api.remove_item(a_local_item_id)
			barracks_units[im_b.get_selected_items()[0]].item_vector.remove(b_local_item_id)
			im_bi.remove_item(b_local_item_id)
			
		# Only Active unit item selected
		if (im_api.get_selected_items().size() != 0 and im_bi.get_selected_items().size() == 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_item = a_unit.item_vector[im_api.get_selected_items()[0]]
			var a_local_item_id = im_api.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			barracks_units[im_b.get_selected_items()[0]].item_vector.append(a_item)
			im_bi.add_item("", load(str("res://resources/sprites/items/",a_item.name,".tex")), 1)
			im_bi.set_item_tooltip(im_api.get_item_count(), a_item.name)
			active_units[im_ap.get_selected_items()[0]].item_vector.remove(a_local_item_id)
			im_api.remove_item(a_local_item_id)
		# Only Barracks unit item selected
		if (im_api.get_selected_items().size() == 0 and im_bi.get_selected_items().size() != 0):
			var b_unit = barracks_units[im_b.get_selected_items()[0]]
			var b_item = b_unit.item_vector[im_bi.get_selected_items()[0]]
			var b_local_item_id = im_bi.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].item_vector.append(b_item)
			im_api.add_item("", load(str("res://resources/sprites/items/",b_item.name,".tex")), 1)
			im_api.set_item_tooltip(im_api.get_item_count(), b_item.name)
			barracks_units[im_b.get_selected_items()[0]].item_vector.remove(b_local_item_id)
			im_bi.remove_item(b_local_item_id)
	# Storage management
	else:
		# Active and Storage items selected
		if (im_api.get_selected_items().size() != 0 and im_sti.get_selected_items().size() != 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_item = a_unit.item_vector[im_api.get_selected_items()[0]]
			var a_local_item_id = im_api.get_selected_items()[0]
			var st_item = storage_items[im_sti.get_selected_items()[0]]
			var st_local_item_id = im_sti.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].item_vector.append(st_item)
			im_api.add_item("", load(str("res://resources/sprites/items/",st_item.name,".tex")), 1)
			im_api.set_item_tooltip(im_api.get_item_count() - 1, st_item.name)
			storage_items.append(a_item)
			im_sti.add_item("", load(str("res://resources/sprites/items/",a_item.name,".tex")), 1)
			im_sti.set_item_tooltip(im_api.get_item_count() - 1, a_item.name)
			active_units[im_ap.get_selected_items()[0]].item_vector.remove(a_local_item_id)
			im_api.remove_item(a_local_item_id)
			storage_items.remove(st_local_item_id)
			im_sti.remove_item(st_local_item_id)
			
		# Only Active unit item selected
		if (im_api.get_selected_items().size() != 0 and im_sti.get_selected_items().size() == 0):
			var a_unit = active_units[im_ap.get_selected_items()[0]]
			var a_item = a_unit.item_vector[im_api.get_selected_items()[0]]
			var a_local_item_id = im_api.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			storage_items.append(a_item)
			im_sti.add_item("", load(str("res://resources/sprites/items/",a_item.name,".tex")), 1)
			im_sti.set_item_tooltip(im_api.get_item_count(), a_item.name)
			active_units[im_ap.get_selected_items()[0]].item_vector.remove(a_local_item_id)
			im_api.remove_item(a_local_item_id)
		# Only Storage item selected
		if (im_api.get_selected_items().size() == 0 and im_sti.get_selected_items().size() != 0):
			var st_item = storage_items[im_sti.get_selected_items()[0]]
			var st_local_item_id = im_sti.get_selected_items()[0]
			#condiçao de lock da arma vem aqui
			active_units[im_ap.get_selected_items()[0]].item_vector.append(st_item)
			im_api.add_item("", load(str("res://resources/sprites/items/",st_item.name,".tex")), 1)
			im_api.set_item_tooltip(im_api.get_item_count(), st_item.name)
			storage_items.remove(st_local_item_id)
			im_sti.remove_item(st_local_item_id)
		

func _on_StorageBarracks_pressed():
	if (item_swap_mode == 0):
		im_b.hide()
		im_bw.hide()
		im_bi.hide()
		im_stw.show()
		im_sti.show()
		
		for item in im_b.get_selected_items():
			im_b.unselect(item)
		im_bw.clear()
		im_bi.clear()
		last_selected_barracks = -1
		item_swap_mode = 1
	else:
		im_b.show()
		im_bw.show()
		im_bi.show()
		im_stw.hide()
		im_sti.hide()
		
		for weapon in im_stw.get_selected_items():
			im_stw.unselect(weapon)
		for item in im_sti.get_selected_items():
			im_sti.unselect(item)
		item_swap_mode = 0

# ################################ #
# ###### MENU FUNCTIONALITY ###### # 
# ################################ #


func _on_Units_pressed():
	get_node("Selection").hide()
	get_node("PartyMenu").show()


func _on_Repair_pressed():
	current_screen = "RepairMenu"
	get_node("Selection").hide()
	get_node(current_screen).show()

func _on_RepairWeapon_pressed():
	pass # replace with function body

func _on_RepairAll_pressed():
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
		for unit in um_ap.get_selected_items():
			um_ap.unselect(unit)
		for unit in um_b.get_selected_items():
			um_b.unselect(unit)
		for item in im_ap.get_selected_items():
			im_ap.unselect(item)
		for item in im_b.get_selected_items():
			im_b.unselect(item)
		im_apw.clear()
		im_api.clear()
		im_bw.clear()
		im_bi.clear()
		last_selected_party = -1
		last_selected_barracks = -1
		
		#Neutralize information boxes
	
		um_aps.neutralize_node("Unit Status")
		um_bs.neutralize_node("Unit Status")
		last_selected_apunit = -1
		last_selected_bunit = -1

		#Neutralize start on ItemManagement screen
		item_swap_mode = 1
		populated_storage = 0
		im_stw.clear()
		im_sti.clear()
		_on_StorageBarracks_pressed()
	if (current_screen == "RepairMenu"):
		get_node("Selection").show()
		for unit in rm_ap.get_selected_items():
			rm_ap.unselect(unit)
		for unit in rm_b.get_selected_items():
			rm_b.unselect(unit)
		rm_w.clear()
		last_selected_repair = -1
		last_selected_type = -1

	elif (current_screen == "RepairMenu"):
		#adicionar o resto depois
		get_node("Selection").show()



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
	
# owner is the reference in the correct vector (allies or enemies)
func instance_item(name, owner):
	
	var id = item_database.get_item_id(name)
	
	# Data instancing segment
	var item_instance = item.new()
	item_instance.id = id
	item_instance.name = name
	item_instance.type = item_database.get_item_type(id)
	item_instance.durability = 3
	item_instance.amount = item_instance.durability
	item_instance.effect = item_database.get_item_effect(id)
	item_instance.status = item_database.get_item_status(id)
	owner.item_vector.append(item_instance)

#END TEMPORARY SECTION

func _on_Back_pressed():
	get_node("PartyMenu").hide()
	get_node("Selection").show()
