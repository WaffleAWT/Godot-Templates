extends Node2D

@export var locomotion_state : state

@onready var animator : AnimatedSprite2D = $AnimatedSprite2D

func _process(_delta):
	if owner.current_state == "Locomotion":
		var horizontal : float = owner.get_input_velocity()
		
		animate_flip_h(horizontal)
		
		if owner.is_on_floor():
			animate_floor(horizontal)
		else:
			animate_air()
	
	if owner.current_state == "OnWall":
		animate_wall()
	
	if owner.current_state == "Roll":
		animate_roll()
	
	if owner.current_state == "Attack":
		animate_attack()
	
	if owner.current_state == "Attack2":
		animate_attack_2()

func animate_floor(value):
	if value != 0.0:
		if Inventory.weapon_inventory.count("Sword") == 0:
			animator.play("Run")
		else:
			animator.play("Sword Run")
	else:
		if Inventory.weapon_inventory.count("Sword") == 0:
			animator.play("Idle")
		else:
			animator.play("Sword Idle")

func animate_air():
	var height : float = owner.velocity.y
	
	if height > 0.0 && height < 100:
		animator.play("Peak")
	elif height < 0.0:
		if locomotion_state.has_double_jump:
			animator.play("Jump")
		else:
			animator.play("Double Jump")
	else:
		animator.play("Fall")

func animate_flip_h(value):
	if value != 0.0:
		if value > 0.0:
			animator.flip_h = false
		else:
			animator.flip_h = true

func animate_wall():
	if !animator.animation == "Wall Slide":
		if !animator.frame == 1:
			animator.play("Wall Slide")

func animate_roll():
	animator.play("Roll")

func animate_attack():
	if Inventory.weapon_inventory.count("Sword") == 0:
		animator.play("Attack")
	else:
		animator.play("Sword Attack")

func animate_attack_2():
	animator.play("Sword Attack 2")
