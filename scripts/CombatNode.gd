
extends Node2D

var window_size

func _ready():
	window_size = OS.get_window_size()

	resize_menu()


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