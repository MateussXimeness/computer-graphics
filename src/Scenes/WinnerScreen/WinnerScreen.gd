extends CanvasLayer


func _on_restart_pressed():
	get_tree().change_scene("res://src/Scenes/Level1/Mundo.tscn")


func _on_quit_pressed():
	get_tree().quit()
	
