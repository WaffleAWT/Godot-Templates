extends Node

var items_inventory : Array = []
var weapon_inventory : Array = []
var max_stack : int = 16
var max_inventory_size : int = 128

func add_item(item):
	if items_inventory.size() < max_inventory_size:
		if items_inventory.count(item) < max_stack:
			items_inventory.append(item)

func remove_item(item):
	if item in items_inventory:
		items_inventory.erase(item)

func add_weapon(weapon):
	if weapon not in weapon_inventory:
		weapon_inventory.append(weapon)

func remove_weapon(weapon):
	if weapon in weapon_inventory:
		weapon_inventory.erase(weapon)
