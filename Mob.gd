extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")
onready var navMap = get_tree().get_root().get_node("Main/NavMap")
onready var attack_timer = $AttackTimer

onready var movement = $Movement

var id = 1
var hp = 2
const SPEED = 100

enum states {IDLE, MOVE, FIGHT}
var state = states.IDLE

var actions = []

var target setget set_target

# last movement direction. right - false; left - true
var last_direction = false

func _ready():
	$IdLabel.text = str(id)

func _process(delta):
	_set_animation()

func _set_animation():
	if movement.velocity.length() > 0:
		animation.travel("walk")
	# flip animation according to last movement direction
	if movement.velocity.x != 0:
		last_direction = movement.velocity.x < 0
	$Sprite.flip_h = last_direction

func _physics_process(delta):
	match state:
		states.MOVE: movement.move()

func set_target(trg):
	movement.set_target(trg)

func _on_MeleeRange_body_entered(body):
	if not typeof(target) == TYPE_OBJECT:
		return
	if body == target:
		movement.stop()
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
	#move_timer.stop()
	set_process(false)
	set_physics_process(false)

func _is_dead():
	return hp <= 0

func _log(msg):
	print(str(id) + ": " + msg)
