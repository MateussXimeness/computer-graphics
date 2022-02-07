extends KinematicBody2D
class_name Actor

enum State { IDLE = 0, JUMP, RUN, ROLL, ATTACK, DEFEND, DEATH }

export var speed := Vector2(300.0, 1000)
export var gravity := 3000.0

var velocity := Vector2.ZERO
var state: int = State.IDLE
