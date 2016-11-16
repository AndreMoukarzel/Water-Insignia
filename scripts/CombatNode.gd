
extends Node2D

const scale = 5

class Unit:
	var id # Unit ID in the character database
	var level
	var db # Char Database
	var hp_current
	var mp_current
	var attack
	var bonus_attack = 0
	var defense
	var bonus_defense = 0
	var special_attack
	var bonus_special_attack = 0
	var special_defense
	var bonus_special_defense = 0
	var speed
	var bonus_speed = 0
	var dexterity
	var bonus_dexterity = 0
	var luck
	var bonus_luck = 0
	var last_weapon # Type of the last weapon used
	var last_skill # Element of the last skill used
	var wpn_vector = [] # Array containing the unit's available weapons
	var skill_vector = [] # Array containing the unit's available skills
	var item_vector = [] # Array containing the unit's available items
	var status_vector = [] # Array containing the Status class (see below)

	func _init(name, level, database):
		self.db = database
		self.level = level
		self.id = db.get_char_id(name)
		self.hp_current = db.get_hp(id, level)
		self.mp_current = db.get_mp(id, level)
		self.attack = db.get_attack(id, level)
		self.defense = db.get_defense(id, level)
		self.special_attack = db.get_sp_attack(id, level)
		self.special_defense = db.get_sp_defense(id, level)
		self.speed = db.get_speed(id, level)
		self.dexterity = db.get_dexterity(id, level)
		self.luck = db.get_luck(id, level)

	# GETTERS

	func get_id():
		return id

	func get_name():
		return db.get_char_name(id)

	func get_level():
		return level

	func get_hp_max():
		return db.get_hp(id, level)

	func get_mp_max():
		return db.get_mp(id, level)

	func get_hp_current():
		return hp_current

	func get_mp_current():
		return mp_current

	func get_allowed_weapons():
		return db.get_weapon_vector(id)

	func get_base_attack():
		return attack

	func get_total_attack():
		return attack + bonus_attack

	func get_base_defense():
		return defense

	func get_total_defense():
		return defense + bonus_defense

	func get_base_special_attack():
		return special_attack

	func get_total_special_attack():
		return special_attack + bonus_special_attack

	func get_base_special_defense():
		return special_defense

	func get_total_special_defense():
		return special_defense + bonus_special_defense

	func get_base_speed():
		return speed

	func get_total_speed():
		return speed + bonus_speed
	
	func get_base_dexterity():
		return dexterity

	func get_total_dexterity():
		return dexterity + bonus_dexterity
	
	func get_base_luck():
		return luck

	func get_total_luck():
		return luck + bonus_luck

	func get_bonus_attack():
		return bonus_attack

	func get_bonus_defense():
		return bonus_defense

	func get_bonus_special_attack():
		return bonus_special_attack

	func get_bonus_special_defense():
		return bonus_special_defense

	func get_bonus_speed():
		return bonus_speed

	func get_bonus_dexterity():
		return bonus_dexterity

	func get_bonus_luck():
		return bonus_luck

	func get_last_weapon():
		return last_weapon

	func get_last_skill():
		return last_skill

	func get_wpn_vector():
		return wpn_vector

	func get_skill_vector():
		return skill_vector

	func get_item_vector():
		return item_vector

	func get_status_vector():
		return status_vector

	# SETTERS

	func set_hp_current(hp):
		self.hp_current = hp

	func set_mp_current(mp):
		self.mp_current = mp

	func set_bonus_attack(bonus_attack):
		self.bonus_attack = bonus_attack

	func set_bonus_defense(bonus_defense):
		self.bonus_defense = bonus_defense

	func set_bonus_special_attack(bonus_special_attack):
		self.bonus_special_attack = bonus_special_attack

	func set_bonus_special_defense(bonus_special_defense):
		self.bonus_special_defense = bonus_special_defense

	func set_bonus_speed(bonus_speed):
		self.bonus_speed = bonus_speed

	func set_bonus_dexterity(bonus_dexterity):
		self.bonus_dexterity = bonus_dexterity

	func set_bonus_luck(bonus_luck):
		self.bonus_luck = bonus_luck

	func set_last_weapon(last_weapon_type):
		self.last_weapon = last_weapon_type

	func set_last_skill(last_skill_elem):
		self.last_skill = last_skill_elem

	# MODIFIERS
	func modify_hp_current(mod): # mod < 0 means damage || mod > 0 means heal
		self.hp_current += mod

	func modify_mp_current(mod): # mod < 0 means skill used || mod > 0 means MP recovered
		self.mp_current += mod

	func increase_bonus_attack(bonus):
		self.bonus_attack += bonus

	func decrease_bonus_attack(bonus):
		self.bonus_attack -= bonus

	func increase_bonus_defense(bonus):
		self.bonus_defense += bonus

	func decrease_bonus_defense(bonus):
		self.bonus_defense -= bonus

	func increase_bonus_speed(bonus):
		self.bonus_speed += bonus

	func decrease_bonus_speed(bonus):
		self.bonus_speed -= bonus

	func increase_bonus_dexterity(bonus):
		self.bonus_dexterity += bonus

	func decrease_bonus_dexterity(bonus):
		self.bonus_dexterity -= bonus

	func increase_bonus_luck(bonus):
		self.bonus_luck += bonus

	func decrease_bonus_luck(bonus):
		self.bonus_luck -= bonus

class weapon:
	var id # Weapon ID in the weapon database
	var name # Weapon name in the weapon database
	var durability # Weapon durability
	var type # Weapon type - sword, axe, spear or natural

	func _init(name, database):
		self.id = database.get_wpn_id(name)
		self.name = name
		self.durability = database.get_durability(id)
		self.type = database.get_wpn_type(id)

	# GETTERS
	func get_id():
		return id

	func get_name():
		return name

	func get_durability():
		return durability

	func get_type():
		return type

	# SETTERS
	func set_durability(durability):
		self.durability = durability

	func decrease_durability():
		self.durability -= 1

class skill:
	var id
	var name
	var type # HP and/or Effect
	var cost 
	var mult # Quadratic function that multiplies skill's damage
	var status # Skill's status effect (poison, speed up, ...)
	var elem # The skill's element, for the Arcane Triangle
	var mod # Damage modifier of the skill - skill's damage scales with units ATK
	var is_physical # false == skill is special/magical || true == skill is physical
	var melee # true == skill is melee || false == skill isn't mele / is ranged
	var multi_target # true == skill is multi target || false == skill is single target

	func _init(name, database):
		self.id = database.get_skill_id(name)
		self.name = name
		self.type = database.get_skill_type(id)
		self.cost = database.get_skill_cost(id)
		self.mult = database.get_skill_multiplayer(id)
		self.status = database.get_skill_status(id)
		self.elem = database.get_skill_element(id)
		self.is_physical = database.get_is_physical(id)
		self.melee = database.get_is_melee(id)
		self.multi_target = database.get_multi_target(id)

	# GETTERS
	func get_id():
		return id

	func get_name():
		return name

	func get_type():
		return type

	func get_cost():
		return cost

	func get_mult():
		return mult

	func get_status():
		return status

	func get_elem():
		return elem

	func get_mod():
		return mod

	func get_is_physical():
		return is_physical

	func get_is_melee():
		return melee

	func get_is_multi_target():
		return multi_target

class item:
	var id
	var name 
	var type # HP and/or Effect
	var hp # How much the HP will be affected by the item
	var status # Item's status effect (poison, speed up, ...)
	var max_amount # Item's total amount
	var amount

	func _init(name, database):
		self.id = database.get_item_id(name)
		self.name = name
		self.type = database.get_item_type(id)
		self.hp = database.get_item_hp(id)
		self.status = database.get_item_status(id)
		self.max_amount = database.get_item_stack(id)
		self.amount = self.max_amount

	func get_id():
		return id

	func get_name():
		return name

	func get_type():
		return type

	func get_hp():
		return hp

	func get_status():
		return status

	func get_max_amount():
		return max_amount

	func get_amount():
		return amount

	# SETTERS
	func set_amount(amount):
		self.amount = amount

