extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")
onready var moveTimer = $MoveTimer

const SPEED = 100
var path = []
var usePath
var velocity = Vector2.ZERO

# direction of last movement. right - false; left - true
var last_direction = false

var target

func _process(delta):
	_set_animation()

func _set_animation():
	if velocity.length() > 0:
		animation.travel("walk")
	# flipping animation according to the last direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	$Sprite.flip_h = last_direction

func _physics_process(delta):
	_move()

func _move():
	if target == null:
		return
	velocity = Vector2.ZERO
	if usePath == null:
		_can_see_target()
	if usePath:
		velocity = _get_path_velocity()
	else:
		velocity = _get_steering_velocity()
	move_and_slide(velocity)

func _can_see_target():
	var collision = get_world_2d().direct_space_state.intersect_ray(position, target.position, [self])
	usePath = collision.collider == target

func _get_steering_velocity():
	var vect_to_target = target.position - position;
	print("steer")
	if target.position.distance_to(position) < 25:
		return Vector2.ZERO
	return vect_to_target.normalized() * SPEED

func _get_path_velocity():
	while path.size() > 0:
		# get next waypoint
		if (position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - position
		print("path")
		return vec_to_next.normalized() * SPEED

func _on_MeleeRange_body_entered(body):
	if body == target:
		animation.travel("attack")

func _on_MeleeRange_body_exited(body):
	pass

func _on_MoveTimer_timeout():
	_can_see_target()
