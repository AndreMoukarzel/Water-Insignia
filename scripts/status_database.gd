
extends Node

const NAME = 0
const TYPE = 1
const HP = 2
const EFFECT = 3
const STAT = 4
const DURATION = 6

# (1) Status with type "HP" affect the afflicted target by the 
#     amount specified in HP every turn of the duration

# (2) Status with type "Buff" affect the specified STATUS of 
#     the target, multiplying it by EFFECT on the first turn,
#     lasting until the end of DURATION

# (3) Status with type "Dispell" remove any buff mentioned in EFFECT

var status_database = [
	{ # ID = 0
		NAME : "DEFEND",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 3,
		STAT : "DEF",
		DURATION : 1
	},
	
	{ # ID = 1
		NAME : "ATTACK",
		TYPE : ["Dispell"],
		HP : null,
		EFFECT : ["DEFEND"],
		STAT : null,
		DURATION : 0
	},
	
	{ # ID = 2
		NAME : "Atk Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STAT : "ATK",
		DURATION : 3
	},
	
	{ # ID = 3
		NAME : "Def Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STAT : "DEF",
		DURATION : 3
	},

	{ # ID = 4
		NAME : "Spd Up",
		TYPE : ["Buff"],
		HP : null,
		EFFECT : 1.5,
		STAT : "SPD",
		DURATION : 3
	},

	{ # ID = 5
		NAME : "Poison",
		TYPE : ["HP"],
		HP : -3,
		EFFECT : null,
		STAT : null,
		DURATION : 4
	},

	{ # ID = 6
		NAME : "Detox",
		TYPE : ["Dispell"],
		HP : null,
		EFFECT : ["Poison"],
		STAT : null,
		DURATION : 0
	},
	{ # ID = 7
		NAME : "Paralize",
		TYPE : ["HP", "Buff"],
		HP : -1,
		EFFECT : 0,
		STAT : "SPD",
		DURATION : 4
	},
	
	{ # ID = 8
		NAME : "Depar",
		TYPE : ["Dispell"],
		HP : null,
		EFFECT : ["Paralize"],
		STAT : null,
		DURATION : 0
	}
]


var st_map = { }

func _ready():
	for id in range (status_database.size()):
		st_map[status_database[id][NAME]] = id

func get_status_id(name):
	return st_map[name]

func get_status_name(id):
	return status_database[id][NAME]

func get_status_type(id):
	return status_database[id][TYPE]

func get_status_hp(id):
	return status_database[id][HP]

func get_status_effect(id):
	return status_database[id][EFFECT]

func get_status_stat(id):
	return status_database[id][STAT]

func get_status_duration(id):
	return status_database[id][DURATION]