	
extends Node

const ITEM_NAME = 0
const TYPE = 1

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
		TYPE : "HP"
	},
	
	{ # ID = 1
		ITEM_NAME : "Bomb",
		TYPE : "HP"
	},
	
	{ # ID = 2
		ITEM_NAME : "Poison pot",
		TYPE : "BD"
	},
	
	{ # ID = 3
		ITEM_NAME : "Adrenaline",
		TYPE : "BD"
	},
	
	{ # ID = 4
		ITEM_NAME : "Detox",
		TYPE : "Status"
	}
	
]


var it_map = { }

func _ready():
	for id in range (item_database.size()):
		it_map[item_database[id][item_NAME]] = id

func get_item_id(name):
	return it_map[name]

func get_item_name(id):
	return item_database[id][ITEM_NAME]

func get_item_type(id):
	return item_database[id][TYPE]