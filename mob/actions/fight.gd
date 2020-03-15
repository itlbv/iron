extends Action
class_name Fight

var attack_timer : Timer
var ATTACK_TIME : float = 1
var rnd : RandomNumberGenerator

func _init(owner: Mob, target: Mob).(owner, target):
	rnd = RandomNumberGenerator.new()
	attack_timer = Timer.new()
	set_attack_time()
	attack_timer.connect("timeout", self, "_attack_timer_timeout")
	mob.add_child(attack_timer)

func do() -> void:
	if attack_timer.is_stopped():
		attack_timer.start()
		_attack_timer_timeout()

func _attack_timer_timeout() -> void:
	mob.actions.animation.travel("attack")
	set_attack_time()
	target.defend()

func free_resources() -> void:
	attack_timer.queue_free()

func set_attack_time() -> void:
	rnd.randomize()
	var offset = rnd.randf_range(-0.2, 0.2)
	attack_timer.wait_time = ATTACK_TIME + offset
	if !attack_timer.is_stopped(): 
		attack_timer.start(ATTACK_TIME + offset)
