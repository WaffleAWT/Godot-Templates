extends Sprite2D

func _physics_process(_delta):
	if position.x != 500:
		position.x = lerp(position.x, position.x + 50, 0.1)
