extends KinematicBody2D

const SPEED = 50
var path = []

onready var animation = $AnimationPlayer
onready var state_machine = $AnimationTree.get("parameters/playback")

func _ready():
	animation.play("idle") 

#func _process(delta):
#	pass

func _physics_process(delta):
	_movePath(delta)

func _movePath(delta):
	if path.size() == 0:
		return
	
	var start_point = position
	var distance = SPEED * delta
	for i in range(path.size()):
		var dist_to_next = start_point.distance_to(path[0])
		if distance <= dist_to_next and distance >= 0.0:
			position = start_point.linear_interpolate(path[0], distance / dist_to_next)
			break
		distance -= dist_to_next
		start_point = path[0]
		path.remove(0)

func _on_MeleeRange_body_entered(body):
	if body.get_name() == self.get_name():
		return 
	#animation.play("attack")
	state_machine.travel("die")
	set_physics_process(false)

func _on_MeleeRange_body_exited(body):
	animation.play("idle")