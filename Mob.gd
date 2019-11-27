extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")
onready var moveTimer = $MoveTimer

const SPEED = 100
var path = []
var usePath
var velocity = Vector2.ZERO

enum states {IDLE, MOVE, FIGHT}
var state = states.IDLE

# direction of last movement. right - false; left - true
var last_direction = false

var target setget set_target

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
	velocity = Vector2.ZERO
	match state:
		states.MOVE: _move()
		states.FIGHT: pass

func _move():
	if target == null: return
	if usePath == null: 
		_can_see_target()
	velocity = _get_path_velocity() if usePath else _get_steering_velocity()
	move_and_slide(velocity)

func _can_see_target():
	var collision = get_world_2d().direct_space_state.intersect_ray(position, target.position, [self])
	usePath = collision.collider != target
	print("path" if usePath else "steer")

func _get_steering_velocity():
	if target.position.distance_to(position) < 25:
		return Vector2.ZERO
	var vect_to_target = target.position - position;
	return vect_to_target.normalized() * SPEED

func _get_path_velocity():
	while path.size() > 0:
		# get next waypoint
		if (position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - position
		return vec_to_next.normalized() * SPEED

func set_target(targ):
	target = targ
	state = states.MOVE
	moveTimer.start()

func _on_MeleeRange_body_entered(body):
	print("body_enter")
	if body == target:
		print("body_target")
		moveTimer.stop()
		state = states.FIGHT
		animation.travel("attack")

func _on_MeleeRange_body_exited(body):
	pass

func _on_MoveTimer_timeout():
	_can_see_target()
