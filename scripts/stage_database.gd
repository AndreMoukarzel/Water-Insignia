
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
		# Tem que ser mobs.size() - 1, pois o ultimo mob de cada stage
		# sempre será o boss dessa stage, e não queremos que este seja
		# incluido nos mobs aleatorios possiveis.
		random = randi() % (mobs.size() - 1)
		return mobs[random]
		
	func get_stage_boss():
		return mobs[mobs.size() - 1]
		
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
#	Stage 0
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("samurai", 2)]),
		mob.new([spawn.new("samurai", 1), spawn.new("samurai", 1)]),
		mob.new([spawn.new("baby_dragon", 2)]) #boss
		],[ # Allowed Weapons
		"Katana",
		"Bamboo Sword",
		"Bamboo Sword",
		"Bamboo Sword",
		],[ # Allowed Items
		"Potion",
		"Poison Bomb",
		"Bomb"]),
#	Stage 1
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("samurai", 2)]),
		mob.new([spawn.new("samurai", 1), spawn.new("samurai", 2)])
		],[ # Allowed Weapons
		"Katana"
		],[ # Allowed Items
		"Static Bomb"])
]


func get_stage_spawner(id):
	return stage_database[id]