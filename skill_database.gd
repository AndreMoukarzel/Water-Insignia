
extends Node

const SKILL_NAME = 0
const TYPE = 1
const EFFECT = 2
const STATUS = 3
const COST = 4

###################################
#
# Há 3 tipos diferentes de item: HP, BD e Status
# -HP são itens que afetam a vida, seja curando ou dando dano
#   (potion cura e bomba dá dano por exemplo)
# -BD (Buff/Debuff) são itens relacionados aos atributos
#   do personagem (aumumento/redução do ataque, defesa, ...)
# -Status são itens que influenciam os status do personagem, seja
#   curando ou dando o status (dar/remover poison, burn, ...)
#
###################################

var skill_database = [

	{ # ID = 0
		SKILL_NAME : "Heal",
		TYPE : "HP",
		EFFECT : 10,
		STATUS : null,
		COST : 1
	},
	
	{ # ID = 1
		SKILL_NAME : "Blast",
		TYPE : "HP",
		EFFECT : -70,
		STATUS : null,
		COST : 2
	},

	{ # ID = 2
		SKILL_NAME : "Harden",
		TYPE : "Status",
		EFFECT : 1.5,
		STATUS : "Defense",
		COST : 3
	},

	{ # ID = 3
		SKILL_NAME : "Sanick",
		TYPE : "Status",
		EFFECT : 1.5,
		STATUS : "Speed",
		COST : 4
	},

	{ # ID = 4
		SKILL_NAME : "Detox",
		TYPE : "Dispell",
		EFFECT : 1,
		STATUS : "Poison",
		COST : 5
	},
	
	{ # ID = 5
		SKILL_NAME : "Poisoned strike",
		TYPE : "Status",
		EFFECT : 1,
		STATUS : "Poison",
		COST : 6
	},
	
	{ # ID = 6
		SKILL_NAME : "Thunderwave",
		TYPE : "Status",
		EFFECT : 1,
		STATUS : "Paralysis",
		COST : 7
	}
]


var sk_map = { }

func _ready():
	for id in range (skill_database.size()):
		it_map[skill_database[id][SKILL_NAME]] = id

func get_skill_id(name):
	return skill_map[name]

func get_skill_name(id):
	return skill_database[id][SKILL_NAME]

func get_skill_type(id):
	return skill_database[id][TYPE]

func get_skill_effect(id):
	return skill_database[id][EFFECT]

func get_skill_status(id):
	return skill_database[id][STATUS]

func get_skill_cost(id):
	return skill_database[id][COST]