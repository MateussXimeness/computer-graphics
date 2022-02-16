extends Actor
class_name Player

enum State { IDLE = 0, JUMP, RUN, ROLL, ATTACK, DEFEND, DEAD }
enum Direction { LEFT = 0, RIGHT }

export var life: int = 1
export var defence: int = 2
export var damage: int = 3

var state: int = State.IDLE
var direction: int = Direction.RIGHT
var _currentAnimationName: String = idle

onready var _animation = $AnimationPlayer
onready var _sprite = $spriteNode
onready var _collision = $CollisionShape2D

const idle: String = "idle"
const jump: String = "jump"
const attack: String = "attack"
const defend: String = "defend"
const death: String = "death"
const roll: String = "roll"
const run: String = "run"

func _ready():
	_animation.play("idle")

func _on_SwordHitArea_area_entered(area):
	if state != State.ATTACK:
		return

	if area.is_in_group("hurtbox"):
		area.owner.takeDamage(self.damage)

func takeDamage(amount: int):
	var newLife = self.life

	if self.state == State.DEFEND:
		var remainingDamage = amount - defence
		newLife -= remainingDamage if remainingDamage > 0 else 0
	else:
		newLife -= amount

	self.life = newLife
	if self.life <= 0:
		self.state = State.DEAD
		_animation.play("death")

func _on_AnimationPlayer_animation_finished(anim_name):
	if self.state == State.DEAD:
		_gameOver()
		return
	if self.state != State.DEFEND:
		_resetSprite()
	
func _gameOver():
	queue_free()

func _input(event):
	if event.is_action_released("defend"):
		_resetSprite()
		return

	if !is_on_floor() or self.state == State.DEAD or state == State.DEFEND or state == State.ROLL or self.state == State.JUMP:
		return

	if event.is_action_pressed("jump"):
		_changeAnimation("jump")
		state = State.JUMP
	elif event.is_action_pressed(roll):
		_changeAnimation("roll")
		state = State.ROLL
	if event.get_action_strength("moveLeft") > event.get_action_strength("moveRight") and state != State.ROLL:
		state = State.RUN
		_changeAnimation(run)
		_changeDirection(Direction.LEFT)
	elif event.get_action_strength("moveRight") > event.get_action_strength("moveLeft") and state != State.ROLL:
		state = State.RUN
		_changeAnimation(run)
		_changeDirection(Direction.RIGHT)
	elif event.is_action_released("moveLeft") or event.is_action_released("moveRight"):
		_resetSprite()
	elif event.get_action_strength(attack) > 0 and state != State.DEAD:
		_changeAnimation(attack)
		state = State.ATTACK
	elif event.is_action_pressed(defend):
		_changeAnimation(defend)
		state = State.DEFEND
	else:
		if event is InputEventKey:
			if !event.pressed:
				_resetSprite()

func _physics_process(delta: float) -> void:
	if state == State.DEAD:
		_animation.play("death")
		return
		
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
	if animationName == _currentAnimationName or state == State.DEAD:
		return

	_animation.play(animationName)
	_currentAnimationName = animationName

func _changeDirection(newDirection: int):
	if newDirection == direction:
		return

	direction = newDirection

	var root = _animation.owner
	root.scale.x *= -1

func _resetSprite():
	var movingRightStrength = Input.get_action_strength("moveRight")
	var movingLeftStrength = Input.get_action_strength("moveLeft")

	if movingRightStrength > 0 or movingLeftStrength > 0:
		state = State.RUN
		_animation.play("run")
		_changeDirection(Direction.RIGHT if movingRightStrength > movingLeftStrength else Direction.LEFT)
	else:
		state = State.IDLE
		_changeAnimation(idle)
		return
