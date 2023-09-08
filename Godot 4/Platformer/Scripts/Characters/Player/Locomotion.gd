extends state

var has_double_jump : bool = true

@export var move_speed : float = 200.0

@export var jump_height : float
@export var jump_time_to_peak : float
@export var jump_time_to_descent : float

@export var wall_check : RayCast2D
@export var animator : AnimatedSprite2D

@onready var jump_velocity : float = ((2.0 * jump_height) / jump_time_to_peak) * -1
@onready var jump_gravity : float = ((-2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1
@onready var fall_gravity : float = ((-2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent)) * -1

func enter(_msg := {}):
	has_double_jump = true

func physics_update(delta):
	owner.velocity.y += get_gravity() * delta
	owner.velocity.x = get_input_velocity() * move_speed
	wall_check.enabled = !owner.is_on_floor()
	
	if Input.is_action_just_pressed("jump") && owner.is_on_floor():
		jump()
	elif Input.is_action_just_pressed("jump") && !owner.is_on_floor() && has_double_jump:
		double_jump()
	
	if owner.is_on_floor() && !has_double_jump:
		has_double_jump = true
	
	owner.move_and_slide()
	
	if !owner.is_on_floor() && get_gravity() == fall_gravity && wall_check.is_colliding():
		has_double_jump = true
		state_machine.transition_to("OnWall")

func update(_delta):
	if animator.flip_h:
		wall_check.scale.x = -1
	else:
		wall_check.scale.x = 1

func handle_input(_event):
	if Input.is_action_just_pressed("roll") && owner.is_on_floor():
		state_machine.transition_to("Roll")
	
	if Input.is_action_just_pressed("attack") && owner.is_on_floor():
		state_machine.transition_to("Attack")

func get_input_velocity() -> float:
	var horizontal : float = 0.0
	
	if Input.is_action_pressed("move_left"):
		horizontal -= 1
	if Input.is_action_pressed("move_right"):
		horizontal += 1
	
	return horizontal

func get_gravity() -> float:
	return jump_gravity if owner.velocity.y < 0.0 else fall_gravity

func jump():
	owner.velocity.y = jump_velocity

func double_jump():
	owner.velocity.y = jump_velocity
	has_double_jump = false
