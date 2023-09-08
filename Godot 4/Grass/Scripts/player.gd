extends CharacterBody3D

var speed : int = 2

const LERP_VALUE : float = 0.15
const WALK_SPEED : int = 2
const RUN_SPEED : int = 4
const JUMP_STRENGTH : int = 5

@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var player_model = $PlayerModel
@onready var animator = $AnimationTree

#Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

#Set mouse mode to be in the center of the screen
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

#Camera rotation script
func _unhandled_input(event):
	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * 0.005)
		spring_arm.rotate_x(-event.relative.y * 0.005)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

func _physics_process(delta):
	#Add the gravity
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	#Get the input direction and handle the movement/deceleration
	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y) #Rotates the direction to be relative to the camera
	if direction:
		velocity.x = lerp(velocity.x, direction.x * speed, LERP_VALUE)
		velocity.z = lerp(velocity.z, direction.z * speed, LERP_VALUE)
		player_model.rotation.y = lerp_angle(player_model.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VALUE) #Rotate player model relative to the direction
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VALUE)
		velocity.z = lerp(velocity.z, 0.0, LERP_VALUE)
	
	if Input.is_action_pressed("run"):
		speed = RUN_SPEED
	else:
		speed = WALK_SPEED
	
	if Input.is_action_just_pressed("jump") && is_on_floor():
		velocity.y = JUMP_STRENGTH
	
	animate(delta)
	move_and_slide()

func animate(_delta):
	var iw_blend = (velocity.length() - WALK_SPEED) / WALK_SPEED
	var wr_blend = (velocity.length() - WALK_SPEED) / (RUN_SPEED - WALK_SPEED)
	
	if is_on_floor():
		animator.set("parameters/State/transition_request", "Ground")
	else:
		animator.set("parameters/State/transition_request", "Air")
	
	if velocity.length() <= WALK_SPEED:
		animator.set("parameters/iwr_blend/blend_amount", iw_blend)
	else:
		animator.set("parameters/iwr_blend/blend_amount", wr_blend)
	
	if velocity.y > 0:
#		animator.set("parameters/jf_blend/blend_amount", lerp(animator.get("parameters/jf_blend/blend_amount"), 0, delta * LERP_VALUE))
		animator.set("parameters/jf_blend/blend_amount", 0)
	else:
#		animator.set("parameters/jf_blend/blend_amount", lerp(animator.get("parameters/jf_blend/blend_amount"), 1, delta * LERP_VALUE))
		animator.set("parameters/jf_blend/blend_amount", 1)
