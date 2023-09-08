extends Node

var inventory : Array = ["stick", "wood", "wood"]
var max_stack : int = 16
var max_inventory_size : int = 128

var crafting_recipes : Dictionary = {
	"wooden_sword": ["stick", "wood", "wood"],
	"stone_sword": ["stick", "stone", "stone"],
	"iron_sword": ["stick", "iron_ingot", "iron_ingot"]
	}

func add_item(item):
	if inventory.size() < max_inventory_size:
		if inventory.count(item) < max_stack:
			inventory.append(item)
		else:
			print("You have the maximum amount of ", item, "!")
	else:
		print("Inventory is full!")

func remove_item(item):
	if item in inventory:
		inventory.erase(item)

func craft(item):
	if inventory.size() < max_inventory_size:
		if inventory.count(item) < max_stack:
			if crafting_recipes.has(item):
				var recipe : Array = crafting_recipes[item]
				var has_ingrediant : Array = []
				for ingrediant in recipe:
					var ingrediants_required : int = recipe.count(ingrediant)
					if inventory.count(ingrediant) >= ingrediants_required:
						has_ingrediant.append(ingrediant)
					else:
						print("You don't have enough resources to craft ", item, "!")
						has_ingrediant.clear()
						break
				if not has_ingrediant.is_empty():
					for ingrediant in has_ingrediant:
						remove_item(ingrediant)
					add_item(item)
					has_ingrediant.clear()
		else:
			print("You have the maximum amount of ", item, "!")
	else:
		print("Inventory is full!")

func _ready():
	print(inventory)
	craft("wooden_sword")
	print(inventory)
