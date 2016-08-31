
extends Node2D

const scale = 5

class unit:
	var id
	var name
	var hp_current
	var bonus_attack
	var bonus_defense
	var bonus_speed
#	var status_condition

class action_class:
	var from
	var to
	var action
	var speed

var allies_vector = []
var enemies_vector = []

var allies_pos = []
var enemies_pos = []

var actor = 0
var action = null
var action_memory = []
var action_count = 0

var targeting = false

var char_database
var window_size

var mouse_cooldown = 0
var time = 0
var blink_counter = 0

var end = 0

var STATE = ""
var STATE_NEXT = "SELECT TARGET"


func _ready():

	# Acess character database (is a global script) #
	char_database = get_node("/root/character_database")
	
	# Get window size #
	window_size = OS.get_window_size()

	# TESTING INSTANCING #
	instance_unit(0, "Allies")
	instance_unit(1, "Allies")
	instance_unit(1, "Allies")
	instance_unit(0, "Enemies")
	instance_unit(1, "Enemies")
	instance_unit(0, "Enemies")
	######################

	reposition_units()
	resize_menu()
	name_units()

	set_fixed_process(true)

# ############################### #
# ##### INSTANCING FUNCTIONS #### # 
# ############################### #

func instance_unit(id, path):
	
	# Initialize visuals #
	var anim_sprite = AnimatedSprite.new()
	var anim_player = AnimationPlayer.new()

	# Get folder and animation names for the character #
	var char_folder = char_database.get_char_folder(id)
	var anim_names = char_database.get_animation_array(id)

	# Add animations to the player, play the idle animation #
	for i in range(anim_names.size()):
		anim_player.add_animation(anim_names[i], load(str(char_folder, anim_names[i], ".xml")))
	anim_player.play("idle")

	# Adjust sprite details
	anim_sprite.set_sprite_frames(load(str(char_folder, char_database.get_char_name(id), ".tres")))
	anim_sprite.set_scale(Vector2(scale, scale))

	anim_player.set_name("anim_player")
	anim_sprite.add_child(anim_player)
	get_node(path).add_child(anim_sprite)
	
	# Data instancing segment
	var unit_instance = unit.new()
	unit_instance.id = id
	unit_instance.name = char_database.get_char_name(id)
	unit_instance.hp_current = char_database.get_hp_max(id)

	if path == "Allies":
		allies_vector.append(unit_instance)
	elif path == "Enemies":
		enemies_vector.append(unit_instance)


func reposition_units():
	# This function might be altered later, so #
	# enemy units will appear in different     #
	# patterns, depending on their numbers.    #
	
	var num = 0
	var temp = 1

	num = get_node("Allies").get_child_count()

	for child in get_node("Allies").get_children():
		child.set_pos(Vector2(300 - 50*temp, temp*500/(num + 1)))
		allies_pos.append(child.get_pos())
		temp += 1 

	num = get_node("Enemies").get_child_count()
	temp = 1

	for child in get_node("Enemies").get_children():
		child.set_pos(Vector2(window_size.x - 300 + 50*temp, temp*500/(num + 1)))
		child.set_scale(Vector2(-scale, scale))
		enemies_pos.append(child.get_pos())
		temp += 1 


func resize_menu():
	get_node("ActionMenu").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Selection").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Attack").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Skill").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Item").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Return").set_pos(Vector2(window_size.x - 50, -50))


func name_units():
	var i = 0;

	for child in get_node("Allies").get_children():
		child.set_name(str(i))
		i += 1
	i = 0
	for child in get_node("Enemies").get_children():
		child.set_name(str(i))
		i += 1

# ############################### #
# ####### COMBAT FUNCTIONS ###### # 
# ############################### #

