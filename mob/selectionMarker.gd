extends Node2D

var mob

func _process(delta):
	update()

func _draw():
	if (mob != null):
		var pos = Vector2(mob.position.x - 12, mob.position.y - 30)
		var rect = Rect2(pos, Vector2(24, 33))
		var col = Color(1, 0, 0, 1)
		draw_rect(rect,col, false)
