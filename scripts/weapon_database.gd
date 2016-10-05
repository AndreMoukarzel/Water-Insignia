	
extends Node

const WPN_NAME = 0
const TYPE = 1
const ATK = 2
const DURABILITY = 3
const LOCK = 4

var wpn_database = [
# ############################### #
# ############ SWORDS ########### # 
# ############################### #
	
	{ # ID = 0
		WPN_NAME : "Katana",
		TYPE : "Sword",
		ATK : 10,
		DURABILITY : 45,
		LOCK : 0
	},
	
	{ # ID = 1
		WPN_NAME : "Bamboo Sword",
		TYPE : "Sword",
		ATK : 1,
		DURABILITY : 1,
		LOCK : 0
	},
	
	{ # ID = 2
		WPN_NAME : "Iron Axe",
		TYPE : "Axe",
		ATK : 5,
		DURABILITY : 20,
		LOCK : 0
	},
	
	{ # ID = 3
		WPN_NAME : "Iron Spear",
		TYPE : "Spear",
		ATK : 9,
		DURABILITY : 15,
		LOCK : 0
	},
	
	# ############################### #
	# ####### NATURAL WEAPONS ####### # 
	# ############################### #
	
	{ # ID = 4
		WPN_NAME : "Bat Fangs",
		TYPE : "Natural",
		ATK : 2,
		DURABILITY : -1, #infinite
		LOCK : 1
		
	},
	
	{ # ID = 5
		WPN_NAME : "Bat Wings",
		TYPE : "Natural",
		ATK : 3,
		DURABILITY : -1, #infinite
		LOCK : 1
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

func get_lock(id):
	return wpn_database[id][LOCK]