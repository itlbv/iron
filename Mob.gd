extends KinematicBody2D

onready var animation = $AnimationTree.get("parameters/playback")

const SPEED = 100
var path = []
var velocity

# direction of last movement. right - false; left - true
var last_direction = false

func _process(delta):
	_set_animation()

func _set_animation():
	if velocity.length() > 0:
		animation.travel("walk")
		
	# flipping animation according to the last direction
	if velocity.x != 0:
		last_direction = velocity.x < 0
	$Sprite.flip_h = last_direction

func _physics_process(delta):
	_move()

func _move():
	velocity = Vector2.ZERO
	while path.size() > 0:
		# get next waypoint
		if (position.distance_to(path[0]) < 5):
			path.remove(0)
			continue;
		var vec_to_next = path[0] - position
		velocity = vec_to_next.normalized() * SPEED
		break;
	move_and_slide(velocity)

func _on_MeleeRange_body_entered(body):
	if body.get_name() == self.get_name():
		return
	animation.travel("attack")

func _on_MeleeRange_body_exited(body):
	pass