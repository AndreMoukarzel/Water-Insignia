
extends Panel

var screen_size
var window_size

func _ready():
	screen_size = OS.get_screen_size()
	window_size = OS.get_window_size()

	size_update()


func size_update():
	OS.set_window_resizable(0)
	set_size(window_size)
	get_node("Base").set_size(window_size)
	get_node("SettingsMenu").set_size(window_size)


func _on_NewGame_pressed():
	get_parent().start_game()


func _on_Continue_pressed():
	get_parent().load_game()


func _on_Settings_pressed():
	get_node("Base").hide()
	get_node("SettingsMenu").show()


func _on_Exit_pressed():
	get_tree().quit()


func _on_WindowSize_item_selected( ID ):
	pass # replace with function body


func _on_Back_pressed():
	get_node("Base").show()
	get_node("SettingsMenu").hide()
