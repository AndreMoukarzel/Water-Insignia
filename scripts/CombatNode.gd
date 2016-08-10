
extends Node2D

var window_size

func _ready():
	window_size = OS.get_window_size()

	var bat_scn = preload("res://characters/monsters/bat/bat.xscn")

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
		child.set_pos(Vector2(window_size.x - 200 + 30*temp, temp*500/(num + 1)))
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