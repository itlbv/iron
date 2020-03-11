extends Node2D
class_name Action

var mob : Mob
var target : Mob

func _init(mob_owner: Mob, trg: Mob):
	mob = mob_owner
	target = trg

func do() -> void:
	pass

func free_resources() -> void:
	pass
