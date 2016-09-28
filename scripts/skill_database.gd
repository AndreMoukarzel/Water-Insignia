
extends Node

const SKILL_NAME = 0
const TYPE = 1
const EFFECT = 2
const STATUS = 3
const COST = 4

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
		SKILL_NAME : "Guard",
		TYPE : "Status",
		EFFECT : 0.5,
		STATUS : "Defense",
		COST : 3
	},

	{ # ID = 3
		SKILL_NAME : "Agility",
		TYPE : "Status",
		EFFECT : 0.5,
		STATUS : "Speed",
		COST : 4
	},

	{ # ID = 4
		SKILL_NAME : "Cure",
		TYPE : "Dispell",
		EFFECT : 1,
		STATUS : "Poison",
		COST : 5
	},
	
	{ # ID = 5
		SKILL_NAME : "Poison Sting",
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
	},
	
	{ # ID = 7
		SKILL_NAME : "Shadow Strike",
		TYPE : "HP",
		EFFECT : -15,
		STATUS : null,
		COST : 50
	},
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

func get_skill_effect(id):
	return skill_database[id][EFFECT]

func get_skill_status(id):
	return skill_database[id][STATUS]

func get_skill_cost(id):
	return skill_database[id][COST]