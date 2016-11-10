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
		# LV:    1   2   3   4   5   6   7   8  9  10 11 12 13 14 15 16 17 18 19 20
		HP :    [7,  9,  12, 16, 22, 25, 27, 29, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP :    [7,  9,  11, 12, 15, 17, 19, 20, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [9,  10, 11, 11, 14, 15, 17, 17, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [0,  1,  2,  4,  4,  6,  8,  10, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		DEF :   [2,  3,  4,  4,  7,  9,  9, 10, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [0,  1,  2,  5,  5,  6,  8,  10, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
		SPD :   [9,  11, 14, 16, 19, 21, 22, 24, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEX :   [8,  10, 12, 14, 17, 18, 20, 22, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [3,  4,  6,  7,  10, 11, 12, 13, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		SKILL_VECTOR : ["Shadow Strike"]
	},
	{ # ID = 1
		FOLDER : "res://characters/samurai/",
		CHAR_NAME : "samurai",
		ANIM_ARRAY : ["idle", "idleSword", "attackSword"],
		# LV:    1   2   3   4   5   6   7   8   9  10 11 12 13 14 15 16 17 18 19 20
		HP :    [15, 18, 21, 23, 28, 30, 32, 33, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 60], # Max lv.: 20
		MP :    [7,  10, 13, 15, 20, 21, 22, 22, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [6,  9,  11, 13, 17, 19, 21, 23, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1,  2,  5,  6,  8,  10, 11, 13, 2, 1, 1, 1, 4, 1, 1, 3, 1, 1, 1, 5],
		DEF :   [2,  4,  5,  7,  9,  10, 12, 13, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [1,  2,  5,  7,  8,  10, 11, 12, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPD :   [9,  11, 12, 13, 16, 18, 20, 23, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEX :   [10, 12, 13, 14, 17, 19, 22, 23, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [1,  2,  3,  5,  7,  9,  10, 12, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Sword", "Sword"],
		SKILL_VECTOR : ["Heal", "Sonic Blow", "Poison Sting"]
	},
	{ # ID = 2
		FOLDER : "res://characters/soldier/",
		CHAR_NAME : "soldier",
		ANIM_ARRAY : ["idle", "idleSword", "idleAxe", "attackSword", "attackAxe", "skillmagic"],
		# LV:    1   2   3   4   5   6   7   8  9  10 11 12 13 14 15 16 17 18 19 20
		HP :    [20, 24, 28, 30, 35, 38, 41, 44, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], # Max lv.: 20
		MP :    [10, 13, 14, 16, 20, 22, 24, 25, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [7,  9,  10, 11, 13, 14, 15, 17, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [3,  6,  10, 12, 15, 17, 19, 21, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		DEF :   [5,  8,  11, 13, 16, 19, 22, 24, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [5,  7,  9,  11, 14, 16, 18, 20, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
		SPD :   [5,  6,  7,  9,  12, 13, 14, 14, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEX :   [5,  5,  6,  8,  10, 11, 12, 14, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [1,  2,  2,  3,  4,  6,  8,  10, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Katana", "Sword", "Axe"],
		SKILL_VECTOR : ["Slash", "Heal Wave", "Lightning Bolt", "Heal"]
	},
	{ # ID = 3
		FOLDER : "res://characters/baby_dragon/",
		CHAR_NAME : "baby_dragon",
		ANIM_ARRAY : ["idle", "attack", "skillmagic"],
		# LV:    1   2   3   4   5   6   7   8  9  10 11 12 13 14 15 16 17 18 19 20
		HP :    [23, 27, 30, 33, 40, 43, 46, 48, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 60], # Max lv.: 20
		MP :    [10, 14, 16, 18, 23, 25, 27, 28, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 15],
		ATK :   [6,  8,  11, 13, 17, 20, 23, 25, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPATK : [1,  3,  6,  8,  11, 13, 16, 20, 3, 3, 1, 1, 1, 2, 1, 1, 2, 1, 1, 5],
		DEF :   [4,  7,  9,  12, 15, 17, 19, 22, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		SPDEF : [1,  4,  5,  6,  9,  12, 13, 16, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2],
		SPD :   [3,  5,  6,  7,  10, 13, 16, 17, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		DEX :   [3,  4,  6,  8,  11, 13, 15, 16, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		LUK :   [1,  2,  4,  5,  8,  8,  9,  10, 2, 6, 1, 1, 1, 1, 1, 1, 1, 1, 1, 15],
		WPN_VECTOR : ["Fangs", "Claws"],
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
