
extends Node

func adjust_properties(button_id, type, pos_x, pos_y, object_id, database):
	set_pos(Vector2(pos_x, pos_y - 210))
	if (type == "attack"):
		set_texture(load("res://resources/sprites/gui/combat/AttackSlotNormal.png"))
		get_node("Name").set_pos(Vector2(30, 35))
		get_node("Name").set_text(database.get_wpn_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		get_node("NumericInfo").set_text(str("Attack: ", database.get_attack(object_id)))
		get_node("NumericInfo").set_pos(Vector2(30, 60))
	
	if (type == "skill"):
		set_texture(load("res://resources/sprites/gui/combat/SkillSlotNormal.png"))
		get_node("Name").set_pos(Vector2(30, 35))
		get_node("Name").set_text(database.get_skill_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		var spacing = 0
		for type in database.get_skill_type(object_id):
			if (type == "HP"):
				var potency = database.get_skill_hp(object_id)
				if (potency < 0):
					potency = -potency
				get_node("NumericInfo").set_text(str("Potency: ", potency))
				get_node("NumericInfo").set_pos(Vector2(30, 60 + (25 * spacing)))
				spacing += 1
			if (type == "Effect"):
				get_node("Extra1").set_text(str("Effect: ", database.get_skill_status(object_id)))
				get_node("Extra1").set_pos(Vector2(30, 60 + (25 * spacing)))
				spacing += 1
		
	if (type == "item"):
		set_texture(load("res://resources/sprites/gui/combat/ItemSlotNormal.png"))
		get_node("Name").set_pos(Vector2(30, 35))
		get_node("Name").set_text(database.get_item_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		var spacing = 0
		for type in database.get_item_type(object_id):
			if (type == "HP"):
				var potency = database.get_item_hp(object_id)
				if (potency < 0):
					potency = -potency
				get_node("NumericInfo").set_text(str("Potency: ", potency))
				get_node("NumericInfo").set_pos(Vector2(30, 60 + (25 * spacing)))
				spacing += 1
			if (type == "Effect"):
				get_node("Extra1").set_text(str("Effect: ", database.get_item_status(object_id)))
				get_node("Extra1").set_pos(Vector2(30, 60 + (25 * spacing)))
				spacing += 1
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


