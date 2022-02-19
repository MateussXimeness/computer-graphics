extends Node

enum State {PLAYING, WIN, GAMEOVER}
var state = State.PLAYING

const winScene: String = "res://src/Scenes/WinnerScreen/WinnerScreen.tscn"
const gameOverScene: String = "res://src/Scenes/GameOverScreen/GameOverScreen.tscn"

onready var player = $Player

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	isPlayerDead()
	chooseAction()

func isPlayerDead():
	if !is_instance_valid(player):
		state = State.GAMEOVER

func chooseAction():
	if state == State.WIN:
		playScene(winScene)
	if state == State.GAMEOVER:
		playScene(gameOverScene)

func playScene(scene):
	get_tree().change_scene(scene)
