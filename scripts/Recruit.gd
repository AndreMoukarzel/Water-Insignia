
extends Node2D

var recruits = []

class unit:
	var id # Unit ID in the character database
	var level


func _ready():
	organize_positions()

	recruits = get_parent().recruit_vector

	populate()
#   Aciona depois de escolher qual unidade vai tentar capturar
#	var main = get_parent().get_parent()
#	if (main.gd == 0):
#		main.stage += 1
#	main.victory = 1
#	main.set_level("management")


func organize_positions():
	var window_size = OS.get_window_size()
	var scale = window_size/Vector2(600, 600) # Makes bg screen size
	var pos = (Vector2(600, 600)*scale)/2 # Centralizes bg on screen

	get_node("BackGround").set_scale(scale)
	get_node("BackGround").set_pos(pos)

	get_node("HBoxContainer").set_size(window_size)

	get_node("ButtonBox").set_size(window_size)
	get_node("ButtonBox").set_pos(Vector2(0, 50))

	for StatusBox in get_node("HBoxContainer").get_children():
		StatusBox.adjust_size("joelho", 100, 50, 0, 0)


func populate():
	get_node("HBoxContainer/StatusBox1").instance_animation(recruits[0].id, 5)
	get_node("HBoxContainer/StatusBox1").adjust_size("Unit Status", 50, 100, 0, 0)

	get_node("HBoxContainer/StatusBox1").instance_animation(recruits[1].id, 5)
	get_node("HBoxContainer/StatusBox2").adjust_size("Unit Status", 50, 100, 0, 0)

#	get_node("HBoxContainer/StatusBox1").instance_animation(recruits[2].id, 5)
#	get_node("HBoxContainer/StatusBox3").adjust_size("Unit Status", 50, 100, 0, 0)
#
#	get_node("HBoxContainer/StatusBox1").instance_animation(recruits[3].id, 5)
#	get_node("HBoxContainer/StatusBox4").adjust_size("Unit Status", 50, 100, 0, 0)