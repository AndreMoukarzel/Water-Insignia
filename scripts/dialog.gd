
extends Node

var dialog_timer = 0
var dialog_happening = false

onready var dialog_bubble = get_node("DialogBubble")
onready var dialog_text = get_node("DialogText")

var dialog_database = [

#	Stage 0
["You should buy a sword! You never know when an axe-wielding enemy might show up!",
 "It sure is boring around here."],
#	Stage 1
["You should buy a sword! You never know when an axe-wielding enemy might show up!",
"It sure is boring around here.",
"Did you know that allies that depend on natural weapons are not affected by the weapon triangle?",
"How about buying an axe? Those are very good at dealing with enemies with a lance.",
"Lances are sure to give you the range to deal with those sword-wielding enemies!"],
#	Stage 2
["You should buy a sword! You never know when an axe-wielding enemy might show up!",
"It sure is boring around here.",
"Did you know that allies that depend on natural weapons are not affected by the weapon triangle?",
"How about buying an axe? Those are very good at dealing with enemies with a lance.",
"Lances are sure to give you the range to deal with those sword-wielding enemies!"]


]

func _ready():
	set_fixed_process(true)

func _fixed_process(delta):
	dialog_timer += 1
	if (dialog_timer == 360):
		dialog_bubble.hide()
		dialog_text.clear()
		dialog_happening = false
		dialog_timer = 0
		get_parent().get_node("ShopMenu/TalkMenu").set_disabled(false)

func get_random_dialog(stage):
	var random
	randomize()
	random = randi() % dialog_database[stage].size()
	return dialog_database[stage][random]

func generate_dialog(stage):
	if (!dialog_happening):
		dialog_happening = true
		get_parent().get_node("ShopMenu/TalkMenu").set_disabled(true)
		var dialog = get_random_dialog(stage)
		set_fixed_process(false)
		dialog_bubble.show()
		for char in dialog:
			var wait = 3
			dialog_text.add_text(char)
			while (wait != 0):
				wait -= 1
				yield(get_tree(), "fixed_frame")
			if (!dialog_happening):
					break
		set_fixed_process(true)
		
func neutralize_node():
	hide()
	get_node("DialogBubble").hide()
	get_node("DialogText").clear()
	dialog_timer = 0
	dialog_happening = false
	get_parent().get_node("ShopMenu/TalkMenu").set_disabled(false)
	
func neutralize_dialog():
	get_node("DialogBubble").hide()
	get_node("DialogText").clear()
	dialog_timer = 0
	dialog_happening = false
	get_parent().get_node("ShopMenu/TalkMenu").set_disabled(false)
