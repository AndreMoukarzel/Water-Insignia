
extends Node

func adjust_properties(button_id, type, pos_x, pos_y, object_id, database):
	set_pos(Vector2(pos_x, pos_y - 210))
	if (type == "attack"):
		set_texture(load("res://resources/sprites/gui/combat/AttackSlotNormal.png"))
		#mudar a textura para ficar com o fundo vermelho, fazer para o resto (skills e items)
		get_node("Name").set_pos(Vector2(30, 35))
		get_node("Name").set_text(database.get_wpn_name(object_id))
		#get_node("Description").set_text(database.get_wpn_description(object_id))
		get_node("NumericInfo").set_text(str("Attack: ", database.get_attack(object_id)))
		get_node("NumericInfo").set_pos(Vector2(30, 60))
	
func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	pass


