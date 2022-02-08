extends Actor
class_name EnemyOne

const idle: String = "idle"
const walk: String = "walk"
const enemySpeed := Vector2(250.0, 1000.0)

onready var _animationPlayer = $AnimationPlayer
onready var _sprite = $Sprite
onready var _collision = $CollisionShape2D

var bodyDetected = null

func _ready():
	changeAnimation(idle)

func _physics_process(_delta) -> void:
	if bodyDetected:
		moveEnemy()
	else:
		changeAnimation(idle)

func _on_DetectRadius_body_entered(body):
	bodyDetected = body

func _on_DetectRadius_body_exited(_body):
	bodyDetected = null

func moveEnemy():
	changeAnimation(walk)
	var direction = getDirection()
	if direction.x > 0 and _sprite.scale.x < 0:
		flipScale()
	elif direction.x < 0 and _sprite.scale.x > 0:
		flipScale()
	velocity = enemySpeed * direction
	velocity = move_and_slide(velocity)

func getDirection() -> Vector2:
	return Vector2(bodyDetected.position.x - self.position.x, 1.0).normalized()

func changeAnimation(animationName: String):
	_animationPlayer.play(animationName)

func flipScale():
	_sprite.scale.x *= -1
	_collision.scale.x *= -1