class action_class:
	var from # Who is acting
	var to # Who is the target of the action
	var action # Which action is being performed
	var action_id # Which slot of the action button (ATTACK, SKILL, ITEM) was pressed
	var speed # Speed of the action

	# GETTERS
	func get_from():
		return from

	func get_to():
		return to

	func get_action():
		return action

	func get_action_id():
		return action_id

	func get_speed():
		return speed

	# SETTERS
	func set_from(from):
		self.from = from

	func set_to(to):
		self.to = to

	func set_action(action):
		self.action = action

	func set_action_id(action_id):
		self.action_id = action_id

	func set_speed(speed):
		self.speed = speed

class status:
	var id
	var name
	var type # See status_database
	var hp # How much will affect target HP per turn
	var effect # Status' effect - how much it will increase or decrease a status
	var stat # Stats (ATK, DEF, SPD) it affects
	var duration # Status' current timer
	var max_duration # Status' initial timer

	func _init(name, database):
		self.id = database.get_status_id(name)
		self.name = name
		self.type = database.get_status_type(id)
		self.hp = database.get_status_hp(id)
		self.effect = database.get_status_effect(id)
		self.stat = database.get_status_stat(id)
		self.max_duration = database.get_status_duration(id)
		self.duration = self.max_duration

	# GETTERS
	func get_id():
		return id

	func get_name():
		return name

	func get_type():
		return type

	func get_hp():
		return hp

	func get_effect():
		return effect

	func get_stat():
		return stat

	func get_duration():
		return duration

	func get_max_duration():
		return max_duration

	# SETTERS
	func set_duration(duration):
		self.duration = duration


# Arrays containing each unit in combat
# Each element in each array is an unit class
var allies_vector = []
var enemies_vector = []

var recruit_vector = []

# Arrays containing the position of each unit in combat, counting from 0 from the top to the bottom
var allies_pos = []
var enemies_pos = []

var actor = 0
var action = null
var action_id = 10 # Qualquer numero fora do intervalo 0 - 3 é invalido #
var action_memory = []
var action_count = 0

var targeting = false
var turn_start = true
var info_active = false

# Acess databases (are global scripts) #
onready var char_database = get_node("/root/character_database")
onready var wpn_database = get_node("/root/weapon_database")
onready var skill_database = get_node("/root/skill_database")
onready var item_database = get_node("/root/item_database")
onready var stage_database = get_node("/root/stage_database")
onready var status_database = get_node("/root/status_database")

# Acess infomenu #
onready var infomenu = get_node("ActionMenu/InfoMenu")
onready var sfx = get_node("SoundEffects")

# Variable to instance the game's screen size
# Used to properly position the buttons and units as well
var window_size

var mouse_cooldown = 0
var time = 0
var blink_counter = 0

# Variable to determine which button was pressed (ATTACK, SKILL, ITEM, DEFEND, weapon in ATTACK's slot 1, 2, 3 or 4, ...)
var BUTTON = null

# Determines current state processing
var STATE = ""
var STATE_NEXT = "SELECT TARGET"

var battle = 1 # INUTIL
var stage_battles = 5 # É bom que seja temporário, se n te arrebentarei


func _ready():
	# Get window size #
	window_size = OS.get_window_size()

	var size = allies_vector.size()
	for i in range(size): # Spawns allies
		var unit = allies_vector[0]
		var id = unit.get_id()
		var level = unit.get_level()
		instance_unit(id, level, "Allies")
		allies_vector[size].wpn_vector = unit.get_wpn_vector()
		allies_vector[size].item_vector = unit.get_item_vector()
		allies_vector.pop_front()

	if get_parent().first_play:
		get_parent().first_play = 0
		instance_unit(2, 1, "Allies")
		instance_weapon("Iron Axe", allies_vector[0])
		instance_weapon("Iron Spear", allies_vector[0])
		instance_unit(1, 1, "Allies")
		instance_weapon("Katana", allies_vector[1])
		instance_weapon("Katana", allies_vector[1])
		instance_weapon("Bamboo Sword", allies_vector[1])
		instance_unit(3, 1, "Allies")
		instance_weapon("Fangs", allies_vector[2])
		instance_weapon("Claws", allies_vector[2])
		instance_unit(0, 1, "Allies")
		instance_weapon("Bat Fangs", allies_vector[3])
		instance_weapon("Bat Wings", allies_vector[3])

	generate_mob(get_parent().stage)
	reposition_units() # Position each unit in the beginning of the battle
	resize_menu()      # Position the action buttons in the battle screen
	name_units()       # Rename the units to 0, 1, ..., different from Godot's weird names
	instance_skills()

	set_fixed_process(true)

# ############################### #
# ##### INSTANCING FUNCTIONS #### # 
# ############################### #

# Instance an unit
func instance_unit(id, level, path):
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

	# Add sprite sheet
	anim_sprite.set_sprite_frames(load(str(char_folder, char_database.get_char_name(id), ".tres")))
	anim_sprite.set_scale(Vector2(scale, scale))

	anim_player.set_name("anim_player")
	anim_sprite.add_child(anim_player)
	get_node(path).add_child(anim_sprite)

	var unit_instance = Unit.new(char_database.get_char_name(id), level, char_database)

	if path == "Enemies":
		enemies_vector.append(unit_instance)
	elif path == "Allies":
		allies_vector.append(unit_instance)


# Instance a random mob from the specified stage
func generate_mob(stage):
	var stage_spawner = stage_database.get_stage_spawner(stage)
	var selected_mob
	
	if (battle != stage_battles):
		selected_mob = stage_spawner.get_random_mob()
	else:
		selected_mob = stage_spawner.get_stage_boss()

	for monster in selected_mob.spawns:
		instance_unit(char_database.get_char_id(monster.name), monster.level, "Enemies")

	for unit in enemies_vector:
		var allowed_weapon = unit.get_allowed_weapons()
		
		# Allocates the weapons for each unit of the mob
		for type in allowed_weapon:
			if type == "Sword" or type == "Axe" or type == "Spear":
				var possible_wpns = stage_spawner.get_permited_weapons(type, wpn_database)
				randomize()
				var random = randi() % (possible_wpns.size() + 1)
				
				if random < possible_wpns.size():
					instance_weapon(possible_wpns[random], unit)
			else: # Weapon is certanly a beast or signature weapon
				instance_weapon(type, unit)
		
		# Allocates the items for each unit of the mob
		for i in range(4):
			var item = stage_spawner.get_random_item()
			if item != null: # 50% chance of recieving no item at each slot
				instance_item(item, unit)

#	Adds a random unit from enemies to recruitment list
	randomize()
	recruit_vector.append(enemies_vector[randi() % enemies_vector.size()])



# Owner must be the reference in the correct vector (allies or enemies)
func instance_weapon(name, owner):
	var wpn_instance = weapon.new(name, wpn_database)
	owner.get_wpn_vector().append(wpn_instance)


# Instances skills of all units
func instance_skills():
	if (battle == 1):
		for unit in allies_vector:
			for skill_name in char_database.get_skill_vector(unit.get_id()):
				var skill_instance = skill.new(skill_name, skill_database)
				unit.get_skill_vector().append(skill_instance)

	for unit in enemies_vector:
		for skill_name in char_database.get_skill_vector(unit.get_id()):
			var skill_instance = skill.new(skill_name, skill_database)
			unit.get_skill_vector().append(skill_instance)


# owner is the reference in the correct vector (allies or enemies)
func instance_item(name, owner):
	var item_instance = item.new(name, item_database)
	owner.get_item_vector().append(item_instance)


