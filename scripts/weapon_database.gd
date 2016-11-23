	
extends Node

const WPN_NAME = 0
const TYPE = 1
const ATK = 2
const DURABILITY = 3
const LOCK = 4
const PRICE = 5

var wpn_database = [
# ############################### #
# ############ WEAPONS ########## # 
# ############################### #
	{ # ID = 0
		WPN_NAME : "Bamboo Sword",
		TYPE : "Sword",
		ATK : 1,
		DURABILITY : 1,
		LOCK : 0,
		PRICE : 20
	},
	
	{ # ID = 1
		WPN_NAME : "Wooden Axe",
		TYPE : "Axe",
		ATK : 1,
		DURABILITY : 1,
		LOCK : 0,
		PRICE : 20
	},
	
	{ # ID = 2
		WPN_NAME : "Long Stick",
		TYPE : "Spear",
		ATK : 1,
		DURABILITY : 1,
		LOCK : 0,
		PRICE : 20
	},
	
	{ # ID = 3
		WPN_NAME : "Katana",
		TYPE : "Sword",
		ATK : 5,
		DURABILITY : 45,
		LOCK : 0,
		PRICE : 500
	},
	
	{ # ID = 4
		WPN_NAME : "Iron Axe",
		TYPE : "Axe",
		ATK : 5,
		DURABILITY : 20,
		LOCK : 0,
		PRICE : 300
	},
	
	{ # ID = 5
		WPN_NAME : "Iron Spear",
		TYPE : "Spear",
		ATK : 5,
		DURABILITY : 15,
		LOCK : 0,
		PRICE : 250
	},
	
	{ # ID = 6
		WPN_NAME : "Sharp Katana",
		TYPE : "Sword",
		ATK : 7,
		DURABILITY : 50,
		LOCK : 0,
		PRICE : 650
	},
	
	{ # ID = 7
		WPN_NAME : "Broad Axe",
		TYPE : "Axe",
		ATK : 7,
		DURABILITY : 20,
		LOCK : 0,
		PRICE : 600
	},
	
	{ # ID = 8
		WPN_NAME : "Heavy Spear",
		TYPE : "Spear",
		ATK : 7,
		DURABILITY : 15,
		LOCK : 0,
		PRICE : 600
	},
	
	{ # ID = 9
		WPN_NAME : "Greatsword",
		TYPE : "Sword",
		ATK : 8,
		DURABILITY : 25,
		LOCK : 0,
		PRICE : 650
	},
	
	{ # ID = 10
		WPN_NAME : "Bloody Axe",
		TYPE : "Axe",
		ATK : 8,
		DURABILITY : 20,
		LOCK : 0,
		PRICE : 650
	},
	
	{ # ID = 11
		WPN_NAME : "Deadly Spear",
		TYPE : "Spear",
		ATK : 8,
		DURABILITY : 20,
		LOCK : 0,
		PRICE : 650
	},
	
	{ # ID = 12
		WPN_NAME : "Rapier",
		TYPE : "Sword",
		ATK : 9,
		DURABILITY : 25,
		LOCK : 0,
		PRICE : 700
	},
	
	{ # ID = 13
		WPN_NAME : "Sturdy Axe",
		TYPE : "Axe",
		ATK : 9,
		DURABILITY : 35,
		LOCK : 0,
		PRICE : 700
	},
	
	{ # ID = 14
		WPN_NAME : "Long Spear",
		TYPE : "Spear",
		ATK : 9,
		DURABILITY : 20,
		LOCK : 0,
		PRICE : 700
	},
	
	# ############################### #
	# ####### NATURAL WEAPONS ####### # 
	# ############################### #
	
	{ 
		WPN_NAME : "Bat Fangs",
		TYPE : "Natural",
		ATK : 3,
		DURABILITY : -1, #infinite
		LOCK : 1,
		PRICE : 0
		
	},
	
	{
		WPN_NAME : "Bat Wings",
		TYPE : "Natural",
		ATK : 4,
		DURABILITY : -1, #infinite
		LOCK : 1,
		PRICE : 0
	},
	
	{
		WPN_NAME : "Fangs",
		TYPE : "Natural",
		ATK : 5,
		DURABILITY : -1, # infinite
		LOCK : 1,
		PRICE : 0
	},
	
	{
		WPN_NAME : "Claws",
		TYPE : "Natural",
		ATK : 6,
		DURABILITY : -1, #infinite
		LOCK : 1,
		PRICE : 0
	},
	
	{
		WPN_NAME : "Arcane Hit",
		TYPE : "Natural",
		ATK : 3,
		DURABILITY : -1,
		LOCK : 1,
		PRICE : 0
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

func get_price(id):
	return wpn_database[id][PRICE]