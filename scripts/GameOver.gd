
extends Node2D


func _ready():
	var window_size = OS.get_window_size()
	var scale = window_size/Vector2(600, 600) # Makes bg screen size
	var pos = (Vector2(600, 600)*scale)/2 # Centralizes bg on screen

	get_node("BackGround").set_scale(scale)
	get_node("BackGround").set_pos(pos)

	get_node("ToMenu").set_pos(window_size/2 - get_node("ToMenu").get_size()/2)


func _on_ToMenu_pressed():
	get_node("/root/global").goto_scene("res://scenes/Main.tscn")
	get_parent().get_parent().first_play = 1;
	get_parent().get_parent().save_game()