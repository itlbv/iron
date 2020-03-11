extends KinematicBody2D
class_name Mob

onready var actions = load("res://mob/actions.gd").new(self)

var id = 1
var hp = 2
const SPEED = 100

func _ready():
	$IdLabel.text = str(id)

func _process(delta):
	actions.set_animation()

func _physics_process(delta):
	actions.do()

func move_to_position(position: Vector2) -> void:
	actions.clear()
	actions.add_move(null, position)

func fight_with(target: Mob) -> void:
	actions.clear()
	actions.add_move(target, target.position)
	actions.add_fight(target)

func defend():
	yield(get_tree().create_timer(0.2), "timeout")
	hp -= 1
	if is_dead():
		_die()
	else: actions.animation.travel("hurt")

func _die():
	_log("die")
	actions.animation.travel("die")
	actions.clear()
	set_process(false)
	set_physics_process(false)

func is_dead():
	return hp <= 0

func _on_MeleeRange_body_entered(body):
	actions.melee_range_enter(body)

func _on_MeleeRange_body_exited(body):
	actions.melee_range_exit(body)

func _log(msg):
	print(str(id) + ": " + msg)
