
extends Node2D

var recruits = []
var desired = 0

onready var char_db = get_node("/root/character_database")

class unit:
	var id
	var name
	var level
	var wpn_vector = []
	var item_vector = []


func _ready():
	organize_positions()

	recruits = get_parent().recruit_vector
	populate()
	button_update()

#   Adds Money
	var stats = 0
	for unit in recruits:
		stats += char_db.get_attack(unit.id, unit.level)
		stats += char_db.get_defense(unit.id, unit.level)
		stats += char_db.get_speed(unit.id, unit.level)
	get_parent().get_parent().quesha += 2*stats


func organize_positions():
	var window_size = OS.get_window_size()
	var scale = window_size/Vector2(600, 600) # Makes bg screen size
	var pos = (Vector2(600, 600)*scale)/2 # Centralizes bg on screen

	get_node("BackGround").set_scale(scale)
	get_node("BackGround").set_pos(pos)

	get_node("RecruitsBox").set_size(Vector2(window_size.x - 50, window_size.y))
	get_node("RecruitsBox").set_pos(Vector2(0, -30))

	get_node("ButtonBox").set_size(Vector2(window_size.x - 50, window_size.y))
	get_node("ButtonBox").set_pos(Vector2(20, 100))


func populate():
	var i = 0
	for unit_box in get_node("RecruitsBox").get_children():
		instance_unit(recruits[i].id, 4, unit_box)
		add_info(recruits[i], unit_box)

		i += 1


func instance_unit(id, scale, parent):
	# Initialize visuals #
	var anim_sprite = AnimatedSprite.new()
	var anim_player = AnimationPlayer.new()

	# Get folder and animation names for the character #
	var char_folder = char_db.get_char_folder(id)
	var anim_names = char_db.get_animation_array(id)

	# Add idle animation #
	anim_player.add_animation("idle", load(str(char_folder, "idle", ".xml")))
	anim_player.play("idle")
	
	# Adjust sprite details
	anim_sprite.set_sprite_frames(load(str(char_folder, char_db.get_char_name(id), ".tres")))

	anim_player.set_name("anim_player")
	anim_sprite.add_child(anim_player)
	anim_sprite.set_name("Icon")
	anim_sprite.set_scale(Vector2(-scale, scale))
	parent.add_child(anim_sprite)


func add_info(unit, parent):
	var size

	parent.get_node("Name").set_text(str(char_db.get_char_name(unit.id).capitalize()))
	size = parent.get_node("Name").get_text().length()
	parent.get_node("Name").set_pos(Vector2(-size/2, -115))
	parent.get_node("Level").set_text(str("Level: ", unit.level))
	size = parent.get_node("Level").get_text().length()
	parent.get_node("Level").set_pos(Vector2(-size/2, -95))

	var wpn_vector = char_db.get_weapon_vector(unit.id)
	var weapons = []

	for wpn in wpn_vector:
		if (wpn == "Sword" or wpn == "Axe" or wpn == "Spear"):
			if !weapons.has(wpn):
				weapons.append(wpn)

	if weapons.empty():
		parent.get_node("Weapons").set_text("Natural Weapons")
	else:
		parent.get_node("Weapons").set_text(str(weapons))
	size = parent.get_node("Weapons").get_text().length()
	parent.get_node("Weapons").set_pos(Vector2(-size, 100))


func calculate_chance(unit):
	return 51 - unit.level


func button_update():
	var i = 0
	for button in get_node("ButtonBox").get_children():
		button.set_text(str("Chance: ", calculate_chance(recruits[i]),"%"))
		i += 1


func clear_recruit():
	get_node("ButtonBox").queue_free()

	var i = 0
	for unit in get_node("RecruitsBox").get_children():
		if i != (desired - 1):
			unit.queue_free()
		i += 1

	get_node("RecruitsBox").set_size(Vector2(100, 100))
	get_node("RecruitsBox").set_pos(OS.get_window_size()/2 - Vector2(100, 100))
	get_node("Outcome").set_pos(OS.get_window_size()/2 + Vector2(0, 120))

func goto_management():
	var main = get_parent().get_parent()
	if (main.gd == 0):
		main.stage += 1
	main.victory = 1
	main.set_level("management")


func _on_Button1_pressed():
	randomize()
	var rand = randi() % 100
	var chance = calculate_chance(recruits[0])
	desired = 1

	if rand < chance:
		get_parent().get_parent().barracks.append(recruits[0])
		print("RECRUTOU")
		get_node("AnimationPlayer").play("sucess")
	else:
		get_node("AnimationPlayer").play("fail")


func _on_Button2_pressed():
	randomize()
	var rand = randi() % 100
	var chance = calculate_chance(recruits[1])
	desired = 2

	if rand < chance:
		get_parent().get_parent().barracks.append(recruits[1])
		print("RECRUTOU")
		get_node("AnimationPlayer").play("sucess")
	else:
		get_node("AnimationPlayer").play("fail")


func _on_Button3_pressed():
	randomize()
	var rand = randi() % 100
	var chance = calculate_chance(recruits[2])
	desired = 3

	if rand < chance:
		get_parent().get_parent().barracks.append(recruits[2])
		print("RECRUTOU")
		get_node("AnimationPlayer").play("sucess")
	else:
		get_node("AnimationPlayer").play("fail")


func _on_Button4_pressed():
	randomize()
	var rand = randi() % 100
	var chance = calculate_chance(recruits[3])
	desired = 4

	if rand < chance:
		get_parent().get_parent().barracks.append(recruits[3])
		print("RECRUTOU")
		get_node("AnimationPlayer").play("sucess")
	else:
		get_node("AnimationPlayer").play("fail")