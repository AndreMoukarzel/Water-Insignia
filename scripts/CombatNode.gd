
extends Node2D

const scale = 5

class unit:
	var id
	var name
	var hp_current
	var bonus_attack = 0
	var bonus_defense = 0
	var bonus_speed
	var wpn_vector = []
	var item_vector = []
#	var status_condition

class weapon:
	var id
	var name
	var durability

class item:
	var id
	var name
	var type
	var intensity
	var amount
	var durability

class action_class:
	var from
	var to
	var action
	var action_id
	var speed

var allies_vector = []
var enemies_vector = []

var allies_pos = []
var enemies_pos = []

var actor = 0
var action = null
var action_id = 10 # Qualquer numero fora do intervalo 0 - 3 é invalido #
var action_memory = []
var action_count = 0

var targeting = false

var char_database
var wpn_database
var item_database
var window_size

var mouse_cooldown = 0
var time = 0
var blink_counter = 0

var end = 0

var BUTTON = null
var BUTTON_LAST = null

var STATE = ""
var STATE_NEXT = "SELECT TARGET"


func _ready():

	# Acess databases (are global scripts) #
	char_database = get_node("/root/character_database")
	wpn_database = get_node("/root/weapon_database")
	item_database = get_node("/root/item_database")
	
	# Get window size #
	window_size = OS.get_window_size()

	# TESTING INSTANCING UNITS#
	instance_unit(0, "Allies")
	instance_unit(1, "Allies")
	instance_unit(1, "Allies")
	instance_unit(0, "Enemies")
	instance_unit(1, "Enemies")
	instance_unit(0, "Enemies")
	
	#TESTING INSTANCING WEAPONS #
	
	for unit in allies_vector:
		if unit.name == "bat":
			instance_weapon("Bat Fangs", unit)
			instance_weapon("Bat Wings", unit)
		if unit.name == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
			instance_item("Bomb", unit)
			instance_item("Potion", unit)
	
	for unit in enemies_vector:
		if unit.name == "bat":
			instance_weapon("Bat Fangs", unit)
			instance_weapon("Bat Wings", unit)
		if unit.name == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
	######################

	reposition_units()
	resize_menu()
	name_units()

	set_fixed_process(true)

# ############################### #
# ##### INSTANCING FUNCTIONS #### # 
# ############################### #

# Vamos precisar de um script auxiliar, que tenhamos o estado inicial
# de cada mob, para quando formos gera-los, termos noção de qual armas,
# skills e etc. eles devem ter no momento inicial.

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

# owner is the reference in the correct vector (allies or enemies)
func instance_weapon(name, owner):
	
	var id = wpn_database.get_wpn_id(name)
	
	# Data instancing segment
	var wpn_instance = weapon.new()
	wpn_instance.id = id
	wpn_instance.name = name
	wpn_instance.durability = wpn_database.get_durability(id)
	owner.wpn_vector.append(wpn_instance)


func instance_item(name, owner):
	
	var id = item_database.get_item_id(name)
	
	# Data instancing segment
	var item_instance = item.new()
	item_instance.id = id
	item_instance.name = name
	item_instance.type = item_database.get_item_type(id)
	item_instance.durability = 10
	owner.item_vector.append(item_instance)


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
	get_node("ActionMenu/Return").set_pos(Vector2(window_size.x - 104, -45))


func name_units():
	var i = 0;

	for child in get_node("Allies").get_children():
		child.set_name(str(i))
		i += 1
	i = 0
	for child in get_node("Enemies").get_children():
		child.set_name(str(i))
		i += 1


func damage_box(damage, color, pos):
	var box_scn = load("res://scenes/DamageBox.xml")
	var box = box_scn.instance()

	box.damage = damage
	box.color = color
	box.set_pos(pos)
	add_child(box)


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

	if(targeting):
		toggle_button(true, BUTTON)
		closest = target_select("All")
		if closest[0] != -1:
			get_node("Target").show()
			get_node("Target").set_pos(get_node(str(closest[1],"/",closest[0])).get_pos())
	
			if Input.is_action_pressed("left_click") and mouse_cooldown == 0:
				toggle_button(false, BUTTON)
				BUTTON = null
				mouse_cooldown = 30
				action_memory[action_count].to = closest
				get_node(str("Allies/",actor)).set_opacity(1) # in case of blinking
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()
				targeting = false

				return_to_Selection()

	if(action_memory.size() < get_node("Allies").get_child_count()):
		if(process_action()):
			if action_memory[action_count].action != "defend":
				targeting = true
			else: # Execução da defesa
				var act = action_memory[action_count]
				var effect = get_node("Effects")

				if act.from[1] == "Allies":
					allies_vector[act.from[0]].bonus_defense = char_database.get_defense(allies_vector[act.from[0]].id) * 2
				elif act.from[1] == "Enemies":
					enemies_vector[act.from[0]].bonus_defense = char_database.get_defense(enemies_vector[act.from[0]].id) * 2
				effect.set_pos(get_node(str(act.from[1],"/",act.from[0])).get_pos())
				effect.get_node("AnimatedSprite/AnimationPlayer").play("defend")

				get_node(str("Allies/",actor)).set_opacity(1) # in case of blinking
				action_memory[action_count].to = [actor, "Allies"]
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()
				return_to_Selection()

	if(action_memory.size() == get_node("Allies").get_child_count()) and (!targeting):
		toggle_menu(true)
		enemy_attack_beta()
		action_memory.sort_custom(self, "compare_speed")
		STATE_NEXT = "EXECUTE ACTION"


