# Status timer está com um valor placeholder de 3

extends Node2D

const scale = 5

# Unit class - for instancing an enemy or ally
class unit:
	var id # Unit ID in the character database
	var db # Char Database
	var hp_current # Unit's current HP
	var mp_current # Unit's current MP
	var bonus_attack = 0 # Unit's bonus attack
	var bonus_defense = 0 # Unit's bonus defense
	var speed
	var bonus_speed = 0 # Unit's bonus speed
	var wpn_vector = [] # Array containing the unit's available weapons, be it natural or not
	var skill_vector = [] # Array containing the unit's available skills
	var item_vector = [] # Array containing the unit's available items
	var status_vector = [] # Array containing the Status class (see below)

	func _init(name, database):
		self.db = database
		self.id = db.get_char_id(name)
		self.hp_current = db.get_hp_max(id)
		self.mp_current = db.get_mp_max(id)

	func get_name():
		return db.get_char_name(id)

# Weapon class - for instancing an weapon
class weapon:
	var id # Weapon ID in the weapon database
	var name # Weapon's name
	var durability # Weapon's durability

class skill:
	var id # Skill ID in the weapon database
	var name # Skill's name
	var cost # Skill's mana cost
	var effect # Skill's effect (how much it will heal/damage or amplify/reduce an attribute)
	var status # Skill's status effect (poison, speed up, defense up, ...)
	var type # Skill's type - HP (damage or heal), status (buff or debuff) and dispell (removes buff and/or debuff)

# Item class - for instancing an itenm
class item:
	var id # Item's ID in the item database
	var name # Item's name
	var type # Item's type - HP (damage or heal), status (buff or debuff) and dispell (removes buff and/or debuff)
	var durability # Item's initial amount when the battle begins
	var amount # Item's current amount
	var effect # Item's effect (how much it will heal/damage or amplify/reduce an attribute)
	var status # Item's status effect (poison, speed up, ...)

# Action class - for storing the action of each unit
class action_class:
	var from # Who is acting
	var to # Who is the target of the action
	var action # Which action is being performed (ATTACK, SKILL, ITEM, DEFEND)
	var action_id # Which slot of the action (ATTACK, SKILL, ITEM) was pressed
	var speed # Speed of the unit performing the action - used to order the actions

# Status class - for knowing which status is afflicting an unit
class status:
	var name # Status' name - it can come from an item or a skill, so it doesn't have its own database
	var status # Status' status - Poison, paralysis, speed up, attack up, ...
	var timer # Number of turns remaining the status will be afflicting the unit
	var effect # Status' effect - how much it will increase or decrease a status

# Arrays containing each unit in combat
# Each element in each array is an unit class
var allies_vector = []
var enemies_vector = []

# Arrays containing the position of each unit in combat, counting from 0 from the top to the bottom
var allies_pos = []
var enemies_pos = []

var actor = 0
var action = null
var action_id = 10 # Qualquer numero fora do intervalo 0 - 3 é invalido #
var action_memory = []
var action_count = 0

# (targeting == true) = time to choose an action and a target for said action
var targeting = false

# Variables to instance each database
var char_database
var wpn_database
var skill_database
var item_database

# Variable to instance the game's screen size
# Used to properly position the buttons and units as well
var window_size

var mouse_cooldown = 0 # Cooldown for when the mouse's button is pressed, avoiding "multiple clicks in a single click"
var time = 0 # time variable for general purposes
var blink_counter = 0 # When an unit is choosing an action, it keeps "blinking"

# Determines if the outcome of the battle was victory or defeat
var end = 0

# Variable to determine which button was pressed (ATTACK, SKILL, ITEM, DEFEND, weapon in ATTACK's slot 1, 2, 3 or 4, ...)
var BUTTON = null

# Determines what is happening: choosing action, executing actions, executing animations....
# and what getting ready for the next action
var STATE = ""
var STATE_NEXT = "SELECT TARGET"

# Determines if it's in the beginning of the turn
# turn_start == 0 : beginning of turn
# turn_start == 1 : begin actions
var turn_start = 0

