extends Node2D

func _ready():
	pass 

func _input(event):
	if event is InputEventKey:
		if event.pressed:
			$texto/anim_texto.play("animar_texto")
			yield($texto/anim_texto,"animation_finished") 
			$ColorRect/anim_color.play("aniamr_color")
			yield($ColorRect/anim_color,"animation_finished")
			print("Mudar De Fase")
			get_tree().change_scene("res://src/Scenes/InitialScene/InitialScene.tscn")
			
