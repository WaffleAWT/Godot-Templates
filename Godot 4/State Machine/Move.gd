extends state

func physics_update(_delta):
	var input_vector = Input.get_axis("ui_left", "ui_right")
	
	if input_vector != 0:
		owner.position.x += input_vector * 10
	else:
		state_machine.transition_to("Idle")