func _ready():
	
	# Acess databases (are global scripts) #
	char_database = get_node("/root/character_database")
	wpn_database = get_node("/root/weapon_database")
	skill_database = get_node("/root/skill_database")
	item_database = get_node("/root/item_database")
	
	# Get window size #
	window_size = OS.get_window_size()
	
	# TESTING INSTANCING UNITS#
	instance_unit(0, "Allies")
	instance_unit(1, "Allies")
	instance_unit(1, "Allies")
	instance_unit(0, "Enemies")
	instance_unit(0, "Enemies")
	
	# TESTING INSTANCING WEAPONS #
	
	for unit in allies_vector:
		if unit.get_name() == "bat":
			instance_weapon("Bat Fangs", unit)
			instance_weapon("Bat Wings", unit)
			instance_skill("Heal", unit)
			instance_item("PAR bomb", unit)
			instance_item("Bomb", unit)
		if unit.get_name() == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
			instance_skill("Shadow strike", unit)
			instance_item("Detox", unit)
			instance_item("Potion", unit)
			instance_item("Poison bomb", unit)
			instance_item("Speed up", unit)
	
	for unit in enemies_vector:
		if unit.get_name() == "bat":
			instance_weapon("Bat Fangs", unit)
			instance_weapon("Bat Wings", unit)
		if unit.get_name() == "samurai":
			instance_weapon("Katana", unit)
			instance_weapon("Bamboo Sword", unit)
	######################
	
	reposition_units() # Position each unit in the beginning of the battle
	resize_menu()      # Position the action buttons in the battle screen
	name_units()       # Renomeia as unidades par 0, 1, 2, ..., para não ficar com a estranha da Godot
	
	set_fixed_process(true)

# ############################### #
# ##### INSTANCING FUNCTIONS #### # 
# ############################### #

# Vamos precisar de um script auxiliar, que tenhamos o estado inicial
# de cada mob, para quando formos gera-los, termos noção de qual armas,
# skills e etc. eles devem ter no momento inicial.

# Instance an unit
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
	var unit_instance = unit.new(char_database.get_char_name(id), char_database)
	
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


func instance_skill(name, owner):
	
	var id = skill_database.get_skill_id(name)
	
	var skill_instance = skill.new()
	
	# Data instancing segment
	skill_instance.id = id
	skill_instance.name = name
	skill_instance.cost = skill_database.get_skill_cost(id)
	skill_instance.type = skill_database.get_skill_type(id)
	skill_instance.effect = skill_database.get_skill_effect(id)
	skill_instance.status = skill_database.get_skill_status(id)
	owner.skill_vector.append(skill_instance)


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


# target is the unit who is going to be afflicted by the status
func instance_status(name, stat, target, effect):
	var status_instance = status.new()
	status_instance.name = name
	status_instance.status = stat
	status_instance.timer = 3 # <-- number is placeholder
	status_instance.effect = effect
	target.status_vector.append(status_instance)


# Reposition the units in the battle screen
func reposition_units():
	# This function might be altered later, so #
	# enemy units will appear in different     #
	# patterns, depending on their numbers.    #
	
	var num
	
	# Position the allies units
	var temp = 1
	num = get_node("Allies").get_child_count()
	for child in get_node("Allies").get_children():
		child.set_pos(Vector2(300 - 50*temp, temp*500/(num + 1)))
		allies_pos.append(child.get_pos())
		temp += 1 
	
	# Position the enemies units
	temp = 1
	num = get_node("Enemies").get_child_count()
	for child in get_node("Enemies").get_children():
		child.set_pos(Vector2(window_size.x - 300 + 50*temp, temp*500/(num + 1)))
		child.set_scale(Vector2(-scale, scale))
		enemies_pos.append(child.get_pos())
		temp += 1 


# Position each action window in the combat screen
func resize_menu():
	get_node("ActionMenu").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Selection").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Attack").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Skill").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Item").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Return").set_pos(Vector2(window_size.x - 104, -45))


