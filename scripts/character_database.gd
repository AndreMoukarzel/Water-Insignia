# The sum of ATK, DEF, SPATK, SPDEF, DEX and LUK in lv. 20 is 420 blaze it no scope 360

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
const DEX = 10
const LUK = 11
const WPN_VECTOR = 12
const SKILL_VECTOR = 13


var char_database = [
	{ # ID = 0
		FOLDER : "res://characters/bat/",
		CHAR_NAME : "bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP :    [10, 16, 23, 27, 30, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP :    [7,  9,  13, 16, 18, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [5,  8,  13, 15, 1,  2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [0,  3,  6,  9,  1,  1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		DEF :   [1,  3,  6,  10, 1,  2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [0,  2,  5,  8,  0,  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		SPD :   [7,  11, 14, 16, 1,  2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEX :   [7,  11, 14, 16, 1,  2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [1,  4,  5,  10, 2,  2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		SKILL_VECTOR : ["Shadow Strike"]
	},
	{ # ID = 1
		FOLDER : "res://characters/samurai/",
		CHAR_NAME : "samurai",
		ANIM_ARRAY : ["idle", "idleSword", "attackSword"],
		HP :    [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 60], # Max lv.: 20
		MP :    [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF :   [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1, 2, 2, 2, 1, 3, 1, 1, 2, 1, 1, 1, 4, 1, 1, 3, 1, 1, 1, 5],
		SPD :   [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		DEX :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Sword", "Sword"],
		SKILL_VECTOR : ["Heal", "Sonic Blow"]
	},
	{ # ID = 2
		FOLDER : "res://characters/soldier/",
		CHAR_NAME : "soldier",
		ANIM_ARRAY : ["idle", "idleSword", "idleAxe", "attackSword", "attackAxe", "skillmagic"],
		HP :    [15, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP :    [5, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [8, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF :   [3, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPD :   [11, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		DEX :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Axe"],
		SKILL_VECTOR : ["Slash", "Aqua Blast", "Lightning Bolt", "Heal"]
	},
	{ # ID = 3
		FOLDER : "res://characters/baby_dragon/",
		CHAR_NAME : "baby_dragon",
		ANIM_ARRAY : ["idle", "attack", "skillmagic"],
		HP :    [25, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 60], # Max lv.: 20
		MP :    [10, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [13, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEF :   [7, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [5, 2, 2, 2, 2, 3, 3, 3, 3, 3, 1, 1, 1, 2, 1, 1, 2, 1, 1, 5],
		SPD :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [5, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		DEX :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [15, 2, 2, 2, 1, 2, 0, 1, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		SKILL_VECTOR : ["Blast", "Thunderwave", "Toxic Blast", "Sword Dance"]
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
	return char_database[id][HP][level - 1]

func get_mp(id, level):
	return char_database[id][MP][level - 1]

func get_attack(id, level):
	return char_database[id][ATK][level - 1]
	
func get_defense(id, level):
	return char_database[id][DEF][level - 1]

func get_sp_attack(id, level):
	return char_database[id][SPATK][level - 1]

func get_sp_defense(id, level):
	return char_database[id][SPDEF][level - 1]

func get_speed(id, level):
	return char_database[id][SPD][level - 1]

func get_dexterity(id, level):
	return char_database[id][DEX][level - 1]

func get_luck(id, level):
	return char_database[id][LUK][level - 1]

func get_weapon_vector(id):
	return char_database[id][WPN_VECTOR]

func get_skill_vector(id):
	return char_database[id][SKILL_VECTOR]
