	
extends Node

const FOLDER = 0
const CHAR_NAME = 1
const ANIM_ARRAY = 2
const HP_MAX = 3
const MP_MAX = 4
# Precisa ter uma variavel para o HP atual?                  #
# O motivo seria por que a vida dos personagens da party não #
#     recupera automaticamente depois do combate             #
const ATK = 5
const DEF = 6
const SPD = 7
# Fazer um vetor com as animações. As animações serão:       #
# Idle, Attack, Critical (para allies) e Death (o monstro    #
# fica branco, e depois gradualmente some. Talvez Defend.    #
# A ideia disso é não precisarmos mais de uma scene para     #
# cada unit, assim chamando tudo pela database.              #
const WPN_VECTOR = 8
const SKILL_VECTOR = 9
const ITEM_VECTOR = 10


var char_database = [
	{ # ID = 0
		FOLDER : "res://characters/monsters/bat/",
		CHAR_NAME : "bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP_MAX : 10,
		HP_GROWTH : [0, 1, 1, 2, 1, 3, 1, 1, 2, 5, 2, 1, 2, 1, 1, 2, 2, 2, 2, 6], #20 leveis no maximo
		MP_MAX : 7,
		MP_GROWTH : [0, 0, 1, 2, 1, 0, 0, 1, 0, 3, 2, 0, 1, 0, 1, 0, 0, 2, 1, 10],
		ATK : 5,
		DEF : 1,
		SPD : 15,
		WPN_VECTOR : ["Bat Fangs", "Bat Wings"],
		ITEM_VECTOR : []
	},
	{ # ID = 1
		FOLDER : "res://characters/samurai/",
		CHAR_NAME : "samurai",
		ANIM_ARRAY : ["idle", "attack"],
		HP_MAX : 15,
		MP_MAX : 5,
		ATK : 8,
		DEF : 3,
		SPD : 11,
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

func get_hp_max(id):
	return char_database[id][HP_MAX]

func get_mp_max(id):
	return char_database[id][MP_MAX]

func get_attack(id):
	return char_database[id][ATK]
	
func get_defense(id):
	return char_database[id][DEF]

func get_speed(id):
	return char_database[id][SPD]