func turn_based_system():
	# A ideia é chamar a função no ready, e que ela seja auto-suficiente  #
	# até a condição de fim do combate (o vetor dos inimigos estar        #
	# completamente vazia ou a party tomar wipe). Ele precisa estar integrado com a seleção dos #
	# menus, logo, é pertinente fazer uma função que aguarda os comandos  #
	# do jogador, dependendo do numero de party members.                  #
	var closest = [-1,-1]
	
	if(action_memory.size() < get_node("Allies").get_child_count()):
		if(process_action()):
			targeting = true
	if(targeting):
		closest = target_select("All")
		if closest[0] != -1:
			get_node("Target").show()
			get_node("Target").set_pos(get_node(str(closest[1],"/",closest[0])).get_pos())
	
			if Input.is_action_pressed("left_click") and mouse_cooldown == 0:
				mouse_cooldown = 30
				action_memory[action_count].to = closest
				get_node(str("Allies/",actor)).set_opacity(1) # in case of blinking
				actor = (actor + 1) % get_node("Allies").get_child_count()
				action_count = (action_count + 1) % get_node("Allies").get_child_count()
				targeting = false

				return_to_Selection()

	if(action_memory.size() == get_node("Allies").get_child_count()) and (!targeting):
		action_memory.sort_custom(self, "compare_speed")
		toggle_buttons(true)
		STATE_NEXT = "EXECUTE ACTION"

func process_action():
	if action != null:
		var action_instance = action_class.new()
		action_instance.from = [actor, "Allies"]
		action_instance.action = action
		action_instance.speed = char_database.get_speed(allies_vector[actor].id)
		action_memory.append(action_instance)
		action = null
		return 1
	return 0


func process_attack(attacker_side, attacker_vpos, defender_side, defender_vpos):
	# A formula contara com ataque bonus, defesa bonus, #
	# entre outros fatores como status condition, no    #
	# futuro. Por ora, deve ser simples.                #
	
	# Agora que o turno processa diversas ações ao mesmo tempo,
	# temos que checar se o alvo ainda está vivo para processarmos
	# o ataque. Além disso, devemos associar a animação a isso.
	# A forma que faremos é: ao criar a database de armas, associaremos
	# a cada arma uma animação, e puxar o tempo dessa animação usando o Godot.
	var attacker
	if attacker_side == "Enemies":
		attacker = enemies_vector
	elif attacker_side == "Allies":
		attacker = allies_vector
	var defender
	if defender_side == "Enemies":
		defender = enemies_vector
	elif defender_side == "Allies":
		defender = allies_vector
	var damage = char_database.get_attack(attacker[attacker_vpos].id) -  char_database.get_defense(defender[defender_vpos].id)
	if (damage < 0):
		damage = 0
	defender[defender_vpos].hp_current -= damage
	if defender[defender_vpos].hp_current > 0:
		print(str("Um ataque direto! O hp restante é: ", defender[defender_vpos].hp_current))
	
	if (defender[defender_vpos].hp_current <= 0):
		print(str("O inimigo ", defender[defender_vpos].name, " foi derrotado!"))
		#efeito visual aqui#
		defender[defender_vpos] = null
		get_node(str(defender_side, "/", defender_vpos)).queue_free()
		if defender_side == "Enemies":
			enemies_pos[defender_vpos] = Vector2(-100, -100)
		elif defender_side == "Allies":
			allies_pos[defender_vpos] = Vector2(-100, -100)

		if get_node(defender_side).get_child_count() == 1:
			if defender_side == "Allies":
				print("KILL YOURSELF")
				end = -1
			elif defender_side == "Enemies":
				print("GG IZI")
				end = 1
			get_node("/root/global").goto_scene("res://scenes/MainMenu.xscn")

		return 1 # defender death
	return 0


func compare_speed(act1, act2):
	if act1.speed <= act2.speed:
		return false
	else:
		return true

func blink(actor, counter):
	#Makes the current acting unit blink
	if counter < 20:
		get_node(str("Allies/",actor)).set_opacity(1)
	else:
		get_node(str("Allies/",actor)).set_opacity(0.5)


