extends Camera2D

var mouse_position : Vector2 = Vector2()
var mouse_position_global : Vector2 = Vector2()
var drag_start : Vector2 = Vector2()
var drag_start_vector : Vector2 = Vector2()
var drag_end : Vector2 = Vector2()
var drag_end_vector : Vector2 = Vector2()
var is_dragging : bool = false
signal area_selected
signal start_move_selection

@export var panel : Panel

func _process(_delta):
	if Input.is_action_just_pressed("left click"):
		drag_start = mouse_position_global
		drag_start_vector = mouse_position
		is_dragging = true
		if not panel.visible:
			panel.visible = true
	
	if is_dragging:
		drag_end = mouse_position_global
		drag_end_vector = mouse_position
		draw_area()
	
	if Input.is_action_just_released("left click"):
		if drag_start_vector.distance_to(mouse_position) > 20:
			drag_end = mouse_position_global
			drag_end_vector = mouse_position
			is_dragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			drag_end = drag_start
			is_dragging = false
			draw_area(false)

func _input(event):
	if event is InputEventMouse:
		mouse_position = event.position
		mouse_position_global = get_global_mouse_position()

func draw_area(s=true):
	panel.size = Vector2(abs(drag_start_vector.x - drag_end_vector.x), abs(drag_start_vector.y - drag_end_vector.y))
	var pos : Vector2 = Vector2()
	pos.x = min(drag_start_vector.x, drag_end_vector.x)
	pos.y = min(drag_start_vector.y, drag_end_vector.y)
	panel.position = pos
	panel.size *= int(s)