# Name the units
func name_units():
	var i = 0;

	for child in get_node("Allies").get_children():
		child.set_name(str(i))
		i += 1
	i = 0
	for child in get_node("Enemies").get_children():
		child.set_name(str(i))
		i += 1


# Damage/Heal value that floats out of an attacked/healed unit
# Red = general damage || Green = heal || Purple = poison damage || Blue = buff amount
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
	# completamente vazia ou a party inteira morrer).                     #
	# Ele precisa estar integrado com a seleção dos menus, logo, é        #
	# pertinente fazer uma função que aguarda os comandos do jogador,     #
	# dependendo do numero de party members.                              #
	var closest = [-1, -1]
	
	# Apply the afflicted status on each unit if they are afflicted by anything at all
	# WORK IN PROGRESS
	if (turn_start == 0):
		var i = 0
		for char in allies_vector:
			if (char != null):
				print ("allies status apply")
				status_apply(char, "Allies", i)
			i += 1
		i = 0
		for char in enemies_vector:
			if (char != null):
				print ("enemies status apply")
				status_apply(char, "Enemies", i)
			i += 1
		turn_start = 1
	
	# Choose an action and a target (if allowed)
	if(targeting):
		# Verifies which unit is the closest to the cursor for action target choosing and reticle purposes
		toggle_button(true, BUTTON)
		closest = target_select("All")
		if closest[0] != -1:
			get_node("Target").show()
			get_node("Target").set_pos(get_node(str(closest[1], "/", closest[0])).get_pos())
			
			# Receives the action's target when the left button mouse is clicked
			if Input.is_action_pressed("left_click") and mouse_cooldown == 0:
				toggle_button(false, BUTTON)
				BUTTON = null
				mouse_cooldown = 30
				action_memory[action_count].to = closest
				get_node(str("Allies/", actor)).set_opacity(1) # in case of blinking
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()
				targeting = false
				
				return_to_Selection()
	
	# Executes the chosen actions
	if(action_memory.size() < get_node("Allies").get_child_count()):
		if(process_action()):
			if action_memory[action_count].action != "defend":
				targeting = true
			else: # Execute DEFEND command
				var act = action_memory[action_count]
				var effect = get_node("Effects")
				
				# Verifies who chose to defend and increses the actor's defense accordingly
				if act.from[1] == "Allies":
					allies_vector[act.from[0]].bonus_defense = char_database.get_defense(allies_vector[act.from[0]].id) * 2
				elif act.from[1] == "Enemies":
					enemies_vector[act.from[0]].bonus_defense = char_database.get_defense(enemies_vector[act.from[0]].id) * 2
				effect.set_pos(get_node(str(act.from[1], "/", act.from[0])).get_pos())
				effect.get_node("AnimatedSprite/AnimationPlayer").play("defend")
				
				get_node(str("Allies/", actor)).set_opacity(1) # in case of blinking
				action_memory[action_count].to = [actor, "Allies"]
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()
				return_to_Selection()
	
	# After all the allies' actions were chosen, begins the combat phase
	if(action_memory.size() == get_node("Allies").get_child_count()) and (!targeting):
		toggle_menu(true)
		enemy_attack_beta()
		action_memory.sort_custom(self, "compare_speed")
		STATE_NEXT = "EXECUTE ACTION"
		turn_start = 0


# Instances the unit's action (actor, target, ...) and puts it in the action_memory array
func process_action():
	if action != null:
		var action_instance = action_class.new()
		action_instance.from = [actor, "Allies"]
		action_instance.action = action
		action_instance.action_id = action_id
		action_instance.speed = char_database.get_speed(allies_vector[actor].id) + allies_vector[actor].bonus_speed
		action_memory.append(action_instance)
		action = null
		action_id = 10
		return 1
	return 0


