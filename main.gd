extends Node2D

var selectedMob : KinematicBody2D

onready var mob_scn = preload("res://mob/Mob.tscn")

func _ready():
	# connect _on_Mob_clicked signal
	$Mob/Selecting.connect("left_click", self, "_on_Mob_left_click")
	$Mob/Selecting.connect("right_click", self, "_on_Mob_right_click")
	_create_mob()

func _create_mob():
	var mob = mob_scn.instance()
	mob.position = Vector2(500, 500)
	mob.id = 2
	add_child(mob)
	mob.get_node("Selecting").connect("left_click", self, "_on_Mob_left_click")
	mob.get_node("Selecting").connect("right_click", self, "_on_Mob_right_click")
	
	var mob2 = mob_scn.instance()
	mob2.position = Vector2(400, 400)
	mob2.id = 3
	add_child(mob2)
	mob2.get_node("Selecting").connect("left_click", self, "_on_Mob_left_click")
	mob2.get_node("Selecting").connect("right_click", self, "_on_Mob_right_click")

func _on_Mob_left_click(clickedMob):
	selectedMob = clickedMob
	$SelectionMarker.mob = selectedMob

func _on_Mob_right_click(clickedMob):
	if clickedMob == selectedMob\
	or selectedMob == null:
		return
	selectedMob.target = clickedMob

func _unhandled_input(event):
	if not event is InputEventMouseButton:
		return
	if not event.pressed:
		return
	
	if event.button_index == BUTTON_LEFT\
	and selectedMob != null:
		selectedMob = null
		$SelectionMarker.mob = null
		return
	
	if event.button_index == BUTTON_RIGHT\
	and selectedMob != null:
		selectedMob.target = event.global_position
