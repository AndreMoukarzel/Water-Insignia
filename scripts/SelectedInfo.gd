
extends TextureFrame

var master
const ATK = 0
const DEF = 1
const SPD = 2
const Poison = 3
const Para = 4

func _ready():
	var database = get_node("/root/character_database")

	var hp_max = database.get_hp(master.id, master.level)
	var mp_max = database.get_mp(master.id, master.level)

	get_node("LifeBar").set_max(hp_max)
	get_node("ManaBar").set_max(mp_max)

	update()


func update():

	get_node("LifeBar").set_value(master.hp_current)
	get_node("ManaBar").set_value(master.mp_current)

	update_status()

func update_status():
	var color = Color(1, 1, 1)
	var atk_bonus = master.get_attack_bonus()
	var def_bonus = master.get_defense_bonus()
	var spd_bonus = master.get_speed_bonus()
	var stat_vector = master.get_status_vector()
	
	get_node("LifeBar/HP").set_text(str(master.get_hp_current(), "/", master.get_hp_max()))
	get_node("ManaBar/MP").set_text(str(master.get_mp_current(), "/", master.get_mp_max()))
	
	get_node("LifeBar/HP").set_align(1)
	get_node("ManaBar/MP").set_align(1)
	
	if atk_bonus > 0:
		pass
	elif atk_bonus < 0:
		pass
	else:
		pass
	
	if def_bonus > 0:
		pass
	elif def_bonus < 0:
		pass
	else:
		pass
	
	if spd_bonus > 0:
		pass
	elif spd_bonus < 0:
		pass
	else:
		pass
	
	for stat in stat_vector:
		if stat.name == "Poison":
			pass
		elif stat.name == "Paralize":
			pass