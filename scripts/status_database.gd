
extends Node

const NAME = 0
const TYPE = 1
const HP = 2
const EFFECT = 3
const STATUS = 4
const DURATION = 6


var status_database = [
	{ # ID = 0
		NAME : "Atk Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STATUS : "ATK",
		DURATION : 2
	},
	
	{ # ID = 1
		NAME : "Def Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STATUS : "DEF",
		DURATION : 2
	},

	{ # ID = 2
		NAME : "Speed Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STATUS : "SPD",
		DURATION : 2
	},

	{ # ID = 3
		NAME : "Poison",
		TYPE : ["HP"],
		HP : -3,
		EFFECT : "Poison",
		STATUS : null,
		DURATION : 3
	},

	{ # ID = 4
		NAME : "Detox",
		TYPE : ["Dispell"],
		HP : null,
		EFFECT : "Poison",
		STATUS : null,
		DURATION : 0
	},
	{ # ID = 5
		NAME : "Paralize",
		TYPE : ["HP", "Status"],
		HP : -1,
		EFFECT : "Paralysis",
		STATUS : null,
		DURATION : 3
	},
	
	{ # ID = 6
		NAME : "Depar",
		TYPE : ["Dispell"],
		HP : null,
		EFFECT : "Paralysis",
		STATUS : null,
		DURATION : 0
	}
]


var it_map = { }

func _ready():
	for id in range (item_database.size()):
		it_map[item_database[id][ITEM_NAME]] = id

func get_status_id(name):
	return it_map[name]

func get_status_name(id):
	return item_database[id][ITEM_NAME]

func get_status_type(id):
	return item_database[id][TYPE]

func get_status_hp(id):
	return item_database[id][HP]

func get_status_effect(id):
	return item_database[id][EFFECT]

func get_status_status(id):
	return item_database[id][STATUS]

func get_status_duration(id):
	return item_database[id][DURATION]