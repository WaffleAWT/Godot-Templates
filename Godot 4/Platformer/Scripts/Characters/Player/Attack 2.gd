extends state

@export var push_vector : float

@export var animator : AnimatedSprite2D

func enter(_msg := {}):
	owner.velocity.x = 0

func physics_update(_delta):
	if animator.frame == 4:
		if animator.flip_h:
			owner.velocity.x = -push_vector
		else:
			owner.velocity.x = push_vector
	
	owner.move_and_slide()

func update(_delta):
	if animator.frame == 6:
		state_machine.transition_to("Locomotion")
