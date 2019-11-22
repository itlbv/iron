extends KinematicBody2D

const SPEED = 250
var velocity =  Vector2()

# direction of last movement for choosing animation. right - false; left - true
var last_direction = false;

onready var animation = $AnimationPlayer
onready var sprite = $Sprite

func _ready():
	pass

func _process(delta):
	_set_animation()

func _set_animation():
	if velocity.length() > 0:
		animation.play("walk")
	else:
		animation.stop()
	
	# flipping animation according to the last direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	sprite.flip_h = last_direction

func _physics_process(delta):
	_get_input()
	move_and_slide(velocity)

func _get_input():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -1
	elif Input.is_action_pressed("ui_right"):
		velocity.x = 1
	else: velocity.x = 0
	
	if Input.is_action_pressed("ui_up"):
		velocity.y = -1
	elif Input.is_action_pressed("ui_down"):
		velocity.y = 1
	else: velocity.y = 0
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * SPEED