
extends Node

const SKILL_NAME = 0
const TYPE = 1
const COST = 2
const HP = 3
const STATUS = 4
const ELEM = 5

var skill_database = [

	{ # ID = 0
		SKILL_NAME : "Heal",
		TYPE : ["HP"],
		COST : 1,
		HP : 10,
		STATUS : [],
		ELEM : null
	},
	
	{ # ID = 1
		SKILL_NAME : "Blast",
		TYPE : ["HP"],
		COST : 2,
		HP : -70,
		STATUS : [],
		ELEM : null
	},

	{ # ID = 2
		SKILL_NAME : "Guard",
		TYPE : ["Effect"],
		COST : 3,
		HP : null,
		STATUS : ["Def Up"],
		ELEM : null
	},

	{ # ID = 3
		SKILL_NAME : "Agility",
		TYPE : ["Effect"],
		COST : 4,
		HP : null,
		STATUS : ["Spd Up"],
		ELEM : null
	},

	{ # ID = 4
		SKILL_NAME : "Cure",
		TYPE : ["HP", "Effect"],
		COST : 5,
		HP : 5,
		STATUS : ["Detox"],
		ELEM : null
	},
	
	{ # ID = 5
		SKILL_NAME : "Poison Sting",
		TYPE : ["HP", "Effect"],
		COST : 6,
		HP : -5,
		STATUS : ["Poison"],
		ELEM : null
	},
	
	{ # ID = 6
		SKILL_NAME : "Thunderwave",
		TYPE : ["Effect"],
		COST : 7,
		HP : null,
		STATUS : ["Paralysis"],
		ELEM : "Wind"
	},
	
	{ # ID = 7
		SKILL_NAME : "Shadow Strike",
		TYPE : ["HP"],
		COST : 6,
		HP : -15,
		STATUS : [],
		ELEM : "Water"
	},
	
	{ # ID = 8
		SKILL_NAME : "Eruption",
		TYPE : ["HP"],
		COST : 3,
		HP : -10,
		STATUS : [],
		ELEM : "Fire"
	}
]


var sk_map = { }

func _ready():
	for id in range (skill_database.size()):
		sk_map[skill_database[id][SKILL_NAME]] = id

func get_skill_id(name):
	return sk_map[name]

func get_skill_name(id):
	return skill_database[id][SKILL_NAME]

func get_skill_type(id):
	return skill_database[id][TYPE]

func get_skill_cost(id):
	return skill_database[id][COST]

func get_skill_hp(id):
	return skill_database[id][HP]

func get_skill_status(id):
	return skill_database[id][STATUS]

func get_skill_element(id):
	return skill_database[id][ELEM]