# target is the unit who is going to be afflicted by the status
func instance_status(name, target):
	var status_instance = status.new(name, status_database)

	var i = 0
	if (target != null):
		for status in target.get_status_vector(): # Refreshes old status if same is re-inflicted
			if status.get_name() == name:
				for type in status.get_type():
					if type == "Buff": # Nulify old effect
						var bonus_atribute
						var bonus = status.get_effect()
	
						if status.get_stat() == "ATK":
							bonus *= target.get_base_attack()
							if bonus != 0:
								target.decrease_bonus_attack(bonus)
							else:
								target.set_bonus_attack(-target.get_base_attack())
							bonus_atribute = target.get_bonus_attack()
						if status.get_stat() == "DEF":
							bonus *= target.get_base_defense()
							if bonus != 0:
								target.decrease_bonus_defense(bonus)
							else:
								target.set_bonus_defense(-target.get_base_defense())
							bonus_atribute = target.get_bonus_defense()
						if status.get_stat() == "SPD":
							bonus *= target.get_base_speed()
							if bonus != 0:
								target.decrease_bonus_speed(bonus)
							else:
								target.set_bonus_speed(-target.get_base_speed())
							bonus_atribute = target.get_bonus_speed()
	
						apply_bonus(bonus_atribute, status.get_stat(), target)
	
	#			Refreshes duration
				target.get_status_vector().remove(i)
			i += 1
	
		target.get_status_vector().append(status_instance)


# Position the units in the battle screen
func reposition_units():
	var num
	var temp = 1

	# Position the allies units (only when battle begins)
	if (battle == 1):
		num = get_node("Allies").get_child_count()
		for child in get_node("Allies").get_children():
			child.set_pos(Vector2(300 - 50*temp, temp*500/(num + 1)))
			allies_pos.append(child.get_pos())
			temp += 1 

	# Position the enemies units
	enemies_pos.clear()
	
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
	get_node("ActionMenu/Return").set_pos(Vector2(window_size.x - (get_node("ActionMenu/Return").get_size().x + 10), -45))
	get_node("Tip").set_pos(Vector2((window_size.x - get_node("Tip").get_size().x)/2 , get_node("ActionMenu").get_pos().y - 45))


# Name the units
func name_units():
	var i = 0;
	
	# Primeiro momento da batalha, precisa nomear todos
	if (battle == 1):
		for child in get_node("Allies").get_children():
			child.set_name(str(i))
			i += 1
		i = 0
		for child in get_node("Enemies").get_children():
			child.set_name(str(i))
			i += 1
	# Momentos seguintes, apenas renomeia os monstros
	else:
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

	time += 30
	STATE_NEXT = "EFFECT"


func unit_info(unit_num):
		var info_scn = load("res://scenes/SelectedInfo.tscn")
		var info = info_scn.instance()
		var pos = allies_pos[unit_num]

		if get_node("Info") != null:
			get_node("Info").set_name("Info_old")
			get_node("Info_old").queue_free()

		info.master = allies_vector[unit_num]
		info.set_name("Info")
		info.set_pos(Vector2(pos.x + 100, pos.y - 50))
		add_child(info)

# ############################### #
# ####### COMBAT FUNCTIONS ###### # 
# ############################### #

func turn_based_system():
	var closest = [-1, -1]

	# Apply the afflicted status on each unit if they are afflicted by anything at all
	# WORK IN PROGRESS
	if turn_start:
		var i = 0
		for char in allies_vector:
			if (char != null):
				status_apply("Allies", i)
				var j = 0
				for stat in char.get_status_vector():
					if stat.get_name() == "DEFEND":
						char.get_status_vector().remove(j)
						char.decrease_bonus_defense(3*char.get_base_defense())
					j += 1
			i += 1
		i = 0
		for char in enemies_vector:
			if (char != null):
				status_apply("Enemies", i)
			i += 1
		turn_start = false
		info_active = false

	# Choose an action and a target (if allowed)
	get_node("Tip").hide()
	if(targeting):
		get_node("Tip").show()
		# Verifies which unit is the closest to the cursor for action target choosing and reticle purposes
		toggle_button(true, BUTTON)
		closest = target_select("All")
		if closest[0] != -1:
			get_node("Target").show()
			get_node("MultiTarget").show()
			var current_action = action_memory[action_memory.size() - 1]
			if (current_action.get_action() == "skill") and (allies_vector[actor].get_skill_vector()[current_action.get_action_id()].get_is_multi_target()):
				var i = 1
				if closest[1] == "Enemies":
					i = 4
				get_node("MultiTarget").show()
				get_node("Target").hide()
				get_node("MultiTarget").set_pos(Vector2(i * window_size.x/5, window_size.y/2 - 50))
			else:
				get_node("MultiTarget").hide()
				get_node("Target").show()
				get_node("Target").set_pos(get_node(str(closest[1], "/", closest[0])).get_pos())

			# Receives the action's target when the left button mouse is clicked
			if Input.is_action_pressed("left_click") and mouse_cooldown == 0:
				toggle_button(false, BUTTON)
				BUTTON = null
				mouse_cooldown = 30
				action_memory[action_count].set_to(closest)
				get_node(str("Allies/", actor)).set_opacity(1) # in case of blinking
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()

				info_active = false
				targeting = false

				return_to_Selection()

	# Executes the chosen actions
	if(action_memory.size() < get_node("Allies").get_child_count()):
		if(process_action()):
			if action_memory[action_count].get_action() != "defend":
				targeting = true
			else: # Execute DEFEND command
				var act = action_memory[action_count]
				var effect = get_node("Effects")

				# Verifies who chose to defend and increses the actor's defense accordingly
				if act.get_from()[1] == "Allies":
					instance_status("DEFEND", allies_vector[act.get_from()[0]])
					var bonus = 3*allies_vector[act.get_from()[0]].get_base_defense()
					allies_vector[act.get_from()[0]].increase_bonus_defense(bonus)
				elif act.get_from()[1] == "Enemies":
					instance_status("DEFEND", enemies_vector[act.get_from()[0]])
					var bonus = 3*enemies_vector[act.get_from()[0]].get_base_defense()
					enemies_vector[act.get_from()[0]].increase_bonus_defense(bonus)

				# Plays the DEFEND animation
				effect.set_pos(get_node(str(act.get_from()[1], "/", act.get_from()[0])).get_pos())
				effect.get_node("AnimatedSprite/AnimationPlayer").play("defend")

				get_node(str("Allies/", actor)).set_opacity(1) # in case of blinking
				action_memory[action_count].set_to([actor, "Allies"])
				actor = (actor + 1) % allies_pos.size()
				action_count = (action_count + 1) % allies_pos.size()
				info_active = false

				return_to_Selection()

	# After all the allies' actions were chosen, begins the combat phase
	if(action_memory.size() == get_node("Allies").get_child_count()) and (!targeting):
		toggle_menu(true)
		enemy_attack_beta()
		action_memory.sort_custom(self, "compare_speed")
		turn_start = true
		STATE_NEXT = "EXECUTE ACTION"

		get_node("Info").set_name("Info_old")
		get_node("Info_old").queue_free()
		info_active = true # So info can update on first ally before info shows up
		get_node("Tip").hide()

# Instances the unit's action (actor, target, ...) and puts it in the action_memory array
func process_action():
	if action != null:
		if action == "attack":
			var weapon = allies_vector[actor].get_wpn_vector()[action_id].get_type()
			allies_vector[actor].set_last_weapon(null)
			if weapon != "Natural":
				allies_vector[actor].set_last_weapon(weapon)
		elif action == "skill":
			var skill = allies_vector[actor].get_skill_vector()[action_id].get_elem()
			allies_vector[actor].set_last_skill(null)
			if skill != null:
				allies_vector[actor].set_last_skill(skill)

		var action_instance = action_class.new()
		action_instance.set_from([actor, "Allies"])
		action_instance.set_action_id(action_id)
		action_instance.set_speed(allies_vector[actor].get_total_speed())
		action_instance.set_action(action)

		action_memory.append(action_instance)
		action = null
		action_id = 10
		return 1
	return 0


