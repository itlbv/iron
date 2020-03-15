extends Action
class_name Move

var destination : Vector2

var update_timer : Timer
var navMap : Navigation2D
var debug_path_line : Line2D

var usePath = null
var path
var velocity : Vector2

func _init(owner: Mob, target: Mob, dest: Vector2).(owner, target):
	destination = dest
	navMap = mob.get_node("/root/Main/NavMap")
	debug_path_line = mob.get_node("/root/Main/Line2D")
	update_timer = Timer.new()	
	update_timer.wait_time = 0.5
# warning-ignore:return_value_discarded
	update_timer.connect("timeout", self, "_update_timer_timeout")
	mob.add_child(update_timer)

func do() -> void:
	#print(str(update_timer.get_time_left()))
	if usePath == null:
		_setup_movement()
	velocity = Vector2.ZERO
	velocity = _get_path_velocity() if usePath else _get_steering_velocity()
# warning-ignore:return_value_discarded
	mob.move_and_slide(velocity)

func _update_timer_timeout():
	#print(str(mob.id) + "move timer timeout")
	if target != null:
		destination = target.position
	_setup_movement()

func _get_path_velocity() -> Vector2:
	if path == null:
		_set_path()
	while path.size() > 0:
		# get next waypoint
		if (mob.position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - mob.position
		return vec_to_next.normalized() * mob.SPEED

func _set_path():
	path = navMap.get_simple_path(mob.position, destination, false)
	debug_path_line.points = path

func _get_steering_velocity() -> Vector2:
	if mob.position.distance_to(destination) < 5:
		_stop()
		return Vector2.ZERO
	var vect_to_target = destination - mob.position;
	return vect_to_target.normalized() * mob.SPEED

func _stop() -> void:
	pass

func _setup_movement() -> void:
	_check_if_use_path()
	if update_timer.is_stopped():
		update_timer.start()

func _check_if_use_path() -> void:
	var collision = mob.get_world_2d().direct_space_state.intersect_ray(mob.position, destination, [mob])
	if target == null:
		usePath = collision.size() != 0
	else:
		usePath = collision.collider != target

func free_resources() -> void:
	update_timer.queue_free()
