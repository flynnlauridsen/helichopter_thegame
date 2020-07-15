extends KinematicBody2D


var moveDur = 5
var moveLow = 50
var moveDirection = moveLow
var moveGrav = 0
var rayCast = -90
var playerDetect


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
# warning-ignore:return_value_discarded
	move_and_slide(Vector2(moveDirection, moveGrav), Vector2(0, -1)) #moves the enemy
	
	if(is_on_floor()):
		if($RayCast2D.is_colliding() == true):
			moveDur += 0.3
			moveGrav = -500
		else:
			moveGrav = 0
	else:
		if(moveGrav == 0):
			moveGrav = 150
		moveGrav += 20
	moveDur -= delta
	
		
	if(moveDur <= 0):
		moveDur = int(rand_range(5.0, 1.0))
		moveDirection *= -1
		if(moveDirection > 0):
			$Sprite.flip_h = true
		else:
			$Sprite.flip_h = false
		$CollisionPolygon2D.apply_scale(Vector2(-1, 1))
		rayCast *= -1
		$RayCast2D.set_cast_to(Vector2(rayCast, 0))
		
	
	playerDetect = get_tree().get_nodes_in_group("Player")[0]
	
	if($Area2D.overlaps_body(playerDetect)):
		if(abs(moveDirection) == moveLow):
			moveDirection *= 3
		if(playerDetect.get_position()[0] - self.get_position()[0] <= 0):
			$Sprite.flip_h = false
		else:
			$Sprite.flip_h = true
		
	elif(moveDur <= 0 and abs(moveDirection) == moveLow*3):
		moveDirection = moveDirection / 3
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
