
extends Node2D

const scale = 5

var char_database
var window_size

func _ready():
	
	# Acess character database (is a global script) #
	char_database = get_node("/root/character_database")
	
	# Get window size #
	window_size = OS.get_window_size()


	# TESTING INSTANCING #
	instance_unit(0, "Allies")
	instance_unit(0, "Allies")
	instance_unit(0, "Enemies")
	instance_unit(0, "Enemies")
	instance_unit(0, "Enemies")
	# TESTING INSTANCING END #

	reposition_units()
	
	resize_menu()


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

	anim_sprite.add_child(anim_player)
	get_node(path).add_child(anim_sprite)

func reposition_units():
	# This function might be altered later, so #
	# enemy units will appear in different     #
	# patterns, depending on their numbers.    #
	
	var num = 0
	var temp = 1

	num = get_node("Allies").get_child_count()

	for child in get_node("Allies").get_children():
		child.set_pos(Vector2(200 - 30*temp, temp*500/(num + 1)))
		temp += 1 

	num = get_node("Enemies").get_child_count()
	temp = 1

	for child in get_node("Enemies").get_children():
		child.set_pos(Vector2(window_size.x - 300 + 50*temp, temp*500/(num + 1)))
		child.set_scale(Vector2(-scale, scale))
		temp += 1 

func resize_menu():
	get_node("ActionMenu").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Selection").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Attack").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Skill").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Item").set_size(Vector2(window_size.x, window_size.y - 500))
	get_node("ActionMenu/Return").set_pos(Vector2(window_size.x - 50, -50))


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


func _on_Skill_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Skill").show()


func _on_Item_pressed():
	get_node("ActionMenu/Selection").hide()
	get_node("ActionMenu/Return").show()
	get_node("ActionMenu/Item").show()