extends state

@export var roll_magnitude : float

@export var animator : AnimatedSprite2D

func enter(_msg := {}):
	if animator.flip_h:
		owner.velocity.x = -roll_magnitude
	else:
		owner.velocity.x = roll_magnitude

func physics_update(_delta):
	owner.move_and_slide()
	
	if !owner.is_on_floor():
		state_machine.transition_to("Locomotion")

func update(_delta):
	if animator.animation == "Roll" && animator.frame == 6:
		state_machine.transition_to("Locomotion")
