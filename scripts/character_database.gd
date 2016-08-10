
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
		FOLDER : "res://characters/monsters/bat",
		CHAR_NAME : "Bat",
		ANIM_ARRAY : ["idle", "attack"],
		HP_MAX : 10,
		ATK : 2,
		DEF : 2
	}
]

# new #
var cd_map = { }

func _ready():
	pass


func get_char_folder(id):
	return char_database[id][FOLDER]

func get_char_name(id):
	return char_database[id][CHAR_NAME]

# WIP #
func get_animation_name(id, anim_num):
	return char_database[id][ANIM_ARRAY][anim_num]