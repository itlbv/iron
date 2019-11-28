extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")
onready var moveTimer = $MoveTimer
onready var navMap = get_tree().get_root().get_node("Main/NavMap")

const SPEED = 100
var path
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
	match state:
		states.IDLE : pass
		states.MOVE: _move()
		states.FIGHT: pass

func _move():
	if target == null: 
		print("MOVE while no target")
		return
	if usePath == null: 
		_can_see_target()	
	velocity = _get_path_velocity() if usePath else _get_steering_velocity()
	move_and_slide(velocity)

func _can_see_target():
	var collision 
	if typeof(target) == TYPE_OBJECT:
		collision = get_world_2d().direct_space_state.intersect_ray(position, target.position, [self])
		usePath = collision.collider != target
	elif typeof(target) == TYPE_VECTOR2:
		collision = get_world_2d().direct_space_state.intersect_ray(position, target, [self])
		usePath = collision.size() != 0
	print("path" if usePath else "steer")

func _get_steering_velocity():
	var trg
	if typeof(target) == TYPE_OBJECT:
		trg = target.position
	elif typeof(target) == TYPE_VECTOR2:
		trg = target

	if trg.distance_to(position) < 5:
		return Vector2.ZERO
	var vect_to_target = trg - position;
	return vect_to_target.normalized() * SPEED

func _set_path():
	if typeof(target) == TYPE_OBJECT:
		path = navMap.get_simple_path(position, target.position, false)
	elif typeof(target) == TYPE_VECTOR2:
		path = navMap.get_simple_path(position, target, false)

func _get_path_velocity():
	if path == null:
		_set_path()
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

func _stop():
	print("stop")
	velocity = Vector2.ZERO
	usePath = null
	path = null
	state = states.IDLE
	moveTimer.stop()

func _on_MeleeRange_body_entered(body):
	if not typeof(target) == TYPE_OBJECT:
		return
	if body == target:
		_stop()
		state = states.FIGHT
		animation.travel("attack")

func _on_MeleeRange_body_exited(body):
	pass

func _set_movement():
	_can_see_target()

func _on_MoveTimer_timeout():
	_set_movement()