extends state

var has_attacked : bool = false

@export var push_vector : float

@export var animator : AnimatedSprite2D

func enter(_msg := {}):
	owner.velocity.x = 0
	has_attacked = false

func update(_delta):
	if Inventory.weapon_inventory.count("Sword") == 0:
		if animator.frame == 7:
			state_machine.transition_to("Locomotion")
	else:
		if animator.frame == 5:
			if !has_attacked:
				state_machine.transition_to("Locomotion")
			else:
				state_machine.transition_to("Attack2")

func physics_update(_delta):
	if Inventory.weapon_inventory.count("Sword") == 0 && animator.frame == 4:
		if animator.flip_h:
			owner.velocity.x = -push_vector
		else:
			owner.velocity.x = push_vector
	
	owner.move_and_slide()

func handle_input(_event):
	if Input.is_action_just_pressed("attack"):
		has_attacked = true
