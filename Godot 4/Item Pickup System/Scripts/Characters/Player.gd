extends CharacterBody3D

@export var speed : int = 3
@export var jump_strength : int = 4

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity_y : float = 0.0
var look_sensitivity : float = 0.003

var distance_to_detach : float = 4.0
var pulling_strength : int = 4
var target = null
var is_holding_item = false

@onready var camera = $Camera3D
@onready var raycast = $Camera3D/RayCast3D
@onready var marker = $Camera3D/RayCast3D/Marker3D

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta):
	var horizontal_velocity = Input.get_vector("move_left", "move_right", "move_forwards", "move_backwards").normalized() * speed
	velocity = horizontal_velocity.x * global_transform.basis.x + horizontal_velocity.y * global_transform.basis.z
	
	if is_on_floor():
		velocity_y = 0
		if Input.is_action_just_pressed("jump"):
			velocity_y = jump_strength
	else:
		velocity_y -= gravity * delta
	
	velocity.y = velocity_y
	
	move_and_slide()
	
	if Input.is_action_just_pressed("pickup"):
		if raycast.is_colliding():
			target = raycast.get_collider()
			if target is RigidBody3D:
				target.animator.play("outline")
	
	if Input.is_action_just_released("pickup"):
		if target is RigidBody3D:
			target.animator.play("detach")
			target = null
	
	if target != null:
		if target is RigidBody3D:
			var a = marker.global_transform.origin
			var b = target.global_transform.origin
			target.linear_velocity = (a - b) * pulling_strength
			if (a - b).x > distance_to_detach or (a - b).y > distance_to_detach or (a - b).z > distance_to_detach or (a - b).x < -distance_to_detach or (a - b).y < -distance_to_detach or (a - b).z < -distance_to_detach:
				target.animator.play("detach")
				target = null
		else:
			target = null

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * look_sensitivity)
		camera.rotate_x(-event.relative.y * look_sensitivity)
		camera.rotation.x = clamp(camera.rotation.x, -PI/2, PI/2)
