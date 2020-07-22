extends "res://Code/enemyStandard.gd"


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	playerDetect = get_tree().get_nodes_in_group("Player")
	playerDetect = playerDetect[0] # Replace with function body.

func _physics_process(delta):
	enemyMovement(delta)
	
	enemyTurn(delta)
	
	get_tree().notify_group("Player", 50)
	
	
	playerPos = playerDetect.get_position()
	if(moveDur <= 0 and abs(moveDirection) == moveLow*3):
		moveDirection = moveLow
	if($Area2D.overlaps_body(playerDetect)):
		if(abs(moveDirection) == moveLow):
			moveDirection *= 3
		if(playerPos[0] - self.position[0] >= 0):
			$Sprite.set_flip_h(true)#gonna need to make the collision body flip as well
		else:
			$Sprite.set_flip_h(false)
			
	
		$GunCast.set_cast_to(Vector2(playerPos[0] * rand_range(0.7, 1.3), playerPos[1] *rand_range(0.7, 1.3)))	
		if(playerDetect == $GunCast.get_collider()):
			pass
	
		
			
		
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
