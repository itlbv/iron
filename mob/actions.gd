class_name Actions

var mob: Mob
var animation : AnimationNodeStateMachinePlayback
var sprite : Sprite
var actions = []

func _init(m: Mob):
	mob = m
	animation = mob.get_node("AnimationTree").get("parameters/playback")
	sprite = mob.get_node("Sprite")

func do() -> void :
	if not actions.empty():
		actions.front().do()

# last movement direction. right - false; left - true
var last_direction = false
func set_animation():
	var velocity = Vector2.ZERO
	if actions.front() is Move:
		velocity = actions.front().velocity
	else: 
		return
	if velocity.length() > 0:
		animation.travel("walk")
	# flip animation according to last movement direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	sprite.flip_h = last_direction

func add_move(target: Mob, position: Vector2) -> void:
	var move = Move.new(mob, target, position)
	actions.append(move)

func add_fight(target: Mob) -> void:
	var fight = Fight.new(mob, target)
	actions.append(fight)

func clear() -> void :
	for action in actions:
		action.free_resources()
	actions.clear()

func delete_current_action() -> void:
	if actions.empty():
		return
	actions.pop_front().free_resources()

func reset_attack_time() -> void:
	if actions.empty():
		return
	if actions.front() is Fight:
		actions.front().set_attack_time()

func melee_range_enter(body) -> void:
	if actions.empty():
		return
	if actions.front().target == body\
	and actions.front() is Move:
		actions[0].free_resources()
		actions.pop_front()
	
func melee_range_exit(body) -> void:
	if actions.empty():
		return
	if actions.front().target == body\
	and actions.front() is Fight:
		actions[0].free_resources()
		actions.pop_front()
		mob.fight_with(body)
