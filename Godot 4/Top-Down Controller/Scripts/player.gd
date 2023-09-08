extends CharacterBody2D

@export var max_speed : int = 80
@export var acceleration : int = 500
@export var friction : int = 500

@onready var animator : AnimationTree = $AnimationTree
@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_up", "move_down")
	input_vector = input_vector.normalized()
	
	if input_vector != Vector2.ZERO:
		velocity = velocity.move_toward(input_vector * max_speed, acceleration * delta)
	else:
		velocity = velocity.move_toward(Vector2.ZERO, friction * delta)
	
	move_and_slide()
	animate(input_vector)
	
#	0.707107

func animate(input):
	if input != Vector2.ZERO:
		animator.set("parameters/iw_blend/blend_amount", 1)
		match input:
			Vector2(-0.707107, -0.707107):
				animator.set("parameters/Walk/blend_position", Vector2(-1, -1))
				animator.set("parameters/Idle/blend_position", Vector2(-1, -1))
			Vector2(-1, 0):
				animator.set("parameters/Walk/blend_position", Vector2(-1, 0))
				animator.set("parameters/Idle/blend_position", Vector2(-1, 0))
			Vector2(-0.707107, 0.707107):
				animator.set("parameters/Walk/blend_position", Vector2(-1, 1))
				animator.set("parameters/Idle/blend_position", Vector2(-1, 1))
			Vector2(0, -1):
				animator.set("parameters/Walk/blend_position", Vector2(0, -1))
				animator.set("parameters/Idle/blend_position", Vector2(0, -1))
			Vector2(0, 1):
				animator.set("parameters/Walk/blend_position", Vector2(0, 1))
				animator.set("parameters/Idle/blend_position", Vector2(0, 1))
			Vector2(0.707107, -0.707107):
				animator.set("parameters/Walk/blend_position", Vector2(1, -1))
				animator.set("parameters/Idle/blend_position", Vector2(1, -1))
			Vector2(1, 0):
				animator.set("parameters/Walk/blend_position", Vector2(1, 0))
				animator.set("parameters/Idle/blend_position", Vector2(1, 0))
			Vector2(0.707107, 0.707107):
				animator.set("parameters/Walk/blend_position", Vector2(1, 1))
				animator.set("parameters/Idle/blend_position", Vector2(1, 1))
	else:
		animator.set("parameters/iw_blend/blend_amount", 0)
