	
extends Node

const FOLDER = 0
const CHAR_NAME = 1
const ANIM_ARRAY = 2
const HP = 3
const MP = 4
const ATK = 5
const DEF = 6
const SPATK = 7
const SPDEF = 8
const SPD = 9
const WPN_VECTOR = 10
const SKILL_VECTOR = 11


var char_database = [
	{ # ID = 0
		FOLDER : "res://characters/bat/",
		CHAR_NAME : "bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP : [10, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP : [7, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [5, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPDEF : [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		DEF : [1, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPD : [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		SKILL_VECTOR : ["Shadow Strike"]
	},
	{ # ID = 1
		FOLDER : "res://characters/samurai/",
		CHAR_NAME : "samurai",
		ANIM_ARRAY : ["idle", "idleSword", "attackSword"],
		HP : [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP : [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF : [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1, 2, 2, 2, 1, 3, 1, 1, 2, 1, 1, 1, 4, 1, 1, 3, 1, 1, 1, 5],
		SPDEF : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPD : [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Sword", "Sword"],
		SKILL_VECTOR : ["Heal", "Sonic Blow"]
	},
	{ # ID = 2
		FOLDER : "res://characters/soldier/",
		CHAR_NAME : "soldier",
		ANIM_ARRAY : ["idle", "idleSword", "idleAxe", "attackSword", "attackAxe", "skillmagic"],
		HP : [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP : [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF : [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPDEF : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPD : [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Axe"],
		SKILL_VECTOR : ["Slash", "Aqua Blast", "Lightning Bolt", "Heal"]
	},
	{ # ID = 3
		FOLDER : "res://characters/baby_dragon/",
		CHAR_NAME : "baby_dragon",
		ANIM_ARRAY : ["idle", "attack", "skillmagic"],
		HP : [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP : [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK : [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF : [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [2, 2, 2, 2, 2, 3, 3, 3, 3, 3, 1, 1, 1, 2, 1, 1, 2, 1, 1, 5],
		SPDEF : [2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		SPD : [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		SKILL_VECTOR : ["Blast", "Eruption", "Aqua Blast", "Lightning Bolt"]
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
		hp += char_database[id][HP][i]
		i += 1
	return hp

func get_mp(id, level):
	var mp = 0
	var i = 0

	while(i < level):
		mp += char_database[id][MP][i]
		i += 1
	return mp

func get_attack(id, level):
	var atk = 0
	var i = 0

	while(i < level):
		atk += char_database[id][ATK][i]
		i += 1
	return atk
	
func get_defense(id, level):
	var def = 0
	var i = 0

	while(i < level):
		def += char_database[id][DEF][i]
		i += 1
	return def

func get_sp_attack(id, level):
	var spatk = 0
	var i = 0
	
	while (i < level):
		spatk += char_database[id][SPATK][i]
		i += 1
	return spatk

func get_sp_defense(id, level):
	var spdef = 0
	var i = 0
	
	while (i < level):
		spdef += char_database[id][SPDEF][i]
		i += 1
	return spdef

func get_speed(id, level):
	var spd = 0
	var i = 0

	while(i < level):
		spd += char_database[id][SPD][i]
		i += 1
	return spd

func get_weapon_vector(id):
	return char_database[id][WPN_VECTOR]

func get_skill_vector(id):
	return char_database[id][SKILL_VECTOR]
