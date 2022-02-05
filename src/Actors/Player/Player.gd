extends Actor

onready var _animationPlayer = $AnimationPlayer

func _physics_process(delta) -> void:
	_animationPlayer.play("idle")

	var direction := Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		1.0
	)

	velocity = speed * direction
	velocity = move_and_slide(velocity)
	
	return
