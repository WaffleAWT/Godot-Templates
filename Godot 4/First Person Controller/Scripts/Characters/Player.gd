extends CharacterBody3D

@export var speed : int = 4
@export var jump_strength : int = 4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y : float = 0.0
var look_sensitivity : float = 0.003

@onready var camera = $Camera3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var input_vector : Vector2 = Vector2.ZERO
	input_vector.x = Input.get_axis("move_left", "move_right")
	input_vector.y = Input.get_axis("move_forwards", "move_backwards")
	input_vector = input_vector.normalized()
	
	var horizontal_velocity = input_vector * speed
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	if is_on_floor():
		velocity_y = 0
		if Input.is_action_just_pressed("jump"):
			velocity_y = jump_strength
	else:
		velocity_y -= gravity * delta
	
	velocity.y = velocity_y
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
