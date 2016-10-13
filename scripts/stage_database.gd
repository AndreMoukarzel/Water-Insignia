
extends Node

const FOLDER = 0

# Refers to one monster
class spawn:
	var name
	var level

	func _init(name, level):
		self.name = name
		self.level = level  

# Refers to a group of monsters
class mob:
	var spawns

	func _init(spawns):
		self.spawns = spawns

# Refers to a group of mobs
class stage_spawner:
	var mobs
	var weapons
	var items

	func _init(mobs, weapons, items):
		self.mobs = mobs
		self.weapons = weapons
		self.items = items

	func get_random_mob():
		var random
		randomize()
		random = randi() % mobs.size()
		return mobs[random]

	func get_permited_weapons(type, wpn_db):
		var vector = []
		for wpn in weapons:
			if wpn_db.get_wpn_type(wpn_db.get_wpn_id(wpn)) == type:
				vector.append(wpn)
		return vector

	func get_random_item(): # 50% chance of returning no item
		var random
		randomize()
		if (randi() % 100) < 50:
			return null
		randomize()
		random = randi() % items.size()
		return items[random]

# Specifics of each stage
var stage_database = [
#	Stage 1
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("bat", 1), spawn.new("bat", 2), spawn.new("bat", 1)]),
		mob.new([spawn.new("samurai", 3)]),
		mob.new([spawn.new("samurai", 1), spawn.new("samurai", 1)])
		],[ # Allowed Weapons
		"Katana",
		"Bamboo Sword",
		"Bamboo Sword",
		"Bamboo Sword",
		],[ # Allowed Items
		"Potion",
		"Poison Bomb",
		"Bomb"]),
#	Stage 2
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("samurai", 3)]),
		mob.new([spawn.new("samurai", 1), spawn.new("samurai", 1)])
		],[ # Allowed Weapons
		"Katana"
		],[ # Allowed Items
		"PAR Bomb"])
]


func get_stage_spawner(id):
	return stage_database[id]