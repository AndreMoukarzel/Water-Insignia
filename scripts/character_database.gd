	
extends Node

const FOLDER = 0
const CHAR_NAME = 1
const ANIM_ARRAY = 2
const HP = 3
const MP = 4
const ATK = 5
const DEF = 6
const SPD = 7
const WPN_VECTOR = 8
const SKILL_VECTOR = 9
const ITEM_VECTOR = 10


var char_database = [
	{ # ID = 0
		FOLDER : "res://characters/monsters/bat/",
		CHAR_NAME : "bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP : [10, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], #20 leveis no maximo
		MP : [7, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [5, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF : [1, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPD : [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		ITEM_VECTOR : []
	},
	{ # ID = 1
		FOLDER : "res://characters/samurai/",
		CHAR_NAME : "samurai",
		ANIM_ARRAY : ["idle", "attack"],
		HP : [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], #20 leveis no maximo
		MP : [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF : [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPD : [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Bamboo Sword"],
		ITEM_VECTOR : []
	}
]


var cd_map = { }

func _ready():
	for id in range (char_database.size()):
		cd_map[char_database[id][CHAR_NAME]] = id

func get_char_id(name):
	return cd_map[name]

func get_char_folder(id):
	return char_database[id][FOLDER]

func get_char_name(id):
	return char_database[id][CHAR_NAME]

func get_animation_array(id):
	return char_database[id][ANIM_ARRAY]

func get_hp(id, level):
	var hp = 0
	var i = 0

	while(i < level):
		hp += char_database[id][HP][i + 1]
		i += 1
	return hp

func get_mp(id, level):
	var mp = 0
	var i = 0

	while(i < level):
		mp += char_database[id][MP][i + 1]
		i += 1
	return mp

func get_attack(id, level):
	var atk = 0
	var i = 0

	while(i < level):
		atk += char_database[id][ATK][i + 1]
		i += 1
	return atk
	
func get_defense(id, level):
	var def = 0
	var i = 0

	while(i < level):
		def += char_database[id][DEF][i + 1]
		i += 1
	return def

func get_speed(id, level):
	var spd = 0
	var i = 0

	while(i < level):
		spd += char_database[id][SPD][i + 1]
		i += 1
	return spd