extends Node2D

onready var nav2d : Navigation2D = $NavMap
var selectedMob : KinematicBody2D

onready var mob_scn = preload("res://Mob.tscn")

func _ready():
	# connect _on_Mob_clicked signal
	$Mob/Selecting.connect("clicked", self, "_on_Mob_clicked")
	_create_mob()

func _create_mob():
	var mob = mob_scn.instance()
	mob.position = Vector2(500, 500)
	add_child(mob)
	mob.get_node("Selecting").connect("clicked", self, "_on_Mob_clicked")

func _on_Mob_clicked(clickedMob):
	selectedMob = clickedMob

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if event.button_index != BUTTON_RIGHT or not event.pressed:
		return
	if selectedMob == null:
		return
	var new_path = nav2d.get_simple_path(selectedMob.global_position, event.global_position, false)
	selectedMob.path = new_path
	#$Line2D.points = new_path