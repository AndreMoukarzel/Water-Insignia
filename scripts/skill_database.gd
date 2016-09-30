
extends Node

const SKILL_NAME = 0
const TYPE = 1
const HP = 2
const EFFECT = 3
const STATUS = 4
const COST = 5

var skill_database = [

	{ # ID = 0
		SKILL_NAME : "Heal",
		TYPE : "HP",
		HP : 10,
		EFFECT : null,
		STATUS : null,
		COST : 1
	},
	
	{ # ID = 1
		SKILL_NAME : "Blast",
		TYPE : "HP",
		HP : -70,
		EFFECT : null,
		STATUS : null,
		COST : 2
	},

	{ # ID = 2
		SKILL_NAME : "Guard",
		TYPE : "Status",
		HP : null,
		EFFECT : 0.5,
		STATUS : "Defense",
		COST : 3
	},

	{ # ID = 3
		SKILL_NAME : "Agility",
		TYPE : "Status",
		HP : null,
		EFFECT : 0.5,
		STATUS : "Speed",
		COST : 4
	},

	{ # ID = 4
		SKILL_NAME : "Cure",
		TYPE : "Dispell",
		HP : 5,
		EFFECT : null,
		STATUS : "Poison",
		COST : 5
	},
	
	{ # ID = 5
		SKILL_NAME : "Poison Sting",
		TYPE : "HP/Status",
		HP : -5,
		EFFECT : 2,
		STATUS : "Poison",
		COST : 6
	},
	
	{ # ID = 6
		SKILL_NAME : "Thunderwave",
		TYPE : "Status",
		HP : null,
		EFFECT : null,
		STATUS : "Paralysis",
		COST : 7
	},
	
	{ # ID = 7
		SKILL_NAME : "Shadow Strike",
		TYPE : "HP",
		HP : -15,
		EFFECT : null,
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

func get_skill_hp(id):
	return skill_database[id][HP]

func get_skill_effect(id):
	return skill_database[id][EFFECT]

func get_skill_status(id):
	return skill_database[id][STATUS]

func get_skill_cost(id):
	return skill_database[id][COST]