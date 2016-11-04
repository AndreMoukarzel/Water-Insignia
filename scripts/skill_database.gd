
extends Node

const SKILL_NAME = 0
const TYPE = 1
const COST = 2
const MUL = 3  # Vector is a [a, bx, cx²] vector that defines skill's damage
const STATUS = 4
const ELEM = 5
const IS_PHY = 6
const MELEE = 7


var skill_database = [
	{ # ID = 0
		SKILL_NAME : "Heal",
		TYPE : ["HP"],
		COST : 1,
		MUL : [10, 0, 1.5],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 1
		SKILL_NAME : "Blast",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-70, 0.3, 0],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},

		{ # ID = 2
		SKILL_NAME : "Guard",
		TYPE : ["Effect"],
		COST : 3,
		MUL : null,
		STATUS : ["Def Up"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 3
		SKILL_NAME : "Agility",
		TYPE : ["Effect"],
		COST : 4,
		MUL : null,
		STATUS : ["Spd Up"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 4
		SKILL_NAME : "Cure",
		TYPE : ["HP", "Effect"],
		COST : 5,
		MUL : [5, 3, 0],
		STATUS : ["Detox"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 5
		SKILL_NAME : "Poison Sting",
		TYPE : ["HP", "Effect"],
		COST : 1,
		MUL : [-1, 0, 0],
		STATUS : ["Poison"],
		ELEM : null,
		IS_PHY : false,
		MELEE : true,
		TARGET : false
	},

	{ # ID = 6
		SKILL_NAME : "Thunderwave",
		TYPE : ["Effect"],
		COST : 2,
		MUL : null,
		STATUS : ["Paralize"],
		ELEM : "Wind",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 7
		SKILL_NAME : "Shadow Strike",
		TYPE : ["HP"],
		COST : 6,
		MUL : [-15, -0.2, 0],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},

	{ # ID = 8
		SKILL_NAME : "Eruption",
		TYPE : ["HP"],
		COST : 3,
		MUL : [-10, -0.75, -1.2],
		STATUS : [],
		ELEM : "Fire",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 9
		SKILL_NAME : "Aqua Blast",
		TYPE : ["HP"],
		COST : 3,
		MUL : [-8, -1, -1],
		STATUS : [],
		ELEM : "Water",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 10
		SKILL_NAME : "Lightning Bolt",
		TYPE : ["HP"],
		COST : 3,
		MUL : [-9, -0.5, 0],
		STATUS : [],
		ELEM : "Wind",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},

	{ # ID = 11
		SKILL_NAME : "Sonic Blow",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-2, 0, -2],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},

	{ # ID = 12
		SKILL_NAME : "Slash",
		TYPE : ["HP"],
		COST : 1,
		MUL : [-8, -1, 0],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},

	{ # ID = 13
		SKILL_NAME : "Sword Dance",
		TYPE : ["Effect"],
		COST : 1,
		MUL : null,
		STATUS : ["Atk Up"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 14
		SKILL_NAME : "Toxic Blast",
		TYPE : ["Effect"],
		COST : 1,
		HP : null,
		STATUS : ["Poison"],
		ELEM : null,
		MOD : 0,
		IS_PHY : false,
		MELEE : false,
		TARGET : true
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

func get_skill_multiplayer(id):
	return skill_database[id][MUL]

func get_skill_status(id):
	return skill_database[id][STATUS]

func get_skill_element(id):
	return skill_database[id][ELEM]

func get_is_physical(id):
	return skill_database[id][IS_PHY]

func get_is_melee(id):
	return skill_database[id][MELEE]

func get_multi_target(id):
	return skill_database[id][TARGET]
