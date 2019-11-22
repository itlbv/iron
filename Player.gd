extends KinematicBody2D

const SPEED = 3
var velocity =  Vector2()

# direction of last movement for choosing animation. right - false; left - true
var last_direction = false;

func _ready():
	pass
	#screen_size = get_viewport_rect().size

func _physics_process(delta):
	_set_velocity()
	_set_animation()
	move_and_collide(velocity)

func _set_velocity():
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

func _set_animation():
	if velocity.length() > 0:
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
	
	# flipping animation according to the last direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	$Sprite.flip_h = last_direction