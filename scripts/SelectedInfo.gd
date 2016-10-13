
extends TextureFrame

var master

func _ready():
	var database = get_node("/root/character_database")

	var hp_max = database.get_hp(master.id, master.level)
	var mp_max = database.get_mp(master.id, master.level)

	get_node("LifeBar").set_size(Vector2(hp_max * 5, 16))
	get_node("LifeBar").set_max(hp_max)

	get_node("ManaBar").set_size(Vector2(mp_max * 5, 16))
	get_node("ManaBar").set_max(mp_max)

	update()


func update():

	get_node("LifeBar").set_value(master.hp_current)
	get_node("ManaBar").set_value(master.mp_current)

	update_status()


func update_status():
	var color = Color(1, 1, 1)

	if master.bonus_attack > 0:
		color = Color(0.2, 1, 0.2)
	elif master.bonus_attack < 0:
		color = Color(1, 0.2, 0.2)
	get_node("Atk/Num").set_text(str(master.get_attack()))
	get_node("Atk/Num").add_color_override("font_color", color)

	if master.bonus_defense > 0:
		color = Color(0.2, 1, 0.2)
	elif master.bonus_defense < 0:
		color = Color(1, 0.2, 0.2)
	get_node("Def/Num").set_text(str(master.get_defense()))
	get_node("Def/Num").add_color_override("font_color", color)

	if master.bonus_speed > 0:
		color = Color(0.2, 1, 0.2)
	elif master.bonus_speed < 0:
		color = Color(1, 0.2, 0.2)
	get_node("Spd/Num").set_text(str(master.get_speed()))
	get_node("Spd/Num").add_color_override("font_color", color)