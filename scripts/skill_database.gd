
extends Node

const SKILL_NAME = 0
const TYPE = 1
const COST = 2
const MUL = 3  # Vector is a [a, bx, cx²] vector that defines skill's damage
const STATUS = 4
const ELEM = 5
const IS_PHY = 6
const MELEE = 7
const TARGET = 8

var skill_database = [
	
	# |  | ___   /\   |
	# |--| |--  /--\  |
	# |  | |__ /    \ |___
	
	{ # ID = 0
		# BALANCED
		SKILL_NAME : "Heal",
		TYPE : ["HP"],
		COST : 2,
		MUL : [6, 0, 0.9],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 1
		# BALANCED
		SKILL_NAME : "Heal Wave",
		TYPE : ["HP"],
		COST : 3,
		MUL : [9, 0, 0.75],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},
	
	{ # ID = 2
		SKILL_NAME : "Cure",
		TYPE : ["HP", "Effect"],
		COST : 5,
		MUL : [5, 1, 0],
		STATUS : ["Detox"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	# ___    /\   |\  /|   /\   ___  ___
	# |  \  /--\  | \/ |  /--\  | _  |__
	# |__/ /    \ |    | /    \ |__| |__
	
	{ # ID = 3
		SKILL_NAME : "Focused Blast",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-12, -1.1, -.5],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 4
		# BALANCED
		SKILL_NAME : "Blast",
		TYPE : ["HP"],
		COST : 4,
		MUL : [-10, -1, -.4],
		STATUS : [],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},
	
	{ # ID = 5
		# BALANCED
		SKILL_NAME : "Shadow Strike",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-2, -1.25, -.75],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},
	
	{ # ID = 6
		# BALANCED
		SKILL_NAME : "Eruption",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-10, -.5, -1],
		STATUS : [],
		ELEM : "Fire",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 7
		# BALANCED
		SKILL_NAME : "Volcano",
		TYPE : ["HP"],
		COST : 4,
		MUL : [-8, -.4, -.8],
		STATUS : [],
		ELEM : "Fire",
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},
	
	{ # ID = 8
		# BALANCED
		SKILL_NAME : "Aqua Strike",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-10, -.5, -1],
		STATUS : [],
		ELEM : "Water",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 9
		# BALANCED
		SKILL_NAME : "Aqua Blast",
		TYPE : ["HP"],
		COST : 4,
		MUL : [-8, -.4, -.8],
		STATUS : [],
		ELEM : "Water",
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},

	{ # ID = 10
		# BALANCED
		SKILL_NAME : "Lightning Bolt",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-10, -.5, -1],
		STATUS : [],
		ELEM : "Wind",
		IS_PHY : false,
		MELEE : false,
		TARGET : false
	},
	
	{ # ID = 11
		# BALANCED
		SKILL_NAME : "Thunder Storm",
		TYPE : ["HP"],
		COST : 4,
		MUL : [-8, -.4, -.8],
		STATUS : [],
		ELEM : "Wind",
		IS_PHY : false,
		MELEE : false,
		TARGET : true
	},
	
	{ # ID = 12
		# BALANCED
		SKILL_NAME : "Sonic Blow",
		TYPE : ["HP"],
		COST : 2,
		MUL : [-5, -.5, -1],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},

	{ # ID = 13
		# BALANCED
		SKILL_NAME : "Slash",
		TYPE : ["HP"],
		COST : 1,
		MUL : [-7, -1.05, -.5],
		STATUS : [],
		ELEM : null,
		IS_PHY : true,
		MELEE : true,
		TARGET : false
	},
	
	# ___ ___  /\  ___      ___
	# |__  |  /--\  |  |  | |__
	# __|  | /    \ |  |__| __|
	
		{ # ID = 14
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

	{ # ID = 15
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
	
	{ # ID = 16
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
	
	{ # ID = 17
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
	
	# ___  ___ | | ___ ___  ____
	# |  |  |  |-| |__ |__| |__
	# |__|  |  | | |__ |\   ___|
	
	{ # ID = 18
		SKILL_NAME : "Poison Sting",
		TYPE : ["HP", "Effect"],
		COST : 2,
		MUL : [-3, 0, 0],
		STATUS : ["Poison"],
		ELEM : null,
		IS_PHY : false,
		MELEE : true,
		TARGET : false
	},
	
	{ # ID = 19
		SKILL_NAME : "Toxic Blast",
		TYPE : ["Effect"],
		COST : 4,
		MUL : [-2, 0, 0],
		STATUS : ["Poison"],
		ELEM : null,
		IS_PHY : false,
		MELEE : false,
		TARGET : true
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
