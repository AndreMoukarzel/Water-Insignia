
extends Node2D

var damage = 0
var color = Color(1, 1, 1)

func _ready():
	get_node("Label").set_text(str(damage))
	get_node("Label").add_color_override("font_color", color)

func free():
	queue_free()