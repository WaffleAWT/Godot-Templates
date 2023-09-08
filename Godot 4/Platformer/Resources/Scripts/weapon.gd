extends Area2D

@export var weapon_name : String

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if weapon_name not in Inventory.weapon_inventory:
			Inventory.add_weapon(weapon_name)
			queue_free()
