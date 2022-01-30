extends Node2D

func _ready():
	pass 


func _process(delta):
	
	$nuvem.position.x -= 1
	$nuvem2.position.x -= 1
	
	if $nuvem.position.x <= -1015:
		$nuvem.position.x = 1015
	
	if $nuvem2.position.x <= -1015:
		$nuvem2.position.x = 1015
