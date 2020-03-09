extends Action
class_name Fight

var attack_timer : Timer

func _init(owner: Mob, target: Mob).(owner, target):
	attack_timer = Timer.new()
	attack_timer.wait_time = 1
	attack_timer.connect("timeout", self, "_attack_timer_timeout")
	mob.add_child(attack_timer)

func do() -> void:
	if attack_timer.is_stopped():
		attack_timer.start()
		_attack_timer_timeout()

func _attack_timer_timeout() -> void:
	mob.actions.animation.travel("attack")
	target.defend()
