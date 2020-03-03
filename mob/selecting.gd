extends Area2D

signal left_click
signal right_click

func _on_Selecting_input_event(viewport, event, shape_idx):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return	
	if event.button_index == BUTTON_LEFT:
		emit_signal("left_click", get_parent())
	if event.button_index == BUTTON_RIGHT:
		emit_signal("right_click", get_parent())
