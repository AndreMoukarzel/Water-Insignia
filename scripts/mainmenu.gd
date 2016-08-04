
extends Panel

var screen_size
var window_size

func _ready():
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()

	OS.set_window_resizable(0)
	set_size(window_size)
	get_node("Base").set_size(window_size)
	get_node("SettingsMenu").set_size(window_size)


func _on_NewGame_pressed():
	get_node("/root/global").goto_scene("res://scenes/Main.xscn")


func _on_Continue_pressed():
	pass # replace with function body


func _on_Settings_pressed():
	pass # replace with function body


func _on_Exit_pressed():
	get_tree().quit()