
extends Node

const ITEM_NAME = 0
const TYPE = 1
const HP = 2
const EFFECT = 3
const STATUS = 4

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

var item_database = [

	{ # ID = 0
		ITEM_NAME : "Potion",
		TYPE : "HP",
		HP : 10,
		EFFECT : null,
		STATUS : null
	},
	
	{ # ID = 1
		ITEM_NAME : "Bomb",
		TYPE : "HP",
		HP : -70,
		EFFECT : null,
		STATUS : null
	},
	
	{ # ID = 2
		ITEM_NAME : "Atk Up",
		TYPE : "Status",
		HP : null,
		EFFECT : 0.5,
		STATUS : "Attack"
	},
	
	{ # ID = 3
		ITEM_NAME : "Def Up",
		TYPE : "Status",
		HP : null,
		EFFECT : 0.5,
		STATUS : "Defense"
	},

	{ # ID = 4
		ITEM_NAME : "Speed Up",
		TYPE : "Status",
		HP : null,
		EFFECT : 0.5,
		STATUS : "Speed"
	},

	{ # ID = 5
		ITEM_NAME : "Detox",
		TYPE : "Dispell",
		HP : null,
		EFFECT : 1,
		STATUS : "Poison"
	},
	
	{ # ID = 6
		ITEM_NAME : "Poison Bomb",
		TYPE : "HP/Status",
		HP : -2,
		EFFECT : 3,
		STATUS : "Poison"
	},
	
	{ # ID = 7
		ITEM_NAME : "PAR Bomb",
		TYPE : "HP/Status",
		HP : -2,
		EFFECT : 1,
		STATUS : "Paralysis"
	},
	
	{ # ID = 8
		ITEM_NAME : "Depar",
		TYPE : "Dispell",
		HP : null,
		EFFECT : 1,
		STATUS : "Paralysis"
	}
]


var it_map = { }

func _ready():
	for id in range (item_database.size()):
		it_map[item_database[id][ITEM_NAME]] = id

func get_item_id(name):
	return it_map[name]

func get_item_name(id):
	return item_database[id][ITEM_NAME]

func get_item_type(id):
	return item_database[id][TYPE]

func get_item_hp(id):
	return item_database[id][HP]

func get_item_effect(id):
	return item_database[id][EFFECT]

func get_item_status(id):
	return item_database[id][STATUS]