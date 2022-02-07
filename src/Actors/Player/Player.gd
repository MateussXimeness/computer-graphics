extends Actor
class_name Player

const idle: String = "idle"
const jump: String = "jump"
const attack: String = "attack"
const defend: String = "defend"
const death: String = "death"
const roll: String = "roll"
const run: String = "run"

var currentAnimationName: String = idle
onready var _animation = $AnimationPlayer
onready var _sprite = $spriteNode
onready var _collision = $CollisionShape2D

func _ready():
	_animation.play("idle")

func _input(event):
	if  !is_on_floor():
		return

	if event.is_action_pressed(jump):
		changeAnimation(jump)
		state = State.JUMP
	elif event.get_action_strength("moveLeft") > 0:
		changeAnimation(run)
		state = State.RUN
		if _sprite.scale.x > 0:
			_flipScale()
	elif event.get_action_strength("moveRight") > 0:
		changeAnimation(run)
		state = State.RUN
		if _sprite.scale.x < 0:
			_flipScale()
	elif event.is_action_pressed(roll):
		changeAnimation(roll)
		state = State.ROLL
	elif event.get_action_strength("attack") > 0:
		changeAnimation(attack)
		state = State.ATTACK
	elif event.get_action_strength("defend") > 0:
		changeAnimation(defend)
		state = State.DEFEND
	else:
		changeAnimation(idle)
		state = State.IDLE

func _flipScale():
	_sprite.scale.x *= -1
	_collision.scale.x *= -1

func _physics_process(delta: float) -> void:
	var direction := getDirection()
	velocity = getVelocity(velocity, direction, speed)
	velocity = move_and_slide(velocity, Vector2.UP)

	return

func getDirection() -> Vector2:
	return Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func getVelocity(linearVelocity: Vector2, direction: Vector2, speed: Vector2) -> Vector2:
	var newVelocity = linearVelocity
	newVelocity.x = speed.x * direction.x
	newVelocity.y += gravity * get_physics_process_delta_time()
	if direction.y == -1.0:
		newVelocity.y = speed.y * direction.y
	return newVelocity

func changeAnimation(animationName: String):
	if animationName == currentAnimationName:
		return

	_animation.play(animationName)
	currentAnimationName = animationName
