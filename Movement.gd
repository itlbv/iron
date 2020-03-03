extends Node2D

onready var move_timer = $MoveTimer

var velocity = Vector2.ZERO

var path
var usePath
var target_pos

func stop():
	pass

func _init_movement(target):
	_can_see_target(target)
	if move_timer.is_stopped():
		move_timer.start()

func _can_see_target(target):
	var collision = get_world_2d().direct_space_state.intersect_ray(position, target_pos, [self])
	if typeof(target) == TYPE_OBJECT:
		usePath = collision.collider != target
	elif typeof(target) == TYPE_VECTOR2:
		usePath = collision.size() != 0
	#_log("path" if usePath else "steer")

func _update_target_position(target):
	target_pos = target if typeof(target) == TYPE_VECTOR2 else target.position

func move():
	var target = get_parent().target
	if target == null: 
		_log("ERROR: MOVE WHILE NO TARGET")
		stop()
	_update_target_position(target)
	if usePath == null:
		_init_movement(target)
	velocity = _get_path_velocity() if usePath else _get_steering_velocity()
	get_parent().move_and_slide(velocity)

func _get_steering_velocity() -> Vector2:
	if position.distance_to(target_pos) < 5:
		stop()
		return Vector2.ZERO
	var vect_to_target = target_pos - position;
	return vect_to_target.normalized() * get_parent().SPEED

func _get_path_velocity() -> Vector2:
	if path == null:
		_set_path()
	while path.size() > 0:
		# get next waypoint
		if (position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - position
		return vec_to_next.normalized() * get_parent().SPEED

func _set_path():
	path = navMap.get_simple_path(position, target_pos, false)

func _on_MoveTimer_timeout():
	var target = get_parent().target
	if target == null:
		_log("ERROR moveTimer running without target") 
		stop()
	_init_movement(target)

func _log(msg):
	print(str(id) + ": " + msg)
