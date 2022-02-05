extends Node2D

func _ready():
	pass 


func _process(delta):
	
	$cloud1.position.x -= 1
	$cloud2.position.x -= 1
	
	if $cloud1.position.x <= -1015:
		$cloud1.position.x = 1015
	
	if $cloud2.position.x <= -1015:
		$cloud2.position.x = 1015