# Receives an action_class instance and decides if it's an ATTACK, an SKILL or an ITEM
func filter_action(act):
	var flag = true
	var attacker
	if act.from[1] == "Allies":
		attacker = allies_vector
	elif act.from[1] == "Enemies":
		attacker = enemies_vector
	for stat in attacker[act.from[0]].status_vector:
		if stat.status == "Paralysis":
			flag = false
	
	if flag == true:
		# Lidamos com a defesa em cima, pois ela precisa acontecer antes de tudo #
		if (act.action == "attack"):
			process_attack(act.action_id, act.from[1], act.from[0], act.to[1], act.to[0])
		elif (act.action == "skill"):
			process_skill(act.action_id, act.from[1], act.from[0], act.to[1], act.to[0])
		elif (act.action == "item"):
			process_item(act.action_id, act.from[1], act.from[0], act.to[1], act.to[0])


# Executes an ATTACK action
func process_attack(action_id, attacker_side, attacker_vpos, defender_side, defender_vpos):
	# The formule uses bonus attack, bonus defense, among other elements such as status condition
	# However, it will remain simple for now
	
	# Defines which side (allies or enemies) is attacking and which side is defending #
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
	
	# Calculates the damage of the attack, including attack bonus of the attacker, and defense and defense bonus of the defender #
	var char_atk = char_database.get_attack(attacker[attacker_vpos].id)                     # attacker's base attack
	var char_bonus_atk = attacker[attacker_vpos].bonus_attack                               # attacker's bonus attack due to buffs
	var wpn_atk = wpn_database.get_attack(attacker[attacker_vpos].wpn_vector[action_id].id) # attacker's weapon power
	var char_def = char_database.get_defense(defender[defender_vpos].id)                    # defender's base defense
	var char_bonus_def = defender[defender_vpos].bonus_defense                              # defender's bonus defense due to buffs and DEFEND command
	var damage = (char_atk + char_bonus_atk + wpn_atk) -  (char_def + char_bonus_def)       # damage dealt
	
	# Decreases the weapon's durability
	# If the target dies prior to the attack being dealt, the durability doesn't decrease
	attacker[attacker_vpos].wpn_vector[action_id].durability -= 1
	
	# DEFEND command greatly increses the unit's defense for only one attack
	# So, after the unit is attacked, the bonus defense should be reduced
	defender[defender_vpos].bonus_defense = 0 # <-- FIX THIIIIIIIIIIS
	
	# damage can't be lower than zero
	if (damage < 0):
		damage = 0
	
	# Reduces the defender's HP and shows it in the combat screen
	defender[defender_vpos].hp_current -= damage
	damage_box(str(damage), Color(1, 0, 0), get_node(str(defender_side, "/", defender_vpos)).get_pos())
	
	# Message for when the defender doesn't die
	# Mostly for debugging purpose
	if defender[defender_vpos].hp_current > 0:
		print(str("Um ataque direto! O hp restante é: ", defender[defender_vpos].hp_current))
	
	# If the attack kills the defender
	if (defender[defender_vpos].hp_current <= 0):
		print(str("O inimigo ", defender[defender_vpos].get_name(), " foi derrotado!")) # Message for debugging purpose
		#efeito visual aqui#
		defender[defender_vpos] = null
		get_node(str(defender_side, "/", defender_vpos)).queue_free()
		# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
		if defender_side == "Enemies":
			enemies_pos[defender_vpos] = Vector2(-100, -100)
		elif defender_side == "Allies":
			allies_pos[defender_vpos] = Vector2(-100, -100)
		
		# Victory/Defeat condition
		if get_node(defender_side).get_child_count() == 1:
			if defender_side == "Allies":
				print("KILL YOURSELF")
				end = -1
			elif defender_side == "Enemies":
				print("GG IZI")
				end = 1
			get_parent().set_level("management")
		
		return 1 # defender death
	return 0


