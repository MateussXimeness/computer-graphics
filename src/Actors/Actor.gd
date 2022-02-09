extends KinematicBody2D
class_name Actor

enum State { IDLE = 0, JUMP, RUN, ROLL, ATTACK, DEFEND, DEATH }
enum Direction { LEFT = 0, RIGHT , IN_PLACE }

export var speed := Vector2(300.0, 1000)
export var gravity := 3000.0

var velocity := Vector2.ZERO
var state: int = State.IDLE
var direction: int = Direction.RIGHT
