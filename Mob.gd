extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")
onready var navMap = get_tree().get_root().get_node("Main/NavMap")
onready var attack_timer = $AttackTimer
onready var move_timer = $MoveTimer
onready var movement = $Movement

var id = 1
var hp = 2
const SPEED = 100

var path
var usePath
var velocity = Vector2.ZERO

enum states {IDLE, MOVE, FIGHT}
var state = states.IDLE

var target setget set_target
var trg_pos

# last movement direction. right - false; left - true
var last_direction = false

func _ready():
	$IdLabel.text = str(id)

func _process(delta):
	_set_animation()
	movement.test()

func _set_animation():
	if velocity.length() > 0:
		animation.travel("walk")
	# flip animation according to last movement direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	$Sprite.flip_h = last_direction

func _physics_process(delta):
	match state:
		states.MOVE: _move()

func _move():
	if target == null: 
		_log("MOVE WHILE NO TARGET")
		return
	if usePath == null:
		_log("USEPATH IS NULL")
	_set_target_position()
	velocity = _get_path_velocity() if usePath else _get_steering_velocity()
	move_and_slide(velocity)

func _on_MoveTimer_timeout():
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

func _set_path():
	path = navMap.get_simple_path(position, trg_pos, false)

func set_target(trg):
	target = trg
	_set_target_position()
	_can_see_target()
	move_timer.start()
	state = states.MOVE

func _set_target_position():
	trg_pos = target if typeof(target) == TYPE_VECTOR2 else target.position

func _stop():
	_log("stop")
	velocity = Vector2.ZERO
	usePath = null
	path = null
	state = states.IDLE
	move_timer.stop()

func _on_MeleeRange_body_entered(body):
	if not typeof(target) == TYPE_OBJECT:
		return
	if body == target:
		_stop()
		_log("contact with target")
		state = states.FIGHT
		attack_timer.start()
		_on_AttackTimer_timeout()

func _on_MeleeRange_body_exited(body):
	"""
	if body == target:
		state = states.MOVE
		move_timer.start()
		attack_timer.stop()
	"""
func defend():
	yield(get_tree().create_timer(0.2), "timeout")
	hp -= 1
	if _is_dead():
		_die()
	else: animation.travel("hurt")

func _on_AttackTimer_timeout():
	_attack()

func _attack():
	if target._is_dead():
		target == null
		return
	animation.travel("attack")
	_log("attack " + str(target) + str(hp))
	if not target == null:
		target.defend()
		#target.attack_timer.start()

func _die():
	_log("die")
	animation.travel("die")
	attack_timer.stop()
	move_timer.stop()
	set_process(false)
	set_physics_process(false)

func _is_dead():
	return hp <= 0

func _log(msg):
	print(str(id) + ": " + msg)
