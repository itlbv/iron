extends Node2D

onready var move_timer = $MoveTimer

var path
var usePath
var target setget set_target
var target_pos

func get_velocity() -> Vector2:
	if target == null: 
		_log("ERROR: MOVE WHILE NO TARGET")
		return Vector2.ZERO
	if usePath == null:
		_log("ERROR: USEPATH IS NULL")
	_set_target_position()
	return _get_path_velocity() if usePath else _get_steering_velocity()

func set_target(trg):
	target = trg
	_set_target_position()
	_can_see_target()
	move_timer.start()
	state = states.MOVE

func _set_target_position():
	trg_pos = target if typeof(target) == TYPE_VECTOR2 else target.position

func _on_MoveUpdateTimer_timeout():
	_can_see_target()

func _can_see_target():
	var collision = get_world_2d().direct_space_state.intersect_ray(position, trg_pos, [self])
	if typeof(target) == TYPE_OBJECT:
		usePath = collision.collider != target
	elif typeof(target) == TYPE_VECTOR2:
		usePath = collision.size() != 0
	#_log("path" if usePath else "steer")

func _get_steering_velocity() -> Vector2:
	if position.distance_to(trg_pos) < 5:
		_stop()
		return Vector2.ZERO
	var vect_to_target = trg_pos - position;
	return vect_to_target.normalized() * SPEED

func _get_path_velocity() -> Vector2:
	if path == null:
		_set_path()
	while path.size() > 0:
		# get next waypoint
		if (position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - position
		return vec_to_next.normalized() * SPEED

func _log(msg):
	print(str(id) + ": " + msg)
