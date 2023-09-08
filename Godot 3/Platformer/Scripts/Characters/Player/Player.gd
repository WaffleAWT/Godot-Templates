extends KinematicBody2D

const JUMP_FORCE : int = -160
const JUMP_RELEASE_FORCE : int = -40
const GRAVITY : int = 5
const ADDITIONAL_FALL_GRAVITY : int = 2
const ACCELERATION : int = 10
const FRICTION : int = 10
const MAX_SPEED : int = 75

var velocity : Vector2 = Vector2.ZERO
var in_air_time : int = 0

onready var animator : AnimatedSprite = $AnimatedSprite
onready var landing_timer : Timer = $LandingTimer
onready var wall_check : RayCast2D = $WallCheck

func _physics_process(_delta):
	apply_gravity()
	
	var input : Vector2 = Vector2.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	
	if input.x == 0:
		apply_friction()
		if landing_timer.is_stopped():
			animator.play("Idle")
	else:
		apply_acceleration(input.x)
		if landing_timer.is_stopped():
			animator.play("Run")
		
		if input.x > 0:
			animator.flip_h = false
			wall_check.scale.x = 1
		else:
			animator.flip_h = true
			wall_check.scale.x = -1
	
	if is_on_floor():
		in_air_time = 0
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_FORCE
	else:
		in_air_time += 1
		if velocity.y < 0:
			animator.play("Jump")
		elif velocity.y > 30:
			animator.play("Fall")
		else:
			animator.play("Peak")
		
		if Input.is_action_just_released("jump") && velocity.y < JUMP_RELEASE_FORCE:
			velocity.y = JUMP_RELEASE_FORCE
		
		if velocity.y > 0:
			velocity.y += ADDITIONAL_FALL_GRAVITY
	
	var was_in_air = !is_on_floor()
	velocity = move_and_slide(velocity, Vector2.UP)
	var just_landed = is_on_floor() && was_in_air
	if just_landed:
		if in_air_time > 60:
			landing_timer.start()
			animator.play("Land")

func apply_gravity():
	velocity.y += GRAVITY

func apply_friction():
	velocity.x = move_toward(velocity.x, 0, FRICTION)

func apply_acceleration(amount):
	velocity.x = move_toward(velocity.x, MAX_SPEED * amount, ACCELERATION)
