
extends Node

const ITEM_NAME = 0
const TYPE = 1
const HP = 2
const STATUS = 3
const STACK = 4
const PRICE = 5


var item_database = [

	{ # ID = 0
		ITEM_NAME : "Small Potion",
		TYPE : ["HP"],
		HP : 10,
		STATUS : [],
		STACK : 10,
		PRICE : 10
	},
	
	{
		ITEM_NAME : "Potion",
		TYPE : ["HP"],
		HP : 15,
		STATUS : [],
		STACK : 5,
		PRICE : 15
	},
	
	{ # ID = 1
		ITEM_NAME : "Bomb",
		TYPE : ["HP"],
		HP : -15,
		STATUS : [],
		STACK : 5,
		PRICE : 100
	},
	
	{ # ID = 1.5
		ITEM_NAME : "Big Bomb",
		TYPE : ["HP"],
		HP : -25,
		STATUS : [],
		STACK : 3,
		PRICE : 120
	},
	
	{ # ID = 2
		ITEM_NAME : "Enrager",
		TYPE : ["Effect"],
		HP : null,
		STATUS : ["Atk Up"],
		STACK : 5,
		PRICE : 75
	},

	{ # ID = 3
		ITEM_NAME : "Hardener",
		TYPE : ["Effect"],
		HP : null,
		STATUS : ["Def Up"],
		STACK : 5,
		PRICE : 75
	},

	{ # ID = 4
		ITEM_NAME : "Swiftful",
		TYPE : ["Effect"],
		HP : null,
		STATUS : ["Spd Up"],
		STACK : 5,
		PRICE : 75
	},

	{ # ID = 5
		ITEM_NAME : "Detox",
		TYPE : ["Effect"],
		HP : null,
		STATUS : ["Detox"],
		STACK : 10,
		PRICE : 65
	},

	{ # ID = 6
		ITEM_NAME : "Poison Bomb",
		TYPE : ["HP", "Effect"],
		HP : -2,
		STATUS : ["Poison"],
		STACK : 2,
		PRICE : 100
	},

	{ # ID = 7
		ITEM_NAME : "Static Bomb",
		TYPE : ["HP", "Effect"],
		HP : -2,
		STATUS : ["Paralize"],
		STACK : 2,
		PRICE : 100
	},

	{ # ID = 8
		ITEM_NAME : "Depar",
		TYPE : ["Effect"],
		HP : null,
		STATUS : ["Depar"],
		STACK : 1,
		PRICE : 100
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

func get_item_status(id):
	return item_database[id][STATUS]

func get_item_stack(id):
	return item_database[id][STACK]

func get_price(id):
	return item_database[id][PRICE]