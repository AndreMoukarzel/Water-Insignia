
extends Node2D

var char_database = preload("character_database.gd")
var window_size

func _ready():
	window_size = OS.get_window_size()

	var bat_scn = preload("res://characters/monsters/bat/bat.xscn")

 # TESTING CREATING CHAR FROM SCRIPT #
	var anim_sprite = AnimatedSprite.new()
	var anim_player = AnimationPlayer.new()
	
	anim_player.add_animation("idle",load("res://characters/monsters/bat/idle.xml"))
	anim_player.play("idle")
	anim_sprite.set_pos(Vector2(200, 200))
	anim_sprite.set_sprite_frames(load("res://characters/monsters/bat/bat.tres"))
	anim_sprite.add_child(anim_player)
	anim_sprite.set_scale(Vector2(5,5))
	add_child(anim_sprite)

########################################
	# TESTING INSTANCING #
	var bat = bat_scn.instance()
	get_node("Allies").add_child(bat)
	var bat = bat_scn.instance()
	get_node("Enemies").add_child(bat)
	var bat = bat_scn.instance()
	get_node("Enemies").add_child(bat)
	########################

	reposition_units()
	resize_menu()



func instance_unit(id):
	var anim_sprite = AnimatedSprite.new()
	var anim_player = AnimationPlayer.new()

#	anim_player.add_animation(char_database.char_database[0]

# Transferir as funções de extração de dados, para ficar mais #
# claro para nós, ao fazer os scripts, o que estamos fazendo. #

func reposition_units():
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