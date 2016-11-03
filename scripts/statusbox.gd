
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

	set_size(Vector2(x_size, y_size))
	set_pos(Vector2(x_pos, y_pos))
	if (type == "Unit Status"):
		get_node("Name").set_pos(Vector2(20, 20))
		get_node("Class").set_pos(Vector2(20, 40))
		get_node("Attack").set_pos(Vector2(20, 60))
		get_node("Defense").set_pos(Vector2(20, 80))
		get_node("Speed").set_pos(Vector2(20, 100))
		
	if (type == "Item Status"):
		# Falta ajustar, e colocar a durabilidade
		get_node("Name").set_pos(Vector2(7, 8))
		get_node("Class").set_pos(Vector2(7, 22))
		# Durability is set at a later time
		get_node("Attack").set_pos(Vector2(7, 45))
		# Defesa não será necessária, acredito. Pode ser que uma arma forneça defesa bônus.
		get_node("Defense").set_pos(Vector2(20, 80))

	if (type == "Repair Status"):
		var icon = TextureFrame.new()
		icon.set_name("Icon")
		add_child(icon)
		get_node("Name").set_pos(Vector2(20, 10))
		get_node("Class").set_pos(Vector2(20, 30))
		get_node("Durability").set_pos(Vector2(20, 60))
		get_node("Attack").set_pos(Vector2(20, 80))
		# Defesa não será necessária, acredito. Pode ser que uma arma forneça defesa bônus.
		get_node("Defense").set_pos(Vector2(20, 100))
		get_node("Icon").set_pos(Vector2(185, 15))
		get_node("Price").set_pos(Vector2(205, 15))
		
	if (type == "Shop Status"):
		# Falta ajustar, e colocar a durabilidade
		get_node("Name").set_pos(Vector2(15, 10))
		get_node("Class").set_pos(Vector2(30, 30))
		# Durability is set at a later time
		get_node("Attack").set_pos(Vector2(20, 65))
		# Defesa não será necessária, acredito. Pode ser que uma arma forneça defesa bônus.
		get_node("Defense").set_pos(Vector2(20, 80))
		get_node("Icon").set_pos(Vector2(185, 15))
		get_node("Price").set_pos(Vector2(205, 15))

# Não serve para Unit Status
func update_statusbox(object, type, nature, database):
	# For item status, and additional argument specifying which box it refers to may be needed (item or weapon, etc)
	if (type == "Item Status"):
		show()
		get_node("Name").set_text(object.name)
		if (nature == "Weapon"):
			get_node("Class").set_text(str("Type: ",database.get_wpn_type(object.id)))
			if (database.get_durability(object.id) > 10):
				get_node("Durability").set_pos(Vector2(65, 65))
			else:
				get_node("Durability").set_pos(Vector2(85, 65))
			if (database.get_durability(object.id) > 0):
				get_node("Durability").set_text(str(object.durability,"/",database.get_durability(object.id)))
			get_node("Attack").set_text(str("ATK: ", database.get_attack(object.id)))
		if (nature == "Item"):
			get_node("Class").set_text(str("Type: ",database.get_item_type(object.id)))
			if (object.amount > 10):
				get_node("Durability").set_pos(Vector2(65, 65))
			else:
				get_node("Durability").set_pos(Vector2(85, 65))
			get_node("Durability").set_text(str(object.amount,"/","3"))
			
	if (type == "Repair Status"):
		get_node("Icon").set_texture(load("res://resources/sprites/gui/management/icons/quesha.tex"))
		get_node("Price").set_text(str((database.get_durability(object.id) - object.durability) * database.get_price(object.id) / 500))
		get_node("Name").set_text(object.name)
		get_node("Class").set_text(str("Type: ",database.get_wpn_type(object.id)))
		get_node("Durability").set_text(str(object.durability,"/",database.get_durability(object.id)))
		# Faltam o ataque, etc, precisamos ajustar o tamanho da font
	
	if (type == "Shop Status"):
		# ###################### ATENÇÃO ####################### #
		# Neste node especificamente, teremos o object ser seu id,
		# pois não temos nada instanciado para os shops.
		# ###################### ATENÇÃO ####################### #
		show()
		if (nature == "Weapon"):
			get_node("Name").set_text(database.get_wpn_name(object))
			get_node("Class").set_text(str("Type: ",database.get_wpn_type(object)))
			if (database.get_durability(object) > 10):
				get_node("Durability").set_pos(Vector2(220, 65))
			else:
				get_node("Durability").set_pos(Vector2(240, 65))
			if (database.get_durability(object) > 0):
				get_node("Durability").set_text(str(database.get_durability(object),"/",database.get_durability(object)))
			get_node("Attack").set_text(str("ATK: ", database.get_attack(object)))
			get_node("Icon").set_texture(load("res://resources/sprites/gui/management/icons/quesha.tex"))
			get_node("Price").set_text(str("Price: ", database.get_price(object)))
		if (nature == "Item"):
			get_node("Name").set_text(database.get_item_name(object))
			get_node("Class").set_text(str("Type: ",database.get_item_type(object)))
			get_node("Icon").set_texture(load("res://resources/sprites/gui/management/icons/quesha.tex"))
			get_node("Price").set_text(str("Price: ", database.get_price(object)))
			# Não podemos fazer isto ainda, não existe amount na database de items
#			if (object.amount > 10):
#				get_node("Durability").set_pos(Vector2(65, 65))
#			else:
#				get_node("Durability").set_pos(Vector2(85, 65))
#			get_node("Durability").set_text(str(object.amount,"/","3"))

func neutralize_node(type):
	# acho que essa parte possívelmente irá ser apenas para Unit Status
	if (type == "Unit Status"):
		for child in get_children():
			if (child.get_name() == "Icon"):
				child.set_name("old")
				child.queue_free()
		get_node("Name").set_text("")
		get_node("Class").set_text("")
		get_node("Attack").set_text("")
		get_node("Defense").set_text("")
		get_node("Speed").set_text("")
	
	if (type == "Item Status"):
		hide()
		get_node("Name").set_text("")
		get_node("Class").set_text("")
		get_node("Durability").set_text("")
		get_node("Attack").set_text("")
		get_node("Defense").set_text("")
	
	if (type == "Repair Status"):
		get_node("Icon").set_texture(null)
		get_node("Name").set_text("")
		get_node("Class").set_text("")
		get_node("Durability").set_text("")
		get_node("Attack").set_text("")
		get_node("Defense").set_text("")
		get_node("Price").set_text("")

	if (type == "Shop Status"):
		hide()
		get_node("Icon").set_texture(null)
		get_node("Name").set_text("")
		get_node("Class").set_text("")
		get_node("Durability").set_text("")
		get_node("Attack").set_text("")
		get_node("Defense").set_text("")

# Exclusive for Unit Management
func instance_animation(id, scale):
	
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
	anim_sprite.set_scale(Vector2(-scale, scale))
	anim_sprite.set_pos(Vector2(get_size().x - 55, 70))
	add_child(anim_sprite)