# Receives an action_class instance and decides if it's an ATTACK, an SKILL or an ITEM
func filter_action(act):
	var attacker
	if act.get_from()[1] == "Allies":
		attacker = allies_vector
	elif act.get_from()[1] == "Enemies":
		attacker = enemies_vector

	# Lidamos com a defesa em cima, pois ela precisa acontecer antes de tudo #
	if (act.get_action() == "attack" or act.get_action() == "attackSword" or act.get_action() == "attackAxe" or act.get_action() == "attackSpear"):
		process_attack(act.get_action_id(), act.get_from()[1], act.get_from()[0], act.get_to()[1], act.get_to()[0])
	elif (act.get_action() == "skill"):
		process_skill(act.get_action_id(), act.get_from()[1], act.get_from()[0], act.get_to()[1], act.get_to()[0])
	elif (act.get_action() == "item"):
		process_item(act.get_action_id(), act.get_from()[1], act.get_from()[0], act.get_to()[1], act.get_to()[0])


# Executes an ATTACK action
func process_attack(action_id, attacker_side, attacker_vpos, defender_side, defender_vpos):
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
	var char_atk = attacker[attacker_vpos].get_total_attack() # Attacker's total attack
	var char_dex = attacker[attacker_vpos].get_total_dexterity() # Attacker's total dexterity
	var char_luk = attacker[attacker_vpos].get_total_luck() # Attacker's total luck
	var wpn_atk = wpn_database.get_attack(attacker[attacker_vpos].get_wpn_vector()[action_id].get_id()) # Attacker's weapon power

	var defender_def = defender[defender_vpos].get_total_defense() # Defender's total defense
	var defender_dex = defender[defender_vpos].get_total_dexterity() # Defender's total dexterity
	var defender_spd = defender[defender_vpos].get_total_speed() # Attacker's total speed

	# Check for defender avoidance
	randomize()
	var random = randi() % 200
	if (random < defender_spd):
		# Attack misses
		damage_box("Miss!", Color(0.5, 0, 0), get_node(str(defender_side, "/", defender_vpos)).get_pos())
	else:
		# Attack hits

		# Damage modifier by the Weapon Triangle
		var tri = 1
		var atk_wpn = attacker[attacker_vpos].get_last_weapon()
		var def_wpn = defender[defender_vpos].get_last_weapon()
		if (atk_wpn == "Sword" and def_wpn == "Axe") or (atk_wpn == "Axe" and def_wpn == "Spear") or (atk_wpn == "Spear" and def_wpn == "Sword"):
			tri = 1.15
		elif (def_wpn == "Sword" and atk_wpn == "Axe") or (def_wpn == "Axe" and atk_wpn == "Spear") or (def_wpn == "Spear" and atk_wpn == "Sword"):
			tri = 0.85

		# Assumindo que o maximo de dexterity é 60
		randomize()
		random = rand_range(0, 0.4)
		var attack_damage = (char_atk - (random * (80 - char_dex)/80)) + wpn_atk
		
		randomize()
		random = randi() % 100
		var critical = false
		if (random < char_luk):
			critical = true

		# Actual damage calculation
		var damage = floor((attack_damage - defender_def) * tri)  # Damage dealt
		if (critical):
			damage * 1.5

		# Decreases the weapon's durability
		# If the target dies prior to the attack being dealt, the durability doesn't decrease
		attacker[attacker_vpos].get_wpn_vector()[action_id].decrease_durability()

		# DEFEND command greatly increses the unit's defense for only one attack or one turn
		# So, after the unit is attacked or the turn ends, the bonus defense should be reduced

		var i = 0
		for stat in defender[defender_vpos].get_status_vector():
			if stat.get_name() == "DEFEND":
				defender[defender_vpos].get_status_vector().remove(i)
				var bonus = 3*defender[defender_vpos].get_base_defense()
				defender[defender_vpos].decrease_bonus_defense(bonus)
			i += 1

		# damage can't be lower than zero
		if (damage <= 0):
			damage = 1
	
		# Reduces the defender's HP and shows it in the combat screen
		if (critical):
			damage_box(str(damage, "!!"), Color(1, 0.5, 0), get_node(str(defender_side, "/", defender_vpos)).get_pos())
		else:
			damage_box(str(damage), Color(1, 0, 0), get_node(str(defender_side, "/", defender_vpos)).get_pos())
		defender[defender_vpos].modify_hp_current(-damage)

	# If the attack kills the defender
	if (defender[defender_vpos].get_hp_current() <= 0):
		#efeito visual aqui#
		defender[defender_vpos] = null
		get_node(str(defender_side, "/", defender_vpos)).queue_free()
		# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
		if defender_side == "Enemies":
			enemies_pos[defender_vpos] = Vector2(-100, -100)
		elif defender_side == "Allies":
			allies_pos[defender_vpos] = Vector2(-100, -100)

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

	var skill = user[user_vpos].get_skill_vector()[action_id]
	var cost = skill.get_cost()

	# Reduces the user's MP in the corresponding cost.
	# MP isn't spent if the target dies before the skill is used
	user[user_vpos].modify_mp_current(-cost)

	if not skill.get_is_multi_target():
		for type in skill.get_type():
			if type == "HP":
				var is_physical = user[user_vpos].get_skill_vector()[action_id].get_is_physical()
				# Damage modifier by the Arcane Triangle
				var tri = 1
				var atk_skill = user[user_vpos].get_last_skill()
				var def_skill = target[target_vpos].get_last_skill()
				if (atk_skill == "Water" and def_skill == "Fire") or (atk_skill == "Wind" and def_skill == "Water") or (atk_skill == "Fire" and def_skill == "Wind"):
					tri = 1.1;
				elif (def_skill == "Water" and atk_skill == "Fire") or (def_skill == "Wind" and atk_skill == "Water") or (def_skill == "Fire" and atk_skill == "Wind"):
					tri = 0.9;
				# Special/Magic defense of the target. If it's a Damage-type HP skill, the damage will be reduced
				var reduce_damage = 0
				var mult = skill.get_mult()
				if mult[0] < 0 or mult[1] < 0 or mult[2] < 0:
					if is_physical:
						reduce_damage = target[target_vpos].get_total_defense()
					else:
						reduce_damage = target[target_vpos].get_total_special_defense()
	
				# Skill's damage is its base damage plus an amount which scales with the unit's ATK/SPATK
				var damage = mult[0]
				if is_physical:
					damage += mult[1] * user[user_vpos].get_total_attack()
					if mult[2] < 0:
						damage -= mult[2] * mult[2] * user[user_vpos].get_total_attack()
					else:
						damage += mult[2] * mult[2] * user[user_vpos].get_total_attack()
				else:
					damage += mult[1] * user[user_vpos].get_total_special_attack()
					if mult[2] < 0:
						damage -= mult[2] * mult[2] * user[user_vpos].get_total_special_attack()
					else:
						damage += mult[2] * mult[2] * user[user_vpos].get_total_special_attack()
				damage = damage * tri
	
				if damage < 0:
					damage += reduce_damage
					damage = ceil(damage)
					if damage >= 0:
						damage = -1
					damage_box(str(-damage), Color(1, 0, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
				else:
					damage = floor(damage)
					var effect = get_node("Effects")
					damage_box(str(damage), Color(0, 1, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
					effect.set_pos(get_node(str(target_side, "/", target_vpos)).get_pos())
					effect.get_node("AnimatedSprite/AnimationPlayer").play("heal")

				var hp_current = target[target_vpos].get_hp_current()
				target[target_vpos].modify_hp_current(damage)

				# If the skill kills the target
				if target[target_vpos].get_hp_current() <= 0:
					target[target_vpos] = null
					get_node(str(target_side, "/", target_vpos)).queue_free()

					# Pushes the defender's position outside the screen so it can't be targeted
					if target_side == "Enemies":
						enemies_pos[target_vpos] = Vector2(-100, -100)
					elif target_side == "Allies":
						allies_pos[target_vpos] = Vector2(-100, -100)

				# If the skill tries to overheal an unit
				elif target[target_vpos].get_hp_current() > char_database.get_hp(target[target_vpos].get_id(), target[target_vpos].get_level()):
					target[target_vpos].set_hp_current(char_database.get_hp(target[target_vpos].get_id(), target[target_vpos].get_level()))

			elif type == "Effect":
				for stat in skill.get_status():
					instance_status(stat, target[target_vpos])
					if target_side == "Allies":
						status_apply("Allies", target_vpos)
					elif target_side == "Enemies":
						status_apply("Enemies", target_vpos)
	else:
		for type in skill.get_type():
			var target_pos
			if target_side == "Allies":
				target_pos = allies_pos
			elif target_side == "Enemies":
				target_pos = enemies_pos

			if type == "HP":
				var is_physical = user[user_vpos].get_skill_vector()[action_id].get_is_physical()
				var atk_skill = user[user_vpos].get_last_skill()
				for i in range(target.size()):
					if target[i] != null:
						var is_physical = user[user_vpos].get_skill_vector()[action_id].get_is_physical()
						# Damage modifier by the Arcane Triangle
						var tri = 1
						var atk_skill = user[user_vpos].get_last_skill()
						var def_skill = target[i].get_last_skill()
						if (atk_skill == "Water" and def_skill == "Fire") or (atk_skill == "Wind" and def_skill == "Water") or (atk_skill == "Fire" and def_skill == "Wind"):
							tri = 1.2;
						elif (def_skill == "Water" and atk_skill == "Fire") or (def_skill == "Wind" and atk_skill == "Water") or (def_skill == "Fire" and atk_skill == "Wind"):
							tri = 0.8;
						# Special/Magic defense of the target. If it's a Damage-type HP skill, the damage will be reduced
						var reduce_damage = 0
						var mult = skill.get_mult()
						if mult[0] < 0 or mult[1] < 0 or mult[2] < 0:
							if is_physical:
								reduce_damage = target[i].get_total_defense()
							else:
								reduce_damage = target[i].get_total_special_defense()
			
						# Skill's damage is its base damage plus an amount which scales with the unit's ATK/SPATK
						var damage = mult[0]

						if is_physical:
							damage += mult[1] * user[user_vpos].get_total_attack()
							if mult[2] < 0:
								damage -= mult[2] * mult[2] * user[user_vpos].get_total_attack()
							else:
								damage += mult[2] * mult[2] * user[user_vpos].get_total_attack()
						else:
							damage += mult[1] * user[user_vpos].get_total_special_attack()
							if mult[2] < 0:
								damage -= mult[2] * mult[2] * user[user_vpos].get_total_special_attack()
							else:
								damage += mult[2] * mult[2] * user[user_vpos].get_total_special_attack()
						damage = damage * tri

						if damage < 0:
							damage += reduce_damage
							if damage >= 0:
								damage = -1
							damage = ceil(damage)
							damage_box(str(-damage), Color(1, 0, 0), get_node(str(target_side, "/", i)).get_pos())
						else:
							damage = floor(damage)
							var effect = get_node("Effects")
							var side = 1
							if target_side == "Enemies":
								side = 3
							damage_box(str(damage), Color(0, 1, 0), get_node(str(target_side, "/", i)).get_pos())
							effect.set_pos(Vector2(side * window_size.x/4, window_size.y/2 - 50))
							effect.get_node("AnimatedSprite/AnimationPlayer").play("heal wave")
		
						var hp_current = target[i].get_hp_current()
						target[i].modify_hp_current(damage)
		
						# If the skill kills the target
						if target[i].get_hp_current() <= 0:
							target[i] = null
							get_node(str(target_side, "/", i)).queue_free()
		
							# Pushes the defender's position outside the screen so it can't be targeted
							if target_side == "Enemies":
								enemies_pos[i] = Vector2(-100, -100)
							elif target_side == "Allies":
								allies_pos[i] = Vector2(-100, -100)
		
						# If the skill tries to overheal an unit
						elif target[i].get_hp_current() > char_database.get_hp(target[i].get_id(), target[i].get_level()):
							target[i].set_hp_current(char_database.get_hp(target[i].get_id(), target[i].get_level()))

			elif type == "Effect":
				for stat in skill.get_status():
					for i in range(target.size()):
						instance_status(stat, target[i])
						if target_side == "Allies":
							status_apply("Allies", i)
						elif target_side == "Enemies":
							status_apply("Enemies", i)

# Executes an ITEM action
func process_item(action_id, user_side, user_vpos, target_side, target_vpos):
#   Receives the user, the target, the item and the item type
	var user
	var target
	if user_side == "Allies":
		user = allies_vector
	elif user_side == "Enemies":
		user = enemies_vector

	if target_side == "Enemies":
		target = enemies_vector
	elif target_side == "Allies":
		target = allies_vector

	var item = user[user_vpos].get_item_vector()[action_id]

	var amount = item.get_amount()
	item.set_amount(amount - 1)

	for type in item.get_type():
		if type == "HP":
			var damage = item.get_hp()

			target[target_vpos].modify_hp_current(damage)
			if damage < 0: # If it's a damage-type HP item
				damage_box(str(-damage), Color(1, 0, 0), get_node(str(target_side, "/", target_vpos)).get_pos())
			else: # If it's a heal-type HP item
				damage_box(str(damage), Color(0, 1, 0), get_node(str(target_side, "/", target_vpos)).get_pos())

			# If the item kills the target
			if target[target_vpos].get_hp_current() <= 0:
				target[target_vpos] = null
				get_node(str(target_side, "/", target_vpos)).queue_free()

				# Pushes the defender's position outside the screen so it can't be targeted
				if target_side == "Enemies":
					enemies_pos[target_vpos] = Vector2(-100, -100)
				elif target_side == "Allies":
					allies_pos[target_vpos] = Vector2(-100, -100)

			# If the item tries to overheal an unit
			elif target[target_vpos].get_hp_current() > char_database.get_hp(target[target_vpos].get_id(), target[target_vpos].get_level()):
				target[target_vpos].set_hp_current(char_database.get_hp(target[target_vpos].get_id(), target[target_vpos].get_level()))

		# WORK IN PROGRESS
		if type == "Effect":
			for stat in item.get_status():
				instance_status(stat, target[target_vpos])
				if target_side == "Allies":
					status_apply("Allies", target_vpos)
				elif target_side == "Enemies":
					status_apply("Enemies", target_vpos)


# Process the enemies attacks
func enemy_attack_beta():
	var enemies = 0 # Counts how many enemy actions were chosen so far
	var p_attack = 1
	while(enemies < enemies_pos.size()):
		var action_instance = action_class.new()
		
		# If an enemy dies, its position in enemies_vector becomes null, so goes to the next one
		# Avoids receiving action from an enemy that doesn't exist anymore
		while ((enemies_vector[enemies] == null) and (enemies < enemies_pos.size() - 1)):
			enemies += 1

		# Randomly chooses a target to attack, but only from the opposite side
		if enemies_vector[enemies] != null:
			randomize()
			action_instance.set_from([enemies, "Enemies"])
			
			# If the enemy doesn't have any Heal-type item, it will always attack
			for item in enemies_vector[enemies].get_item_vector():
				if (item.get_type()[0] == "HP") and (item.get_hp() > 0):
					var max_hp = enemies_vector[enemies].get_hp_max()
					var current_hp = enemies_vector[enemies].get_hp_current()
					p_attack = float(p_attack) - 0.5*(1 - float(current_hp)/float(max_hp))
					break

			# Attacks or uses a skill
			if randf() <= p_attack:
				# so com chance de acertar allies, por ora
				var random_target = int(rand_range(0, get_node("Allies").get_child_count())) #claramente menos chance de acertar o ultimo
				# If the chosen target is already dead, randomly chooses another one
				while (get_node(str("Allies/",int(random_target))) == null):
					random_target = (random_target + 1) % allies_vector.size()
	
				# Instances the attack
				var wpn_type = enemies_vector[enemies].get_wpn_vector()[0].get_type()
				var skill_elem = enemies_vector[enemies].get_skill_vector()[0].get_elem()
				enemies_vector[enemies].set_last_weapon(null)
				enemies_vector[enemies].set_last_skill(null)
				if wpn_type != "Natural":
					enemies_vector[enemies].set_last_weapon(wpn_type)
				if skill_elem != null:
					enemies_vector[enemies].set_last_skill(skill_elem)
	
				action_instance.set_to([int(random_target), "Allies"])
				action_instance.set_action("attack")
				action_instance.set_action_id(0)
				action_instance.set_speed(enemies_vector[enemies].get_total_speed())
				action_memory.append(action_instance)
			else: # Uses a Heal-type item, if has one
				var max_hp = enemies_vector[enemies].get_hp_max()
				var current_hp = enemies_vector[enemies].get_hp_current()
				var id = 0
				for item in enemies_vector[enemies].get_item_vector():
					if (item.get_type()[0] == "HP") and (item.get_hp() > 0):
						action_instance.set_to([enemies, "Enemies"])
						action_instance.set_action("item")
						action_instance.set_action_id(id)
						action_instance.set_speed(enemies_vector[enemies].get_total_speed())
						action_memory.append(action_instance)
					id += 1
		enemies += 1


# Compares the speed between two units to decides who acts first
func compare_speed(act1, act2):
	if act1.get_speed() <= act2.get_speed():
		return false
	else:
		return true


# blinks an unit to indicate it's the one whose action is being chosen
func blink(actor, counter):
	if counter < 20:
		get_node(str("Allies/",actor)).set_opacity(1)
	else:
		get_node(str("Allies/",actor)).set_opacity(0.5)


# Applies the status in target unit
func status_apply(target_side, target_vpos):
	var target
	if target_side == "Enemies":
		target = enemies_vector[target_vpos]
	elif target_side == "Allies":
		target = allies_vector[target_vpos]
	
	if target != null and target.get_status_vector().size() != 0:
		var i = 0
		var target_died = false

		for status in target.get_status_vector():
			for type in status.get_type():
				if (type == "HP") and turn_start:
					var pos = get_node(str(target_side, "/", target_vpos)).get_pos()
					var damage = status.get_hp()
					var color

					if damage > 0:
						color = Color(0, 1, 0)
						damage_box(str(damage), color, pos)
					else:
						color = Color(1, 0, 0)
						damage_box(str(-damage), color, pos)

					target.modify_hp_current(damage)

					if target.get_hp_current() <= 0: # If the item kills the target
						target = null
						get_node(str(target_side, "/", target_vpos)).queue_free()
						# Pushes the defender's position outside the screen so it can't be targeted/clicked anymore
						if target_side == "Enemies":
							enemies_pos[target_vpos] = Vector2(-100, -100)
						elif target_side == "Allies":
							allies_pos[target_vpos] = Vector2(-100, -100)
						target_died = true
						break

				elif type == "Buff":
					if status.get_duration() == status.get_max_duration() or status.get_duration() == 1:
						var pos = get_node(str(target_side, "/", target_vpos)).get_pos()
						var base_atribute
						var bonus_atribute
						var bonus

						if status.get_stat() == "ATK":
							base_atribute = target.get_base_attack()
							bonus_atribute = target.get_bonus_attack()
						elif status.get_stat() == "DEF":
							base_atribute = target.get_base_defense()
							bonus_atribute = target.get_bonus_defense()
						elif status.get_stat() == "SPD":
							base_atribute = target.get_base_speed()
							bonus_atribute = target.get_bonus_speed()

						bonus = status.get_effect() * base_atribute
						if bonus < 0:
							bonus = ceil(bonus)
							if bonus == 0:
								bonus = -1
						elif bonus > 0:
							bonus = floor(bonus)
							if bonus == 0:
								bonus = 1

						if status.get_duration() == 1:
							if bonus != 0:
								bonus = -bonus
							else:
								bonus = base_atribute
							apply_bonus(bonus, status.get_stat(), target)

						elif status.get_duration() == status.get_max_duration():
							if bonus != 0:
								damage_box(str(status.get_stat(), "+", bonus), Color(0, 0, 1), pos)
							else:
								bonus = -(base_atribute + bonus_atribute)
								damage_box(str(status.get_stat(), "NEGATED"), Color(1, 0.5, 0), pos)
							apply_bonus(bonus, status.get_stat(), target)

				elif type == "Dispell":
					for removable in status.get_effect():
						for status in target.get_status_vector():
							if status.get_name() == removable:
								# Sets the status duration to 1 so it can be removed in the end of status_apply()
								status.set_duration(1)
	
								var base_atribute
								var bonus_atribute
								var bonus
		
								if status.get_stat() == "ATK":
									base_atribute = target.get_base_attack()
									bonus_atribute = target.get_bonus_attack()
								elif status.get_stat() == "DEF":
									base_atribute = target.get_base_defense()
									bonus_atribute = target.get_bonus_defense()
								elif status.get_stat() == "SPD":
									base_atribute = target.get_base_speed()
									bonus_atribute = target.get_bonus_speed()
		
								bonus = status.get_effect() * base_atribute

								if bonus != 0:
									bonus = -bonus
								else:
									bonus = (base_atribute + bonus_atribute)
								apply_bonus(bonus, status.get_stat(), target)
			
			if (target_died):
				break
			
			
			if turn_start:
				var duration = status.get_duration()
				status.set_duration(duration - 1)

			if status.get_duration() <= 0:
				target.get_status_vector().remove(i)

			i += 1


func apply_bonus(bonus, stat, target):
	# Might actually decrease if bonus is negative
	if stat == "ATK":
		target.increase_bonus_attack(bonus)
	elif stat == "DEF":
		target.increase_bonus_defense(bonus)
	elif stat == "SPD":
		target.increase_bonus_speed(bonus)


func buff_boss():
	get_node("Enemies/0").set_scale(Vector2(-scale * 1.5, scale * 1.5))
	enemies_vector[0].set_hp_current(ceil(enemies_vector[0].get_hp_max() * 1.5))
	enemies_vector[0].attack = (enemies_vector[0].get_base_attack()) * 1.1
	enemies_vector[0].special_attack = (enemies_vector[0].get_base_special_attack()) * 1.1
	enemies_vector[0].defense = (enemies_vector[0].get_base_defense()) * 1.1
	enemies_vector[0].special_defense = (enemies_vector[0].get_base_special_defense()) * 1.1
	enemies_vector[0].speed = (enemies_vector[0].get_base_speed()) * 1.1
	enemies_vector[0].dexterity = (enemies_vector[0].get_base_dexterity()) * 1.1
	enemies_vector[0].luck = (enemies_vector[0].get_base_luck()) * 1.1


# Victory or Defeat condition. Either way, goes to the management screen
func win_lose_cond():
	# Depois podemos mudar os numeros que interagem com "battle", para dinamicamente escolhermos o numero de batalhas por stage
	if get_node("Enemies").get_child_count() < 1:
		for unit in allies_vector:
			if unit != null:
				for wpn in unit.get_wpn_vector():
					if wpn.get_type() == "Natural":
						wpn.set_durability(-1)
		print("GG IZI")
		if battle % stage_battles == 0:
			var recruit_scn = load("res://scenes/Recruit.tscn")
			var recruit = recruit_scn.instance()

			set_fixed_process(false)

#			Destroy broken weapons
			for unit in allies_vector:
				if unit != null:
					var i = 0
					for wpn in unit.wpn_vector:
						print(wpn.name, "|", wpn.durability)
						if wpn.durability == 0:
							unit.wpn_vector.remove(i)
						i += 1

			add_child(recruit)
		else:
			battle += 1
			enemies_vector.clear()
			action_memory.clear()
			generate_mob(get_parent().stage)
			reposition_units()
			name_units()

			if battle == stage_battles:
				buff_boss()

			instance_skills()
	elif get_node("Allies").get_child_count() < 1:
		print("YOU SUCK")
		get_parent().victory = 0
		if get_parent().barracks.empty():
			var game_over_scn = load("res://scenes/GameOver.tscn")
			var game_over = game_over_scn.instance()

			set_fixed_process(false)

			add_child(game_over)
		else:
			get_parent().set_level("management")


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

# Info menu controlling
func _on_AttackSlot1_mouse_enter():
	if (allies_vector[actor].get_wpn_vector().size() > 0):
		infomenu.adjust_properties(0, "attack", get_node("ActionMenu/Attack/AttackSlot1").get_pos().x, get_node("ActionMenu/Attack/AttackSlot1").get_pos().y, allies_vector[actor].wpn_vector[0].id, wpn_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)

func _on_AttackSlot1_mouse_exit():
	infomenu.hide()

func _on_AttackSlot2_mouse_enter():
	if (allies_vector[actor].get_wpn_vector().size() > 1):
		infomenu.adjust_properties(1, "attack", get_node("ActionMenu/Attack/AttackSlot2").get_pos().x, get_node("ActionMenu/Attack/AttackSlot2").get_pos().y, allies_vector[actor].wpn_vector[1].id, wpn_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)

func _on_AttackSlot2_mouse_exit():
	infomenu.hide()


func _on_AttackSlot3_mouse_enter():
	if (allies_vector[actor].get_wpn_vector().size() > 2):
		infomenu.adjust_properties(2, "attack", get_node("ActionMenu/Attack/AttackSlot3").get_pos().x, get_node("ActionMenu/Attack/AttackSlot3").get_pos().y, allies_vector[actor].wpn_vector[2].id, wpn_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_AttackSlot3_mouse_exit():
	infomenu.hide()


func _on_AttackSlot4_mouse_enter():
	if (allies_vector[actor].get_wpn_vector().size() > 3):
		infomenu.adjust_properties(3, "attack", get_node("ActionMenu/Attack/AttackSlot4").get_pos().x, get_node("ActionMenu/Attack/AttackSlot4").get_pos().y, allies_vector[actor].wpn_vector[3].id, wpn_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_AttackSlot4_mouse_exit():
	infomenu.hide()

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
	
# Info menu controlling

func _on_SkillSlot1_mouse_enter():
	if (allies_vector[actor].get_skill_vector().size() > 0):
		infomenu.adjust_properties(0, "skill", get_node("ActionMenu/Skill/SkillSlot1").get_pos().x, get_node("ActionMenu/Skill/SkillSlot1").get_pos().y, allies_vector[actor].skill_vector[0].id, skill_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)

func _on_SkillSlot1_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")

func _on_SkillSlot2_mouse_enter():
	if (allies_vector[actor].get_skill_vector().size() > 1):
		infomenu.adjust_properties(1, "skill", get_node("ActionMenu/Skill/SkillSlot2").get_pos().x, get_node("ActionMenu/Skill/SkillSlot2").get_pos().y, allies_vector[actor].skill_vector[1].id, skill_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_SkillSlot2_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")


func _on_SkillSlot3_mouse_enter():
	if (allies_vector[actor].get_skill_vector().size() > 2):
		infomenu.adjust_properties(2, "skill", get_node("ActionMenu/Skill/SkillSlot3").get_pos().x, get_node("ActionMenu/Skill/SkillSlot3").get_pos().y, allies_vector[actor].skill_vector[2].id, skill_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_SkillSlot3_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")


func _on_SkillSlot4_mouse_enter():
	if (allies_vector[actor].get_skill_vector().size() > 3):
		infomenu.adjust_properties(3, "skill", get_node("ActionMenu/Skill/SkillSlot4").get_pos().x, get_node("ActionMenu/Skill/SkillSlot4").get_pos().y, allies_vector[actor].skill_vector[3].id, skill_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_SkillSlot4_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")



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
	
# Info menu controlling

func _on_ItemSlot1_mouse_enter():
	if (allies_vector[actor].get_item_vector().size() > 0):
		infomenu.adjust_properties(0, "item", get_node("ActionMenu/Item/ItemSlot1").get_pos().x, get_node("ActionMenu/Item/ItemSlot1").get_pos().y, allies_vector[actor].item_vector[0].id, item_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_ItemSlot1_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")


func _on_ItemSlot2_mouse_enter():
	if (allies_vector[actor].get_item_vector().size() > 1):
		infomenu.adjust_properties(1, "item", get_node("ActionMenu/Item/ItemSlot2").get_pos().x, get_node("ActionMenu/Item/ItemSlot2").get_pos().y, allies_vector[actor].item_vector[1].id, item_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_ItemSlot2_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")


func _on_ItemSlot3_mouse_enter():
	if (allies_vector[actor].get_item_vector().size() > 2):
		infomenu.adjust_properties(2, "item", get_node("ActionMenu/Item/ItemSlot3").get_pos().x, get_node("ActionMenu/Item/ItemSlot3").get_pos().y, allies_vector[actor].item_vector[2].id, item_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_ItemSlot3_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")


func _on_ItemSlot4_mouse_enter():
	if (allies_vector[actor].get_item_vector().size() > 3):
		infomenu.adjust_properties(3, "item", get_node("ActionMenu/Item/ItemSlot4").get_pos().x, get_node("ActionMenu/Item/ItemSlot4").get_pos().y, allies_vector[actor].item_vector[3].id, item_database)
		infomenu.set_opacity(0)
		infomenu.show()
		infomenu.set_opacity(0.8)


func _on_ItemSlot4_mouse_exit():
	infomenu.hide()
	get_node("ActionMenu/InfoMenu/NumericInfo").set_text("")
	get_node("ActionMenu/InfoMenu/Extra1").set_text("")
	get_node("ActionMenu/InfoMenu/Extra2").set_text("")
	
	
######################################################################


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
		vector = unit.get_wpn_vector()
	elif type == "Skill":
		database = skill_database
		path = "ActionMenu/Skill/SkillSlot"
		vector = unit.get_skill_vector()
	elif type == "Item":
		database = item_database
		path = "ActionMenu/Item/ItemSlot"
		vector = unit.get_item_vector()
	
	for object in vector:
		var node = get_node(str(path, num, "/", type))
		var durability
		var max_amount
		
		# Receives the weapon's durability / item's initial amount
		if type == "Weapon":
			durability = database.get_durability(object.get_id())
			node.get_node("sprite").set_texture(load(str("res://resources/sprites/weapons/", object.get_name(), ".tex")))
		elif type == "Item":
			max_amount = object.get_max_amount()
			node.get_node("sprite").set_texture(load(str("res://resources/sprites/items/", object.get_name(), ".tex")))
		
		# Creates the button visuals
		node.get_node("Label").set_text(str(object.get_name()))
		node.show()
		node.get_parent().set_disabled(false)
		
		if type == "Weapon":
			node.get_node("Label1").show()
			node.get_node("ProgressBar").show()
			node.get_node("ProgressBar").set_max(durability)
			node.get_node("ProgressBar").set_value(object.get_durability())
			if object.get_durability() == 0:
				get_node(str(path, num)).set_disabled(true)
			elif object.get_durability() <= 0:
				node.get_node("Label1").hide()
				node.get_node("ProgressBar").hide()
		
		elif type == "Skill":
			node.get_node("Label1").show()
			node.get_node("ProgressBar").hide()
			if unit.get_mp_current() < object.get_cost(): # Button is disabled and cost is red if there isn't enough mana to use the skill
				get_node(str(path, num)).set_disabled(true)
				node.get_node("Label1").add_color_override("font_color", Color(1, 0, 0))
				node.get_node("Label1").set_text(str("Cost: ", object.get_cost()))
			else:
				node.get_node("Label1").add_color_override("font_color", Color(1, 1, 1))
				node.get_node("Label1").set_text(str("Cost: ", object.get_cost()))
		
		elif type == "Item":
			node.get_node("Label1").set_text(str("Amount:\n   ", object.get_amount(), "/", max_amount))
			node.get_node("Label1").show()
			node.get_node("ProgressBar").hide()
			if object.get_amount() <= 0:
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
	get_node("MultiTarget").hide()

	# If it's choosing an action and its target
	if STATE == "SELECT TARGET":
		# The unit keeps blinking while not chosen yet
		if blink_counter == 0:
			blink_counter = 40
		blink_counter -= 1
		
		# If an ally has died, skips its turn to choose an action
		while get_node(str("Allies/", actor)) == null:
			actor += 1 % allies_pos.size()
		blink(actor, blink_counter)

		if !info_active:
			unit_info(actor)
			info_active = true

		turn_based_system()

	# If it's executing the chosen actions
	elif STATE == "EXECUTE ACTION":
		if action_memory.empty(): # If all the actions have been executed
			actor = 0
			action_count = 0
			toggle_menu(false)
			STATE_NEXT = "SELECT TARGET"
		else:
			var act = action_memory[0]
			var player = get_node(str(act.get_from()[1],"/",act.get_from()[0],"/anim_player"))
			var actor

			if act.get_from()[1] == "Allies":
				actor = allies_vector[act.get_from()[0]]
			elif act.get_from()[1] == "Enemies":
				actor = enemies_vector[act.get_from()[0]]

			if (get_node(str(act.get_to()[1], "/", act.get_to()[0])) == null):
				if allies_vector[act.get_from()[0]] != null:
					if allies_vector[act.get_from()[0]].get_skill_vector()[act.get_action_id()].get_is_multi_target():
						var vector
						if act.get_to()[1] == "Enemies":
							vector = enemies_vector
						elif act.get_to()[1] == "Allies":
							vector = allies_vector
						var i = 0
						for t in vector:
							if t != null:
								act.set_to([i, act.get_to()[1]])
								break
							i += 1

			if (get_node(str(act.get_to()[1],"/",act.get_to()[0])) != null) and (get_node(str(act.get_from()[1],"/",act.get_from()[0])) != null):
				if actor.get_total_speed() <= 0:
					action_memory.pop_front()
				else:
					var flag = 1 # If the unit decides to attack itself, it doesn't move from its place (flag == 0)
					if act.get_action() == "defend":
						action_memory.pop_front() # add defense behavior here
					elif act.get_action() == "skill":
						var atk_pos
						var def_pos
						var unit
						var melee

						# Verifies who is attacking and who is being attacked, and moves the attacker to in front of the defender
						sfx.play("Skill")
						if act.get_from()[1] == "Allies":
							melee = allies_vector[act.get_from()[0]].get_skill_vector()[act.get_action_id()].get_is_melee()
							atk_pos = allies_pos[act.get_from()[0]]
							# If skill is multi-target
							if allies_vector[act.get_from()[0]].get_skill_vector()[act.get_action_id()].get_is_multi_target():
								unit = get_node(str("Allies/", act.get_from()[0]))
								if act.get_to()[1] == "Allies":
									unit.set_pos(Vector2(unit.get_pos().x + 50, unit.get_pos().y))
								elif act.get_to()[1] == "Enemies":
									unit.set_pos(Vector2(window_size[0]/2 - 50, window_size[1]/2))

							elif melee:
								if act.get_to()[1] == "Allies":
									def_pos = allies_pos[act.get_to()[0]]
									if act.get_from()[0] == act.get_to()[0]:
										flag = 0
								elif act.get_to()[1] == "Enemies":
									def_pos = enemies_pos[act.get_to()[0]]
								unit = get_node(str("Allies/", act.get_from()[0]))
								unit.set_pos(Vector2(def_pos[0] - flag * 200, def_pos[1]))
							else:
								unit = get_node(str("Allies/", act.get_from()[0]))
								unit.set_pos(Vector2(atk_pos[0] + 50, atk_pos[1]))

						elif act.get_from()[1] == "Enemies":
							melee = enemies_vector[act.get_from()[0]].get_skill_vector()[act.get_action_id()].get_is_melee()
							atk_pos = enemies_pos[act.get_from()[0]]
							if enemies_vector[act.get_from()[0]].get_skill_vector()[act.get_action_id()].get_is_multi_target():
								unit = get_node(str("Allies/", act.get_from()[0]))
								unit.set_pos(Vector2(window_size[0]/2 + 50, window_size[1]/2))

							elif melee:
								if act.get_to()[1] == "Allies":
									def_pos = allies_pos[act.get_to()[0]]
								elif act.get_to()[1] == "Enemies":
									def_pos = enemies_pos[act.get_to()[0]]
								unit = get_node(str("Enemies/", act.get_from()[0]))
								unit.set_pos(Vector2(def_pos[0] + 200, def_pos[1]))
							else:
								unit = get_node(str("Enemies/", act.get_from()[0]))
								unit.set_pos(Vector2(atk_pos[0] - 50, atk_pos[1]))

						
						time = (player.get_animation("skillmagic").get_length()) * 60
						player.play("skillmagic")
						STATE_NEXT = "ANIMATION"
					elif act.get_action() == "item":
						var user_pos
						var unit

						if act.get_from()[1] == "Allies":
							user_pos = allies_pos[act.get_from()[0]]
							unit = get_node(str("Allies/", act.get_from()[0]))
							unit.set_pos(Vector2(user_pos[0] + 50, user_pos[1]))
						elif act.get_from()[1] == "Enemies":
							user_pos = enemies_pos[act.get_from()[0]]
							unit = get_node(str("Allies/", act.get_from()[0]))
							unit.set_pos(Vector2(user_pos[0] - 50, user_pos[1]))

						time = 45
						STATE_NEXT = "ANIMATION"
					else: #action is an attack
						var atk_pos
						var def_pos
						var unit
						var vector

						# Verifies who is attacking and who is being attacked, and moves the attacker to in front of the defender
						if act.get_from()[1] == "Allies":
							vector = allies_vector
							atk_pos = allies_pos[act.get_from()[0]]
							if act.get_to()[1] == "Allies":
								def_pos = allies_pos[act.get_to()[0]]
								if act.get_from()[0] == act.get_to()[0]:
									flag = 0
							elif act.get_to()[1] == "Enemies":
								def_pos = enemies_pos[act.get_to()[0]]
							unit = get_node(str("Allies/", act.get_from()[0]))
							unit.set_pos(Vector2(def_pos[0] - flag * 200, def_pos[1]))

						elif act.get_from()[1] == "Enemies":
							vector = enemies_vector
							atk_pos = enemies_pos[act.get_from()[0]]
							if act.get_to()[1] == "Allies":
								def_pos = allies_pos[act.get_to()[0]]
							elif act.get_to()[1] == "Enemies":
								def_pos = enemies_pos[act.get_to()[0]]
							unit = get_node(str("Enemies/", act.get_from()[0]))
							unit.set_pos(Vector2(def_pos[0] + 200, def_pos[1]))

						unit = vector[act.get_from()[0]]
						if unit.get_last_weapon() != null:
							act.set_action(str(act.get_action(), unit.get_last_weapon()))
						time = (player.get_animation(act.get_action()).get_length()) * 60
						player.play(act.get_action())
						STATE_NEXT = "ANIMATION"
			else:
				# Alvo invalido #
				action_memory.pop_front()


	# If an action is being executed, plays it animation and halts the action executions until the animation is over
	elif STATE == "ANIMATION":
		time -= 1
		if time <= 1:
			var act = action_memory[0]
			var player = get_node(str(act.get_from()[1],"/",act.get_from()[0],"/anim_player"))

			var atk_pos
			var unit
			var vector
			# Verifies who attacked and returns the unit to its original position
			if act.get_from()[1] == "Allies":
				vector = allies_vector
				atk_pos = allies_pos[act.get_from()[0]]
				unit = get_node(str("Allies/", act.get_from()[0]))
				unit.set_pos(Vector2(atk_pos))

			elif act.get_from()[1] == "Enemies":
				vector = enemies_vector
				atk_pos = enemies_pos[act.get_from()[0]]
				unit = get_node(str("Enemies/", act.get_from()[0]))
				unit.set_pos(Vector2(atk_pos))

			unit = vector[act.get_from()[0]]
			if unit.get_last_weapon() != null:
				player.play(str("idle", unit.get_last_weapon()))
			else:
				player.play("idle")
			filter_action(act)
			action_memory.pop_front()
			STATE_NEXT = "EFFECT"

	# 30 frames / 0.5 seconds to let the number from an attack, skill, item or status float from the afflicted one
	elif STATE == "EFFECT":
		time -= 1
		if time < 1:
			win_lose_cond()
			STATE_NEXT = "EXECUTE ACTION"

	# Mouse cooldown so multi clicks doesn't happen
	if mouse_cooldown > 0:
		mouse_cooldown -= 1

	STATE = STATE_NEXT
