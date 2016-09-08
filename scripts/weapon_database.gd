	
extends Node

const WPN_NAME = 0
const TYPE = 1
const ATK = 2
const DURABILITY = 3

# Fazer um vetor com as animações. As animações serão:       #
# Idle, Attack, Critical (para allies) e Death (o monstro    #
# fica branco, e depois gradualmente some. Talvez Defend.    #
# A ideia disso é não precisarmos mais de uma scene para     #
# cada unit, assim chamando tudo pela database.              #


var wpn_database = [
	# ############################### #
	# ############ SWORDS ########### # 
	# ############################### #
	
	{ # ID = 0
		WPN_NAME : "Katana",
		TYPE : "Sword",
		ATK : 10,
		DURABILITY : 45
	},
	
	{ # ID = 1
		WPN_NAME : "Bamboo Sword",
		TYPE : "Sword",
		ATK : 1,
		DURABILITY : 2
	},
	
	# ############################### #
	# ####### NATURAL WEAPONS ####### # 
	# ############################### #
	{ # ID = 2
		WPN_NAME : "Bat Fangs",
		TYPE : "Natural",
		ATK : 2,
		DURABILITY : -1 #infinite
	},
	
	{ # ID = 3
		WPN_NAME : "Bat Wings",
		TYPE : "Natural",
		ATK : 3,
		DURABILITY : -1 #infinite
	}
]


var wd_map = { }

func _ready():
	for id in range (wpn_database.size()):
		wd_map[wpn_database[id][WPN_NAME]] = id

func get_wpn_id(name):
	return wd_map[name]

func get_wpn_name(id):
	return wpn_database[id][WPN_NAME]

func get_wpn_type(id):
	return wpn_database[id][TYPE]

func get_attack(id):
	return wpn_database[id][ATK]
	
func get_durability(id):
	return wpn_database[id][DURABILITY]