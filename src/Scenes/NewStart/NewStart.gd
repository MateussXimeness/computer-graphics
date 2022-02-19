extends CanvasLayer



func _on_START_pressed():
	get_tree().change_scene("res://src/Scenes/Level1/Mundo.tscn")


func _on_QUIT_pressed():
	 get_tree().quit()
