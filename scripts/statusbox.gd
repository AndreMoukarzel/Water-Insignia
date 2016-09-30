
extends Node

onready var char_database = get_node("/root/character_database")

var xs
var ys
var xp
var yp

func _ready():
	pass

func adjust_size(type, x_size, y_size, x_pos, y_pos):
	xs = x_size
	ys = y_size
	xp = x_pos
	yp = y_pos

	if (type == "Unit Status"):
		set_size(Vector2(x_size, y_size))
		set_pos(Vector2(x_pos, y_pos))
		get_node("Name").set_pos(Vector2(20, 20))
		get_node("Class").set_pos(Vector2(20, 40))
		get_node("Attack").set_pos(Vector2(20, 60))
		get_node("Defense").set_pos(Vector2(20, 80))


func neutralize_node(type):
	for child in get_children():
		if (child.get_name() == "Icon"):
			child.set_name("old")
			child.queue_free()
	if (type == "Unit Status"):
		get_node("Name").set_text("")
		get_node("Class").set_text("")
		get_node("Attack").set_text("")
		get_node("Defense").set_text("")

func instance_animation(id):
	
	# Initialize visuals #
	var anim_sprite = AnimatedSprite.new()
	var anim_player = AnimationPlayer.new()
	
	# Get folder and animation names for the character #
	var char_folder = char_database.get_char_folder(id)
	var anim_names = char_database.get_animation_array(id)
	
	# Add animations to the player, play the idle animation #
	for i in range(anim_names.size()):
		anim_player.add_animation(anim_names[i], load(str(char_folder, anim_names[i], ".xml")))
	anim_player.play("idle")
	
	# Adjust sprite details
	anim_sprite.set_sprite_frames(load(str(char_folder, char_database.get_char_name(id), ".tres")))

	anim_player.set_name("anim_player")
	anim_sprite.add_child(anim_player)
	anim_sprite.set_name("Icon")
	anim_sprite.set_scale(Vector2(-2.5, 2.5))
	anim_sprite.set_pos(Vector2(get_size().x - 55, 70))
	add_child(anim_sprite)