# Executes a SKILL action
func process_skill(action_id, user_side, user_vpos, target_side, target_vpos):
	var user
	if user_side == "Allies":
		user = allies_vector
	elif user_side == "Enemies":
		user = enemies_vector
	var target
	if target_side == "Enemies":
		target = enemies_vector
	elif target_side == "Allies":
		target = allies_vector
	
	var skill = user[user_vpos].skill_vector[action_id]
	var type = skill.type
	var cost = skill.cost
	
	user[user_vpos].mp_current -= cost # Reduces the user's MP in the corresponding cost. MP isn't spend if the target dies before the skill is used
	
	if type == "HP":
		var damage = skill.effect # How much heal/damage the item will deal
		
		target[target_vpos].hp_current += damage
		if damage < 0: # If it's a damage-type HP skill
			damage_box(str(-damage), Color(1, 0, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
		else:
			damage_box(str(damage), Color(0, 1, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
		
		# If the skill kills the target
		if target[target_vpos].hp_current <= 0:
			target[target_vpos] = null
			get_node(str(target_side, "/", target_vpos)).queue_free()
			
			# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
			if target_side == "Enemies":
				enemies_pos[target_vpos] = Vector2(-100, -100)
			elif target_side == "Allies":
				allies_pos[target_vpos] = Vector2(-100, -100)
			
			# Victory/Defeat condition
			if get_node(target_side).get_child_count() == 1:
				if target_side == "Allies":
					print("KILL YOURSELF")
					end = -1
				elif target_side == "Enemies":
					print("GG IZI")
					end = 1
				get_parent().set_level("management")
		
		# If the skill tries to overheal an unit
		elif target[target_vpos].hp_current > char_database.get_hp_max(target[target_vpos].id):
			target[target_vpos].hp_current = char_database.get_hp_max(target[target_vpos].id)
	
	elif type == "Status":
		instance_status(skill.name, skill.status, target[target_vpos], skill.effect) # Applies the status
	
	# If the item is a Dispell-type item
	elif type == "Dispell":
		var effect = item.status
		if effect == "Poison":
			var i = 0
			for stat in target[target_vpos].status_vector:
				if stat.status == "Poison":
					target[target_vpos].status_vector.remove(i)
				i += 1


# Executes an ITEM action
func process_item(action_id, user_side, user_vpos, target_side, target_vpos):
	# Receives the user, the target and the item type
	var user
	if user_side == "Allies":
		user = allies_vector
	elif user_side == "Enemies":
		user = enemies_vector
	var target
	if target_side == "Enemies":
		target = enemies_vector
	elif target_side == "Allies":
		target = allies_vector
	var item = user[user_vpos].item_vector[action_id]
	var type = item.type
	
	item.amount -= 1
	
	# If the item is an HP-type item (heal or damage)
	if type == "HP":
		var damage = item.effect # How much heal/damage the item will deal
		
		target[target_vpos].hp_current += damage
		if damage < 0: # If it's a damage-type HP item
			damage_box(str(-damage), Color(1, 0, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
		else: # If it's a heal-type HP item
			damage_box(str(damage), Color(0, 1, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
		
		
		# If the item kills the target
		if target[target_vpos].hp_current <= 0:
			target[target_vpos] = null
			get_node(str(target_side, "/", target_vpos)).queue_free()
			
			# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
			if target_side == "Enemies":
				enemies_pos[target_vpos] = Vector2(-100, -100)
			elif target_side == "Allies":
				allies_pos[target_vpos] = Vector2(-100, -100)
			
			# Victory/Defeat condition
			if get_node(target_side).get_child_count() == 1:
				if target_side == "Allies":
					print("KILL YOURSELF")
					end = -1
				elif target_side == "Enemies":
					print("GG IZI")
					end = 1
				get_parent().set_level("management")
		
		# If the item tries to overheal an unit
		elif target[target_vpos].hp_current > char_database.get_hp_max(target[target_vpos].id):
			target[target_vpos].hp_current = char_database.get_hp_max(target[target_vpos].id)
	
	# If the item is an Status-type item
	# WORK IN PROGRESS
	elif type == "Status":
		instance_status(item.name, item.status, target[target_vpos], item.effect)  # Applies the status
	
	# If the item is a Dispell-type item
	elif type == "Dispell":
		var effect = item.status
		if effect == "Poison":
			var i = 0
			for stat in target[target_vpos].status_vector:
				if stat.status == "Poison":
					target[target_vpos].status_vector.remove(i)
				i += 1


# Process the enemies attacks
func enemy_attack_beta():
	var enemies = 0 # Counts how many enemy actions were chosen so far
	while(enemies < enemies_pos.size()):
		var action_instance = action_class.new()
		
		# If an enemy dies, its position in enemies_vector becomes null, so goes to the next one
		# Avoids receiving action from an enemy that doesn't exist anymore
		while ((enemies_vector[enemies] == null) and (enemies < enemies_pos.size() - 1)):
			enemies += 1
		
		# Randomly chooses a target to attack, but only from the opposite side
		if enemies_vector[enemies] != null:
			action_instance.from = [enemies, "Enemies"]
			# so com chance de acertar allies, por ora
			randomize()
			var random_target = int(rand_range(0, get_node("Allies").get_child_count())) #claramente menos chance de acertar o ultimo
			# If the chosen target is already dead, randomly chooses another one
			while (get_node(str("Allies/",int(random_target))) == null):
				random_target = (random_target + 1) % allies_vector.size()
			
			# Instances the attack
			action_instance.to = [int(random_target), "Allies"]
			print("O inimigo numero ", enemies, " vai tentar atacar o aliado numero ", int(random_target))
			action_instance.action = "attack"
			action_instance.action_id = 0
			action_instance.speed = char_database.get_speed(enemies_vector[enemies].id)
			action_memory.append(action_instance)
		enemies += 1


# Compares the speed between two units to decides who acts first
func compare_speed(act1, act2):
	if act1.speed <= act2.speed:
		return false
	else:
		return true


# blinks an unit to indicate it's the one whose action is being chosen
func blink(actor, counter):
	if counter < 20:
		get_node(str("Allies/",actor)).set_opacity(1)
	else:
		get_node(str("Allies/",actor)).set_opacity(0.5)


# Applies the status in a unit (actor)
# WORK IN PROGRESS
func status_apply(actor, target_side, target_vpos):
	var target
	if target_side == "Enemies":
		target = enemies_vector
	elif target_side == "Allies":
		target = allies_vector
	
	if (actor.status_vector.size() != 0):
		for effect in actor.status_vector:
			
			# Applies the effect of Poison
			if effect.status == "Poison":
				var damage = 2
				damage_box(str(damage), Color(0.4, 0, 1), get_node(str(target_side, "/", target_vpos)).get_pos())
				actor.hp_current -= damage
				effect.timer -= 1
				
				# If the item kills the target
				if target[target_vpos].hp_current <= 0:
					target[target_vpos] = null
					get_node(str(target_side, "/", target_vpos)).queue_free()
					# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
					if target_side == "Enemies":
						enemies_pos[target_vpos] = Vector2(-100, -100)
					elif target_side == "Allies":
						allies_pos[target_vpos] = Vector2(-100, -100)
					
					# Victory/Defeat condition
					if get_node(target_side).get_child_count() == 1:
						if target_side == "Allies":
							print("KILL YOURSELF")
							end = -1
						elif target_side == "Enemies":
							print("GG IZI")
							end = 1
						get_node("/root/global").goto_scene("res://scenes/MainMenu.tscn")
				
				# Removes the status effect once its time is up
				if effect.timer == 0:
					var i = 0
					for stat in actor.status_vector:
						if stat.status == "Poison":
							actor.status_vector.remove(i)
						i += 1
			
			# Applies the effect of speed boost
			elif effect.status == "Speed":
				if effect.timer == 3:
					var bonus = effect.effect * actor.speed
					actor.bonus_speed += bonus
					damage_box(str("SPD +", bonus), Color(0, 0, 1), get_node(str(target_side, "/", target_vpos)).get_pos())
				effect.timer -= 1
				if effect.timer == 0:
					actor.bonus_speed -= effect.effect * actor.speed
			
			elif effect.status == "Paralysis":
				effect.timer -= 1
				
				if effect.timer == 0:
					var i = 0
					for stat in actor.status_vector:
						if stat.status == "Paralysis":
							actor.status_vector.remove(i)
						i += 1


# ################################ #
# ###### MENU FUNCTIONALITY ###### # 
# ################################ #


# Disables the action menus while the actions are being executed
func toggle_menu(boolean):
	get_node("ActionMenu/Selection/Attack").set_disabled(boolean)
	get_node("ActionMenu/Selection/Skill").set_disabled(boolean)
	get_node("ActionMenu/Selection/Item").set_disabled(boolean)
	get_node("ActionMenu/Selection/Defend").set_disabled(boolean)


# Disables a button
func toggle_button(boolean, path):
	get_node(str("ActionMenu/",path)).set_disabled(boolean)


# Upon RETURN button is pressed, return to the action select screen
func return_to_Selection():
	var action_menu = get_node("ActionMenu")
	
	action_menu.get_node("Selection").show()
	action_menu.get_node("Attack").hide()
	action_menu.get_node("Skill").hide()
	action_menu.get_node("Item").hide()
	action_menu.get_node("Return").hide()


# When the RETURN button is pressed, what happens code-wise
func _on_Return_pressed():
	action = null
	if(actor == (action_memory.size() - 1)):
		action_memory.pop_back()
		targeting = false
		if (BUTTON != null):
			toggle_button(false, BUTTON)
	BUTTON = null
	
	return_to_Selection()


##################################################################
# \    /\    / _____    /\   _____  _____  |\  | _____
#  \  /  \  /  |____   /--\  |____| |   |  | \ | |____
#   \/    \/   |____  /    \ |      |___|  |  \| ____|
##################################################################

# When the ATTACK button is pressed
func _on_Attack_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Attack").show()
	
	organize_slots("Weapon", actor)

# When the ATTACK slot 1 is pressed
func _on_AttackSlot1_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot1"
	action = "attack"
	action_id = 0

# When the ATTACK slot 2 is pressed
func _on_AttackSlot2_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot2"
	action = "attack"
	action_id = 1

# When the ATTACK slot 3 is pressed
func _on_AttackSlot3_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot3"
	action = "attack"
	action_id = 2

# When the ATTACK slot 4 is pressed
func _on_AttackSlot4_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Attack/AttackSlot4"
	action = "attack"
	action_id = 3


#################################
#  _____ |  / _____ |     |     _____
#  |____ | <    |   |     |     |____
#  ____| |  \ __|__ |____ |____ ____|
#################################

# When the SKILL button is pressed
func _on_Skill_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Skill").show()
	
	organize_slots("Skill", actor)

# When the SKILL slot 1 is pressed
func _on_SkillSlot1_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Skill/SkillSlot1"
	action = "skill"
	action_id = 0

# When the SKILL slot 2 is pressed
func _on_SkillSlot2_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Skill/SkillSlot2"
	action = "skill"
	action_id = 1

# When the SKILL slot 3 is pressed
func _on_SkillSlot3_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Skill/SkillSlot3"
	action = "skill"
	action_id = 2

# When the SKILL slot 4 is pressed
func _on_SkillSlot4_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Skill/SkillSlot4"
	action = "skill"
	action_id = 3


#############################
#  _____ _____ _____ |\  /| _____                
#    |     |   |____ | \/ | |____
#  __|__   |   |____ |    | ____|
#############################

# When the ITEM button is pressed
func _on_Item_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Item").show()
	
	organize_slots("Item", actor)

# When the ITEM slot 1 is pressed
func _on_ItemSlot1_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot1"
	action = "item"
	action_id = 0

# When the ITEM slot 2 is pressed
func _on_ItemSlot2_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot2"
	action = "item"
	action_id = 1

# When the ITEM slot 3 is pressed
func _on_ItemSlot3_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot3"
	action = "item"
	action_id = 2

# When the ITEM slot 4 is pressed
func _on_ItemSlot4_pressed():
	if (BUTTON != null):
		action_memory.pop_back()
		toggle_button(false, BUTTON)
	BUTTON = "Item/ItemSlot4"
	action = "item"
	action_id = 3


# When the DEFEND button is pressed
func _on_Defend_pressed():
	action = "defend"


# Selects the target of a command
func target_select(target):
	var mouse = get_global_mouse_pos()
	var mouse_temp = mouse
	var closest = -1
	var team = null
	var distance = 500 # A unit is being targeted if the mouse is up to 500 units away from its center
	
	
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


# Organizes the slots in the command menu
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
	elif type == "Skill":
		database = skill_database
		path = "ActionMenu/Skill/SkillSlot"
		vector = unit.skill_vector
	elif type == "Item":
		database = item_database
		path = "ActionMenu/Item/ItemSlot"
		vector = unit.item_vector
	
	for object in vector:
		var node = get_node(str(path, num, "/", type))
		var durability
		
		# Receives the weapon's durability / item's initial amount
		if type == "Weapon":
			durability = database.get_durability(object.id)
			node.get_node("sprite").set_texture(load(str("res://resources/sprites/weapons/", object.name, ".tex")))
		elif type == "Item":
			durability = object.durability
			node.get_node("sprite").set_texture(load(str("res://resources/sprites/items/", object.name, ".tex")))
		
		# Creates the button visuals
		node.get_node("Label").set_text(str(object.name))
		node.show()
		node.get_parent().set_disabled(false)
		
		# If the unit has run out of that item or the weapon has broken for too much use
		if type == "Weapon":
			node.get_node("Label1").show()
			node.get_node("ProgressBar").show()
			node.get_node("ProgressBar").set_max(durability)
			node.get_node("ProgressBar").set_value(object.durability)
			if object.durability == 0:
				get_node(str(path, num)).set_disabled(true)
			elif object.durability <= 0:
				node.get_node("Label1").hide()
				node.get_node("ProgressBar").hide()
		
		elif type == "Skill":
			node.get_node("Label1").set_text(str("Cost: ", object.cost))
			node.get_node("Label1").show()
			node.get_node("ProgressBar").hide()
		
		elif type == "Item":
			node.get_node("Label1").set_text("Amount")
			node.get_node("Label1").show()
			node.get_node("ProgressBar").show()
			node.get_node("ProgressBar").set_max(durability)
			node.get_node("ProgressBar").set_value(object.amount)
			if object.amount <= 0:
				get_node(str(path, num)).set_disabled(true)
		num += 1

	# Trava botões não utilizados
	if num < 5:
		var count = 5
		while(count > num):
			count -= 1
			var node = get_node(str(path, count))
			
			node.get_node(type).hide()
			node.set_disabled(true)


# ############################### #
# ######## FIXED PROCESS ######## # 
# ############################### #

func _fixed_process(delta):
	get_node("Target").hide()
	
	# If it's choosing an action and its target
	if STATE == "SELECT TARGET":
		# The unit keeps blinking while not chosen yet
		if blink_counter == 0:
			blink_counter = 40
		blink_counter -= 1
		
		# If an ally has died, skips its turn to choose an action
		while get_node(str("Allies/", actor)) == null:
			actor += 1;
		blink(actor, blink_counter)
		
		turn_based_system()
	
	# If it's executing the chosen actions
	elif STATE == "EXECUTE ACTION":
		if action_memory.empty(): # If all the actions have been executed
			action_count = 0
			toggle_menu(false)
			STATE_NEXT = "SELECT TARGET"
		else:
			var act = action_memory[0]
			var player = get_node(str(act.from[1],"/",act.from[0],"/anim_player"))
			
			if (get_node(str(act.to[1],"/",act.to[0])) != null) and (get_node(str(act.from[1],"/",act.from[0])) != null):
				if act.action == "defend":
					action_memory.pop_front() # add defense behavior here
				elif act.action == "skill":
					STATE_NEXT = "ANIMATION"
				elif act.action == "item":
					STATE_NEXT = "ANIMATION"
				else:
					time = (player.get_animation(act.action).get_length()) * 60
					player.play(act.action)
					STATE_NEXT = "ANIMATION"
			else:
				# Alvo invalido #
				action_memory.pop_front()
	
	# If an action is being executed, plays it animation and halts the action executions until the animation is over
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
	
	# Mouse cooldown so multi clicks doesn't happen
	if mouse_cooldown > 0:
		mouse_cooldown -= 1
	
	STATE = STATE_NEXT