func process_action():
	if action != null:
		var action_instance = action_class.new()
		action_instance.from = [actor, "Allies"]
		action_instance.action = action
		action_instance.action_id = action_id
		action_instance.speed = char_database.get_speed(allies_vector[actor].id)
		action_memory.append(action_instance)
		action = null
		action_id = 10
		return 1
	return 0


func filter_action(act):
	print (act.action)
	# Lidamos com a defesa em cima, pois ela precisa acontecer antes de tudo #
	if (act.action == "attack"):
		process_attack(act.action_id, act.from[1], act.from[0], act.to[1], act.to[0])
	elif (act.action == "skill"):
		pass 
	elif (act.action == "item"):
		process_item(act.action_id, act.from[1], act.from[0], act.to[1], act.to[0])


func process_attack(action_id, attacker_side, attacker_vpos, defender_side, defender_vpos):
	# A formula contara com ataque bonus, defesa bonus, #
	# entre outros fatores como status condition, no    #
	# futuro. Por ora, deve ser simples.                #
	
	# Definindo as referencias para cada lado do combate #
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

	# Calcular o dano para o ataque #
	var char_atk = char_database.get_attack(attacker[attacker_vpos].id)
	var char_bonus_atk = attacker[attacker_vpos].bonus_attack
	var wpn_atk = wpn_database.get_attack(attacker[attacker_vpos].wpn_vector[action_id].id)
	var char_def = char_database.get_defense(defender[defender_vpos].id)
	var char_bonus_def = defender[defender_vpos].bonus_defense
	var damage = (char_atk + char_bonus_atk + wpn_atk) -  (char_def + char_bonus_def)
	# Decrementa a durabilidade da arma após um ataque independentemente de ter acertado ou não
	attacker[attacker_vpos].wpn_vector[action_id].durability -= 1
	# Remove a defesa bonus garantida pelo comando DEFEND, terá que ser alterado futuramente #
	defender[defender_vpos].bonus_defense = 0
	# Não deixa o dano ser menor que 0. Magias que curam ficarão sob o comando skill. #
	if (damage < 0):
		damage = 0
	# Processa o dano, mostra na tela #
	defender[defender_vpos].hp_current -= damage
	damage_box(damage, Color(1, 0, 0), get_node(str(defender_side,"/",defender_vpos)).get_pos())
	# Se o defender não morrer, gera esta mensagem #
	if defender[defender_vpos].hp_current > 0:
		print(str("Um ataque direto! O hp restante é: ", defender[defender_vpos].hp_current))

	# Processa a morte do defender #
	if (defender[defender_vpos].hp_current <= 0):
		print(str("O inimigo ", defender[defender_vpos].name, " foi derrotado!"))
		#efeito visual aqui#
		defender[defender_vpos] = null
		get_node(str(defender_side, "/", defender_vpos)).queue_free()
		# Retira o inimigo da tela, para não poder mais ser clicado #
		if defender_side == "Enemies":
			enemies_pos[defender_vpos] = Vector2(-100, -100)
		elif defender_side == "Allies":
			allies_pos[defender_vpos] = Vector2(-100, -100)

		# Condições de vitória / derrota #
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


func process_item(action_id, user_side, user_vpos, target_side, target_vpos):
	var user = allies_vector
	var type = user[user_vpos].item_vector[action_id].type


	if type == "HP":
		pass
	elif type == "Status":
		pass
	elif type == "Dispell":
		pass


