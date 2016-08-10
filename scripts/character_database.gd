
extends Node

const FOLDER = 0
const CHAR_NAME = 1
const ANIM_ARRAY = 2
const HP_MAX = 3
# Precisa ter uma variavel para o HP atual?                  #
# O motivo seria por que a vida dos personagens da party não #
#     recupera automaticamente depois do combate             #
const ATK = 4
const DEF = 5
# Fazer um vetor com as animações. As animações serão:       #
# Idle, Attack, Critical (para allies) e Death (o monstro    #
# fica branco, e depois gradualmente some. Talvez Defend.    #
# A ideia disso é não precisarmos mais de uma scene para     #
# cada unit, assim chamando tudo pela database.              #


var char_database = [
	{
		FOLDER : "res://characters/monsters/bat/",
		CHAR_NAME : "bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP_MAX : 10,
		ATK : 2,
		DEF : 2
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

# WIP #
func get_animation_name(id, anim_num):
	return char_database[id][ANIM_ARRAY][anim_num]