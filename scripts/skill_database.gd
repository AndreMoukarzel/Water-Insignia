
extends Node

const SKILL_NAME = 0
const TYPE = 1
const COST = 2
const HP = 3
const STATUS = 4
const ELEM = 5
const MOD = 6
const IS_PHY = 7
const MELEE = 8

var skill_database = [

	{ # ID = 0
		SKILL_NAME : "Heal",
		TYPE : ["HP"],
		COST : 1,
		HP : 10,
		STATUS : [],
		ELEM : null,
		MOD : 1,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 1
		SKILL_NAME : "Blast",
		TYPE : ["HP"],
		COST : 2,
		HP : -70,
		STATUS : [],
		ELEM : null,
		MOD : 0.1,
		IS_PHY : false,
		MELEE : false
	},

	{ # ID = 2
		SKILL_NAME : "Guard",
		TYPE : ["Effect"],
		COST : 3,
		HP : null,
		STATUS : ["Def Up"],
		ELEM : null,
		MOD : 0,
		IS_PHY : false,
		MELEE : false
	},

	{ # ID = 3
		SKILL_NAME : "Agility",
		TYPE : ["Effect"],
		COST : 4,
		HP : null,
		STATUS : ["Spd Up"],
		ELEM : null,
		MOD : 0,
		IS_PHY : false,
		MELEE : false
	},

	{ # ID = 4
		SKILL_NAME : "Cure",
		TYPE : ["HP", "Effect"],
		COST : 5,
		HP : 5,
		STATUS : ["Detox"],
		ELEM : null,
		MOD : 0,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 5
		SKILL_NAME : "Poison Sting",
		TYPE : ["HP", "Effect"],
		COST : 1,
		HP : -1,
		STATUS : ["Poison"],
		ELEM : null,
		MOD : 0.1,
		IS_PHY : false,
		MELEE : true
	},
	
	{ # ID = 6
		SKILL_NAME : "Thunderwave",
		TYPE : ["Effect"],
		COST : 2,
		HP : null,
		STATUS : ["Paralize"],
		ELEM : "Wind",
		MOD : 0,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 7
		SKILL_NAME : "Shadow Strike",
		TYPE : ["HP"],
		COST : 6,
		HP : -15,
		STATUS : [],
		ELEM : null,
		MOD : 0.5,
		IS_PHY : true,
		MELEE : true
	},
	
	{ # ID = 8
		SKILL_NAME : "Eruption",
		TYPE : ["HP"],
		COST : 3,
		HP : -10,
		STATUS : [],
		ELEM : "Fire",
		MOD : 0.25,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 9
		SKILL_NAME : "Aqua Blast",
		TYPE : ["HP"],
		COST : 3,
		HP : -8,
		STATUS : [],
		ELEM : "Water",
		MOD : 0.35,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 10
		SKILL_NAME : "Lightning Bolt",
		TYPE : ["HP"],
		COST : 3,
		HP : -9,
		STATUS : [],
		ELEM : "Wind",
		MOD : 0.3,
		IS_PHY : false,
		MELEE : false
	},
	
	{ # ID = 11
		SKILL_NAME : "Sonic Blow",
		TYPE : ["HP"],
		COST : 2,
		HP : -2,
		STATUS : [],
		ELEM : null,
		MOD : 0.9,
		IS_PHY : true,
		MELEE : true
	},
	
	{ # ID = 12
		SKILL_NAME : "Slash",
		TYPE : ["HP"],
		COST : 1,
		HP : -8,
		STATUS : [],
		ELEM : null,
		MOD : 0.35,
		IS_PHY : true,
		MELEE : true
	},
	
	{ # ID = 13
		SKILL_NAME : "Sword Dance",
		TYPE : ["Effect"],
		COST : 1,
		HP : null,
		STATUS : ["Atk Up"],
		ELEM : null,
		MOD : 0,
		IS_PHY : false,
		MELEE : false
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

func get_skill_modifier(id):
	return skill_database[id][MOD]

func get_is_physical(id):
	return skill_database[id][IS_PHY]

func get_is_melee(id):
	return skill_database[id][MELEE]