func enemy_attack_beta():
	var enemies = 0
	while(enemies < enemies_pos.size()):
		var action_instance = action_class.new()

		while ((enemies_vector[enemies] == null) and (enemies < enemies_pos.size() - 1)):
			enemies += 1

		if enemies_vector[enemies] != null:
			action_instance.from = [enemies, "Enemies"]
			# so com chance de acertar allies, por ora
			randomize()
			var random_target = int(rand_range(0, get_node("Allies").get_child_count())) #claramente menos chance de acertar o ultimo
			while (get_node(str("Allies/",int(random_target))) == null):
				random_target = (random_target + 1) % allies_vector.size()
			action_instance.to = [int(random_target), "Allies"]
			print("O inimigo numero ",enemies," vai tentar atacar o aliado numero ",int(random_target))
			action_instance.action = "attack"
			action_instance.action_id = 0
			action_instance.speed = char_database.get_speed(enemies_vector[enemies].id)
			action_memory.append(action_instance)
		enemies += 1


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


# ################################ #
# ###### MENU FUNCTIONALITY ###### # 
# ############################3### #


func toggle_menu(boolean):
	get_node("ActionMenu/Selection/Attack").set_disabled(boolean)
	get_node("ActionMenu/Selection/Skill").set_disabled(boolean)
	get_node("ActionMenu/Selection/Item").set_disabled(boolean)
	get_node("ActionMenu/Selection/Defend").set_disabled(boolean)


func toggle_button(boolean, path):
	get_node(str("ActionMenu/",path)).set_disabled(boolean)


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
		if (BUTTON != null):
			toggle_button(false, BUTTON)
	BUTTON = null

	return_to_Selection()


func _on_Attack_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Attack").show()

	organize_slots("Weapon", actor)


func _on_AttackSlot1_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot1"
	action = "attack"
	action_id = 0


func _on_AttackSlot2_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot2"
	action = "attack"
	action_id = 1

func _on_AttackSlot3_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot3"
	action = "attack"
	action_id = 2


func _on_AttackSlot4_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot4"
	action = "attack"
	action_id = 3


func _on_Skill_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Skill").show()


func _on_Item_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Item").show()
	
	organize_slots("Item", actor)


func _on_ItemSlot1_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot1"
	action = "item"
	action_id = 0


func _on_ItemSlot2_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot2"
	action = "item"
	action_id = 1


func _on_ItemSlot3_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot3"
	action = "item"
	action_id = 2


func _on_ItemSlot4_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot4"
	action = "item"
	action_id = 3


func _on_Defend_pressed():
	action = "defend"


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


func organize_slots(type, actor):
	var unit = allies_vector[actor]
	var num = 1
	var database
	var path
	var object
	var vector
	
	if type == "Weapon":
		database = wpn_database
		path = "ActionMenu/Attack/AttackSlot"
		vector = unit.wpn_vector
	elif type == "Item":
		database = item_database
		path = "ActionMenu/Item/ItemSlot"
		vector = unit.item_vector

	for object in vector:
		var node = get_node(str(path,num,"/", type))
		var durability

		if type == "Weapon":
			durability = database.get_durability(object.id)
		elif type == "Item":
			durability = object.durability

		node.get_node("Label").set_text(str(object.name))
		node.show()
		node.get_parent().set_disabled(false)
		if durability < 0:
			node.get_node("Label1").hide()
			node.get_node("ProgressBar").hide()
		else:
			node.get_node("Label1").show()
			node.get_node("ProgressBar").show()
			node.get_node("ProgressBar").set_max(durability)
			node.get_node("ProgressBar").set_value(object.durability)

		num += 1

	if num < 5:
		var count = 5
		while(count > num):
			count -= 1
			var node = get_node(str(path,count))
			
			node.get_node(type).hide()
			node.set_disabled(true)


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
			toggle_menu(false)
			STATE_NEXT = "SELECT TARGET"
		else:
			var act = action_memory[0]
			var player = get_node(str(act.from[1],"/",act.from[0],"/anim_player"))

			if (get_node(str(act.to[1],"/",act.to[0])) != null) and (get_node(str(act.from[1],"/",act.from[0])) != null):
				if act.action == "defend":
					action_memory.pop_front() # add defense behavior here
				elif act.action == "item":
					STATE_NEXT = "ANIMATION"
				else:
					time = (player.get_animation(act.action).get_length()) * 60
					player.play(act.action)
					STATE_NEXT = "ANIMATION"
			else:
				# Alvo invalido #
				action_memory.pop_front()

	elif STATE == "ANIMATION":
		var act = action_memory[0]
		var player = get_node(str(act.from[1],"/",act.from[0],"/anim_player"))

		time -= 1
		if time <= 1:
			player.play("idle")
			print ("act.action = ", act.action)
			# Aqui deve ficar o filter_action, la em cima ele pega a animação correta ja #
			filter_action(act)
			action_memory.pop_front()
			STATE_NEXT = "EXECUTE ACTION"

	if mouse_cooldown > 0:
		mouse_cooldown -= 1

	STATE = STATE_NEXT