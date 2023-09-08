extends state

@export var wall_gravity : float
@export var jump_velocity : float
@export var max_slide_velocity : float

@export var animator : AnimatedSprite2D
@export var wall_check : RayCast2D

func enter(_msg := {}):
	owner.velocity.y = 0.0

func physics_update(delta):
	if !owner.is_on_floor():
		owner.velocity.x = 0.0
		
		if owner.velocity.y < max_slide_velocity:
			owner.velocity.y += wall_gravity * delta
		else:
			owner.velocity.y = max_slide_velocity
		
		owner.move_and_slide()
	else:
		state_machine.transition_to("Locomotion")
	
	if !wall_check.is_colliding():
		state_machine.transition_to("Locomotion")

func handle_input(_event):
	if Input.is_action_just_pressed("jump"):
		if animator.flip_h && Input.is_action_pressed("move_right"):
			jump()
		elif !animator.flip_h && Input.is_action_pressed("move_left"):
			jump()

func jump():
	owner.velocity.y = -jump_velocity
	state_machine.transition_to("Locomotion")
