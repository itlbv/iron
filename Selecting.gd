extends Area2D

signal clicked

func _on_Selecting_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
	and event.button_index == BUTTON_LEFT \
	and event.pressed:
		emit_signal("clicked", get_parent())