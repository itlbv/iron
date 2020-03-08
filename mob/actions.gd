class_name Actions

var mob: Mob
var actions = []

func _init(m: Mob):
	mob = m

func do() -> void :
	if not actions.empty():
		actions.front().do()

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
