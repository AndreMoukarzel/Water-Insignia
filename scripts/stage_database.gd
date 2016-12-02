
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
		random = randi() % items.size()
		return items[random]

# Specifics of each stage
var stage_database = [
#	Stage 0 - BALANCED
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("mage", 1)]),
		mob.new([spawn.new("samurai", 1)]),
		mob.new([spawn.new("soldier", 1)]),
		mob.new([spawn.new("soldier", 1)]),
		mob.new([spawn.new("soldier", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("samurai", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("baby_dragon", 2)]) #boss
		],[ # Allowed Weapons
#		"Rapier",
#		"Katana",
		"Bamboo Sword",
		"Iron Sword",
		"Iron Axe",
		"Iron Spear",
		"Book",
		],[ # Allowed Items
		"Small Potion",
		"Bomb"]),

#	Stage 1 - BALANCED
	stage_spawner.new([ #Allowed Mobs
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("mage", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("samurai", 2)]),
		mob.new([spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 2)]),
		mob.new([spawn.new("soldier", 2)]),
		mob.new([spawn.new("samurai", 2), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("bat", 2)])
		],[ # Allowed Weapons
#		"Katana",
		"Bamboo Sword",
		"Iron Sword",
		"Iron Axe",
		"Iron Spear"
		],[ # Allowed Items
		"Static Bomb",
		"Small Potion",
		"Bomb"]),

#	Stage 2 - BALANCED
	stage_spawner.new([
		mob.new([spawn.new("samurai", 1), spawn.new("soldier", 1)]),
		mob.new([spawn.new("samurai", 1), spawn.new("soldier", 1)]),
		mob.new([spawn.new("samurai", 1), spawn.new("soldier", 1)]),
		mob.new([spawn.new("samurai", 1), spawn.new("soldier", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("mage", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("mage", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("mage", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("mage", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 1), spawn.new("baby_dragon", 1), spawn.new("bat", 1)]),
		mob.new([spawn.new("bat", 3)]),
		mob.new([spawn.new("samurai", 3)]),
		],[
#		"Katana",
#		"Katana",
#		"Sharp Katana",
		"Iron Sword",
		"Iron Axe",
		"Iron Spear",
		"Bamboo Sword",
		],[
		"Potion",
		"Potion",
		"Bomb",
		"Static Bomb"]),
		
#	Stage 3 - BALANCED (bit hard)
	stage_spawner.new([
		mob.new([spawn.new("soldier", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 1), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 1), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 1), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 1), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 1), spawn.new("bat", 3)]),
		mob.new([spawn.new("baby_dragon", 4)]),
		mob.new([spawn.new("bat", 2), spawn.new("mage", 1), spawn.new("bat", 2)]),
		mob.new([spawn.new("bat", 1), spawn.new("samurai", 3), spawn.new("bat", 1)]),
		],[
#		"Katana",
#		"Katana",
#		"Sharp Katana",
		"Bamboo Sword",
		"Iron Sword",
		"Iron Axe",
		"Iron Spear"
		],[
		"Potion",
		"Potion",
		"Bomb",
		"Static Bomb"]),
	
#	Stage 4 - BALANCED
	stage_spawner.new([
		mob.new([spawn.new("baby_dragon", 2), spawn.new("mage", 2)]),
		mob.new([spawn.new("samurai", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("samurai", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("samurai", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("soldier", 2), spawn.new("samurai", 2)]),
		mob.new([spawn.new("bat", 3), spawn.new("samurai", 2), spawn.new("bat", 2)]),
		mob.new([spawn.new("soldier", 5)])
		],[
		"Book",
		"Scimitar",
		"Broad Axe",
		"Heavy Spear"
		],[
		"Potion",
		"Potion",
		"Big Bomb"]),
	
]


func get_stage_spawner(id):
	return stage_database[id]
