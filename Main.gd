extends Node2D

onready var nav2d : Navigation2D = $NavMap
var selectedMob : KinematicBody2D

onready var mob_scn = preload("res://Mob.tscn")

func _ready():
	# connect _on_Mob_clicked signal
	$Mob/Selecting.connect("left_click", self, "_on_Mob_left_click")
	$Mob/Selecting.connect("right_click", self, "_on_Mob_right_click")
	_create_mob()

func _create_mob():
	var mob = mob_scn.instance()
	mob.position = Vector2(500, 500)
	add_child(mob)
	mob.get_node("Selecting").connect("left_click", self, "_on_Mob_left_click")
	mob.get_node("Selecting").connect("right_click", self, "_on_Mob_right_click")

func _on_Mob_left_click(clickedMob):
	selectedMob = clickedMob
	$SelectionMarker.mob = selectedMob
	print("on_Mob_left_click")

func _on_Mob_right_click(clickedMob):
	if clickedMob == selectedMob\
	or selectedMob == null:
		return
	selectedMob.target = clickedMob
	print("on_Mob_right_click")

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	
	print("_unhandled_input")
	if event.button_index == BUTTON_LEFT\
	and selectedMob != null:
		selectedMob = null
		$SelectionMarker.mob = null
		return
	
	if event.button_index != BUTTON_RIGHT:
		return
	if selectedMob == null:
		return
	var new_path = nav2d.get_simple_path(selectedMob.global_position, event.global_position, false)
	selectedMob.path = new_path
	$Line2D.points = new_path