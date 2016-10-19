
extends Node2D

func _ready():
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