extends KinematicBody2D


var moveDur = 5
var moveLow = 50
var moveDirection = moveLow
var moveGrav = 0
var rayCast = -90


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	move_and_slide(Vector2(moveDirection, moveGrav), Vector2(0, -1)) #moves the enemy
	
	if(is_on_floor()):
		if($RayCast2D.is_colliding() == true):
			moveDur += 2
			moveGrav = -500
		else:
			moveGrav = 0
	else:
		if(moveGrav == 0):
			moveGrav = 150
		moveGrav += 20
	moveDur -= delta
	
	if($Area2D.overlaps_body($"/root/LevelAutoTileTest/Player") and abs(moveDirection) == moveLow):
		moveDirection *= 3
	elif(moveDur <= 0 and abs(moveDirection) == moveLow*3):
		moveDirection = moveDirection / 3
		
	if(moveDur <= 0):
		moveDur = int(rand_range(5.0, 1.0))
		moveDirection *= -1
		$Sprite.flip_h = !$Sprite.flip_h
		$CollisionPolygon2D.apply_scale(Vector2(-1, 1))
		rayCast *= -1
		$RayCast2D.set_cast_to(Vector2(rayCast, 0))
		
	print($RayCast2D.is_colliding(), is_on_floor())
	
	if($Area2D.overlaps_body($"/root/LevelAutoTileTest/Player") and abs(moveDirection) == moveLow):
		moveDirection *= 3
	elif(moveDur <= 0 and abs(moveDirection) == moveLow*3):
		moveDirection = moveDirection / 3
		
	
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass
