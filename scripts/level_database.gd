
extends Node

const FOLDER = 0


class spawn:
	var name
	var level

	func _init(name, level):
		self.name = name
		self.level = level  

class mob:
	var spawns

	func _init(spawns):
		self.spawns = spawns

class level_spawner:
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

	func get_allowed_weapons(type):
		var vector
		for wpn in weapons:
			if wpn_db.get_wpn_type(wpn_db.get_wpn_id(name)) == type:
				vector.append(wpn)
		return vector

	func get_random_item():
		var random
		randomize()
		random = randi() % items.size()
		return items[random]


var level_database = [
#	Level 1
	level_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("Bat", 3), spawn.new("Bat", 5), spawn.new("Bat", 3)]),
		mob.new([spawn.new("Samurai", 6)]),
		mob.new([spawn.new("Samurai", 3), spawn.new("Samurai", 3)])
		],[ # Allowed Weapons
		"Katana",
		"Bamboo Sword"
		],[ # Allowed Items
		"Potion",
		"Poison Bomb",
		"Bomb"]),
#	Level 2
	level_spawner.new([ #Allowed Mobs
		spawn.new("Samurai", 8)
		],[ # Allowed Weapons
		"Katana"
		],[ # Allowed Items
		"PAR Bomb"
		])
]


func get_level_spawner(id):
	return level_database[id]