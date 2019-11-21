extends Area2D

export var speed = 150
var screen_size

# shows last direction of movement. right - false; left - true
var last_direction = false;

func _ready():
	screen_size = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	
	# processing input
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	 
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop(false)
	
	# setting position
	position += velocity * delta
	position.x = clamp(position.x, 0, screen_size.x)
	position.y = clamp(position.y, 0, screen_size.y)
	
	# flipping animation according to the last direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	$Sprite.flip_h = last_direction