
extends Node

func adjust_properties(button_id, type, pos_x, pos_y, object_id, database):
	set_pos(Vector2(pos_x, pos_y - 110))
	if (type == "attack"):
		set_texture(load("res://resources/sprites/gui/management/button0003.png"))
		get_node("Name").set_pos(Vector2(30, 15))
		get_node("Name").set_text(str("Type: ", database.get_wpn_type(object_id)))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		get_node("NumericInfo").set_text(str("Attack: ", database.get_attack(object_id)))
		get_node("NumericInfo").set_pos(Vector2(30, 40))
	
	if (type == "skill"):
		set_texture(load("res://resources/sprites/gui/management/button0000.png"))
		get_node("Name").set_pos(Vector2(30, 15))
		get_node("Name").set_text(database.get_skill_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		var spacing = 0
		for type in database.get_skill_type(object_id):
			if (type == "HP"):
				var mult = database.get_skill_multiplayer(object_id)
				var potency = mult[0]
				if (potency < 0):
					potency = -potency
				get_node("NumericInfo").set_text(str("Base Power: ", potency))
				get_node("NumericInfo").set_pos(Vector2(30, 40 + (25 * spacing)))
				spacing += 1
			if (type == "Effect"):
				get_node("Extra1").set_text(str("Effect: ", database.get_skill_status(object_id)))
				get_node("Extra1").set_pos(Vector2(30, 40 + (25 * spacing)))
				spacing += 1
		
	if (type == "item"):
		set_texture(load("res://resources/sprites/gui/management/button0006.png"))
		get_node("Name").set_pos(Vector2(30, 15))
		get_node("Name").set_text(database.get_item_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		var spacing = 0
		for type in database.get_item_type(object_id):
			if (type == "HP"):
				var potency = database.get_item_hp(object_id)
				if (potency < 0):
					potency = -potency
				get_node("NumericInfo").set_text(str("Potency: ", potency))
				get_node("NumericInfo").set_pos(Vector2(30, 40 + (25 * spacing)))
				spacing += 1
			if (type == "Effect"):
				get_node("Extra1").set_text(str("Effect: ", database.get_item_status(object_id)))
				get_node("Extra1").set_pos(Vector2(30, 40 + (25 * spacing)))
				spacing += 1
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


