extends Actor
class_name Player

const idle: String = "idle"
const jump: String = "jump"
const attack: String = "attack"
const defend: String = "defend"
const death: String = "death"
const roll: String = "roll"
const run: String = "run"

export var life: int = 5
export var defence: int = 10
export var damage: int = 8

var _currentAnimationName: String = idle

onready var _animation = $AnimationPlayer
onready var _sprite = $spriteNode
onready var _collision = $CollisionShape2D

func _ready():
	_animation.play("idle")

func _input(event):
	if !is_on_floor():
		return

	if event.is_action_released("defend"):
		_resetSprite()
		return

	if state == State.DEFEND:
		return

	if event.is_action_pressed(jump):
		_changeAnimation(jump)
		state = State.JUMP
	elif event.get_action_strength("moveLeft") and state != State.ROLL:
		state = State.RUN
		_changeAnimation(run)
		_changeDirection(Direction.LEFT)
	elif event.get_action_strength("moveRight") and state != State.ROLL:
		state = State.RUN
		_changeAnimation(run)
		_changeDirection(Direction.RIGHT)
	elif event.is_action_pressed(roll):
		_changeAnimation(roll)
		state = State.ROLL
	elif event.get_action_strength("attack") > 0:
		_changeAnimation(attack)
		state = State.ATTACK
	elif event.is_action_pressed("defend"):
		_changeAnimation(defend)
		state = State.DEFEND
	else:
		_changeDirection(Direction.IN_PLACE)
		_changeAnimation(idle)
		state = State.IDLE

	_normalizeSpriteDirection()

func _physics_process(delta: float) -> void:
	if state == State.DEFEND:
		return

	var directionVector := _getDirectionVector()
	velocity = _getVelocity(velocity, directionVector, speed)
	velocity = move_and_slide(velocity, Vector2.UP)
	return

func _getDirectionVector() -> Vector2:
	return Vector2(
		Input.get_action_strength("moveRight") - Input.get_action_strength("moveLeft"),
		-1.0 if Input.is_action_just_pressed("jump") and is_on_floor() else 1.0
	)

func _getVelocity(linearVelocity: Vector2, directionVector: Vector2, speed: Vector2) -> Vector2:
	var newVelocity = linearVelocity
	newVelocity.x = speed.x * directionVector.x
	newVelocity.y += gravity * get_physics_process_delta_time()
	if directionVector.y == -1.0:
		newVelocity.y = speed.y * directionVector.y
	return newVelocity

func _changeAnimation(animationName: String):
	if animationName == _currentAnimationName:
		return

	_animation.play(animationName)
	_currentAnimationName = animationName

func _changeDirection(newDirection: int):
	if newDirection == direction:
		return

	direction = newDirection

func _normalizeSpriteDirection():
	if direction == Direction.IN_PLACE:
		return

	var root = _animation.owner
	if (root.scale.x > 0 and direction == Direction.LEFT) or (root.scale.x < 0 and direction == Direction.RIGHT):
		root.scale.x *= -1

func _defend():
	_animation.stop()
	_changeDirection(Direction.IN_PLACE)

func _resetSprite():
	var isMovingRight = Input.is_action_pressed("moveRight")
	var isMovingLeft = Input.is_action_pressed("moveLeft")

	if isMovingRight and isMovingLeft:
		state = State.IDLE
		_changeAnimation(idle)
		_changeDirection(Direction.IN_PLACE)
		return

	state = State.RUN
	_animation.play("run")
	_changeDirection(Direction.RIGHT if isMovingRight else Direction.LEFT)
	_normalizeSpriteDirection()
