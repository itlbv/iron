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
	actions.clear()

func melee_range_enter(body) -> void:
	if actions.empty():
		return
	if actions.front().target == body\
	and actions.front() is Move:
		actions.pop_front()
	
func melee_range_exit(body) -> void:
	if actions.empty():
		return
	if actions.front().target == body\
	and actions.front() is Fight:
		actions.pop_front()
		mob.fight_with(body)
