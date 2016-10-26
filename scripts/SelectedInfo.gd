
extends TextureFrame

var master

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
	
	get_node("LifeBar/HP").set_text(str(master.get_hp_current(), "/", master.get_hp_max()))
	get_node("ManaBar/MP").set_text(str(master.get_mp_current(), "/", master.get_mp_max()))
	
	get_node("LifeBar/HP").set_align(1)
	get_node("ManaBar/MP").set_align(1)
	