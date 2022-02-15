extends Actor
class_name EnemyOne

enum State {IDLE = 0, WALK, ATTACK, FALLBACK, HIT, DEAD}
var state: int = State.IDLE

export var life: int = 3
export var damage: int = 2

const idle: String = "idle"
const walk: String = "walk"
const attack: String = "attack"
const fallback: String = "fallback"
const hit: String = "hit"

const enemySpeed := Vector2(150.0, 1000.0)

onready var _animationPlayer = $AnimationPlayer
onready var _sprite = $Sprite
onready var _collision = $CollisionShape2D
onready var _clubCollision = $ClubHitArea

var bodyDetected = null

func _physics_process(_delta) -> void:
	chooseAction()

func _on_DetectRadius_body_entered(body):
	bodyDetected = body
	state = State.WALK

func _on_DetectRadius_body_exited(_body):
	bodyDetected = null
	state = State.IDLE

func _on_ClubHitArea_area_entered(area):
	if area.is_in_group("hurtbox"):
		area.owner.takeDamage(self.damage)

func _on_AttackArea_body_entered(_body):
	state = State.ATTACK

func _on_AttackArea_body_exited(_body):
	state = State.WALK

# This is the function that will be called by the damage logic to apply damage to the enemy
func takeDamage(amount: int):
	life -= amount
	if life <= 0:
		state = State.FALLBACK
	else:
		state = State.HIT

func chooseAction():
	if state == State.IDLE:
		enemyIdle()
	elif state == State.WALK:
		enemyWalk()
	elif state == State.ATTACK:
		enemyAttack()
	elif state == State.FALLBACK:
		enemyFallBack()
	elif state == State.HIT:
		enemyHit()
	elif state == State.DEAD:
		enemyDead()

func enemyIdle():
	changeAnimation(idle)
	var direction = Vector2(0, 1.0)
	velocity = enemySpeed * direction
	velocity = move_and_slide(velocity)

func enemyWalk():
	changeAnimation(walk)
	var direction = getDirection()
	if direction.x > 0 and _sprite.scale.x < 0:
		flipScale()
	elif direction.x < 0 and _sprite.scale.x > 0:
		flipScale()
	velocity = enemySpeed * direction
	velocity = move_and_slide(velocity)

func enemyAttack():
	changeAnimation(attack)

func enemyFallBack():
	changeAnimation(fallback)

func enemyHit():
	changeAnimation(hit)

func enemyDead():
	# Remove enemy from memory stack - Occurs automatically when the fallback animation ends
	if life <= 0:
		queue_free()

func getDirection() -> Vector2:
	return Vector2(bodyDetected.position.x - self.position.x, 1.0).normalized()

func changeAnimation(animationName: String):
	_animationPlayer.play(animationName)

func flipScale():
	_sprite.scale.x *= -1
	_collision.scale.x *= -1
	_clubCollision.scale.x *= -1
