class_name Actions

var owner: Mob
var actions = []

func _init(mob: Mob):
	owner = mob

func do() -> void :
	if not actions.empty():
		actions.front().do()

func add_move(target: Mob, position: Vector2) -> void:
	var move = Move.new(owner, target, position)
	actions.append(move)

func add_fight(target: Mob) -> void:
	var fight = Fight.new(owner, target)
	actions.append(fight)

func clear() -> void :
	actions.clear()
