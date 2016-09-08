
extends Node

const ITEM_NAME = 0
const TYPE = 1
const HP = 2
const BD = 3
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
		BD : null,
		STATUS : null
	},
	
	{ # ID = 1
		ITEM_NAME : "Bomb",
		TYPE : "HP",
		HP : -7,
		BD : null,
		STATUS : null
	},

	{ # ID = 2
		ITEM_NAME : "Def up",
		TYPE : "BD",
		HP : null,
		BD : "Defense",
		STATUS : null
	},

	{ # ID = 3
		ITEM_NAME : "Speed up",
		TYPE : "BD",
		HP : null,
		BD : "Speed",
		STATUS : null
	},

	{ # ID = 4
		ITEM_NAME : "Detox",
		TYPE : "Status",
		HP : null,
		BD : null,
		STATUS : "Poison"
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

func get_item_bd(id):
	return item_database[id][BD]

func get_item_status(id):
	return item_database[id][STATUS]