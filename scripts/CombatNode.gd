
extends Node2D

const scale = 5

class unit:
	var id
	var name
	var hp_current
	var bonus_attack
	var bonus_defense
#	var status_condition

var allies_vector = []
var enemies_vector = []

var allies_pos = []
var enemies_pos = []

var action_memory = [[]]

var char_database
var window_size

var actor
var action

var mouse_cooldown = 0
var time = 0


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
	name_units("Allies")
	name_units("Enemies")

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


func name_units(path):
	var i = 0;

	for child in get_node(path).get_children():
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
	
	var action_number = 0
	
	while (action_number < count_party_members()):
		process_action(action_number)
		action_number += 1

func process_action(acting_unit):
	print("ola, vamos começar a fazer?")
	
	
	

func count_party_members():
	var count = 0
	for i in allies_vector:
		if(i != null):
			count += 1
	return count

func process_attack(attacker, defender_side, defender_vpos):
	# A formula contara com ataque bonus, defesa bonus, #
	# entre outros fatores como status condition, no    #
	# futuro. Por ora, deve ser simples.                #
	
	# Depois podem haver até mais formas de dar dano
	var defender
	if defender_side == "Enemies":
		defender = enemies_vector
	elif defender_side == "Allies":
		defender = allies_vector
	var damage = char_database.get_attack(attacker.id) -  char_database.get_defense(defender[defender_vpos].id)
	if (damage < 0):
		damage = 0
	defender[defender_vpos].hp_current -= damage
	print(str("Um ataque direto! O hp restante é: ", defender[defender_vpos].hp_current))
	
	if (defender[defender_vpos].hp_current <= 0):
		print(str("O inimigo ", defender[defender_vpos].name, " foi derrotado!"))
		#efeito visual aqui#
		defender[defender_vpos] = null
		get_node(str(defender_side, "/", defender_vpos)).queue_free()

		return 1
	return 0

# ############################### #
# ###### MENU FUNTIONALITY ###### # 
# ############################### #

func _on_Return_pressed():
	var action_menu = get_node("ActionMenu")

	action_menu.get_node("Selection").show()
	action_menu.get_node("Attack").hide()
	action_menu.get_node("Skill").hide()
	action_menu.get_node("Item").hide()
	action_menu.get_node("Return").hide()


func _on_Attack_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Attack").show()


func _on_AttackSlot1_pressed():
	actor = "Allies/1/"
	action = "attack"

	# test animation
	if time == 0:
		time = get_node(str(actor,"anim_player")).get_animation(action).get_length()
		time *= 60
		get_node(str(actor,"anim_player")).play(action)



func _on_Skill_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Skill").show()


func _on_Item_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Item").show()


# ############################### #
# ######## FIXED PROCESS ######## # 
# ############################### #

func _fixed_process(delta):
	var mouse = get_global_mouse_pos()
	var mouse_temp = mouse
	var closest = -1
	var distance = 500

	for i in enemies_pos:
		if i != null:
			mouse_temp = (mouse - i).length()
			if mouse_temp < 100:
				if mouse_temp < distance:
					distance = mouse_temp
					closest = enemies_pos.find(i)

	if closest != -1:
		if Input.is_action_pressed("left_click") and mouse_cooldown == 0:
			print(closest)
				#attack teste
				# Futuramente, pegaremos o id dos monstros on click, #
				# e o dos aliados na hora de atacar, possivelmente.  #
				
				# O ultimo argumento sera a casa do vetor em que o   #
				# defender se encontra, pois caso ele morra, temos   #
				# que saber aonde liberar ele. Faremos isso tornando #
				# sua referencia no vetor como NULL, e o garbage     #
				# collector lidará com o resto.                      #
	
			if (process_attack(allies_vector[1], "Enemies", closest)):
				enemies_pos[closest] = null
			mouse_cooldown = 30

	if mouse_cooldown > 0:
		mouse_cooldown -= 1
		
	if time > 0:
		if time == 1:
			get_node(str(actor,"anim_player")).play("idle")
		time -= 1
