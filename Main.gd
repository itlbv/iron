extends Node2D

onready var nav2d : Navigation2D = $NavMap
onready var mob : KinematicBody2D = $Mob

func _ready():
	pass 

#func _process(delta):
#	pass

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	
	var new_path = nav2d.get_simple_path(mob.global_position, event.global_position, true)
	mob.path = new_path