# ############################### #
# ###### MENU FUNTIONALITY ###### # 
# ############################### #
func toggle_buttons(boolean):
	get_node("ActionMenu/Selection/Attack").set_ignore_mouse(boolean)
	get_node("ActionMenu/Selection/Skill").set_ignore_mouse(boolean)
	get_node("ActionMenu/Selection/Item").set_ignore_mouse(boolean)
	get_node("ActionMenu/Selection/Defend").set_ignore_mouse(boolean)

	get_node("ActionMenu/Selection/Attack").set_disabled(boolean)
	get_node("ActionMenu/Selection/Skill").set_disabled(boolean)
	get_node("ActionMenu/Selection/Item").set_disabled(boolean)
	get_node("ActionMenu/Selection/Defend").set_disabled(boolean)


func return_to_Selection():
	var action_menu = get_node("ActionMenu")

	action_menu.get_node("Selection").show()
	action_menu.get_node("Attack").hide()
	action_menu.get_node("Skill").hide()
	action_menu.get_node("Item").hide()
	action_menu.get_node("Return").hide()


func _on_Return_pressed():
	action = null
	if(actor == (action_memory.size() - 1)):
		action_memory.pop_back()
		targeting = false

	return_to_Selection()


func _on_Attack_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Attack").show()


func _on_AttackSlot1_pressed():
	action = "attack"

func _on_Skill_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Skill").show()


func _on_Item_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Item").show()


func target_select(target):
	var mouse = get_global_mouse_pos()
	var mouse_temp = mouse
	var closest = -1
	var team = null
	var distance = 500


	if target == "Allies":
		for i in allies_pos:
			if i != null:
				mouse_temp = (mouse - i).length()
				if mouse_temp < 100:
					if mouse_temp < distance:
						distance = mouse_temp
						closest = allies_pos.find(i)
						team = "Allies"

	elif target == "Enemies":
		for i in enemies_pos:
			if i != null:
				mouse_temp = (mouse - i).length()
				if mouse_temp < 100:
					if mouse_temp < distance:
						distance = mouse_temp
						closest = enemies_pos.find(i)
						team = "Enemies"

	elif target == "All":
		for i in allies_pos:
			if i != null:
				mouse_temp = (mouse - i).length()
				if mouse_temp < 100:
					if mouse_temp < distance:
						distance = mouse_temp
						closest = allies_pos.find(i)
						team = "Allies"
		for i in enemies_pos:
			if i != null:
				mouse_temp = (mouse - i).length()
				if mouse_temp < 100:
					if mouse_temp < distance:
						distance = mouse_temp
						closest = enemies_pos.find(i)
						team = "Enemies"

	return [closest, team]


# ############################### #
# ######## FIXED PROCESS ######## # 
# ############################### #

func _fixed_process(delta):
	get_node("Target").hide()

	if STATE == "SELECT TARGET":
		if blink_counter == 0:
			blink_counter = 40
		blink_counter -= 1

		while get_node(str("Allies/", actor)) == null:
			actor += 1;
		blink(actor, blink_counter)

		turn_based_system()
	elif STATE == "EXECUTE ACTION":
		if action_memory.empty():
			action_count = 0
			toggle_buttons(false)
			STATE_NEXT = "SELECT TARGET"
		else:
			var act = action_memory[0]
			var player = get_node(str(act.from[1],"/",act.from[0],"/anim_player"))

			if (get_node(str(act.to[1],"/",act.to[0])) != null) and (get_node(str(act.from[1],"/",act.from[0])) != null):
				time = (player.get_animation(act.action).get_length()) * 60
				player.play(act.action)
				STATE_NEXT = "ANIMATION"
			else:
				action_memory.pop_front()
	elif STATE == "ANIMATION":
		var act = action_memory[0]
		var player = get_node(str(act.from[1],"/",act.from[0],"/anim_player"))

		time -= 1
		if time <= 1:
			player.play("idle")
			process_attack(act.from[1], act.from[0], act.to[1], act.to[0])
			action_memory.pop_front()
			STATE_NEXT = "EXECUTE ACTION"

	if mouse_cooldown > 0:
		mouse_cooldown -= 1

	STATE = STATE_NEXT